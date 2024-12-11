import glob, os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from funclib.fieldnames import *

class color:
   PURPLE = '\033[95m'
   CYAN = '\033[96m'
   DARKCYAN = '\033[36m'
   BLUE = '\033[94m'
   GREEN = '\033[92m'
   YELLOW = '\033[93m'
   RED = '\033[91m'
   BOLD = '\033[1m'
   UNDERLINE = '\033[4m'
   END = '\033[0m'

def in_range_index(data,param,value,tol):
    index_list = data[(data[param]>=(value-tol)) & (data[param]<=(value+tol))].index

    return index_list 

def filter_by_param(data, param, value, tol, *args, **kwargs):
    """
    Filters rows in a DataFrame based on whether the values in a specified column 
    lie within a given range.

    Parameters:
        data (pd.DataFrame): The DataFrame to filter.
        param (str): The name of the column used for filtering.
        value (float): The central value of the range for filtering.
        tol (float): The tolerance to define the range (value ± tol).
        *args (str): Names of columns to include in the output. If empty, includes all columns.
        **kwargs:
            Print (bool, optional): If True, prints the filtered DataFrame. Default is False.

    Returns:
        pd.DataFrame: A DataFrame containing the filtered rows and specified columns.
    """
    
    selected_columns = list(args) if args else data.columns  # Use all columns if no args provided
    returned_data = data.loc[((data[param] >= (value - tol)) & (data[param] <= (value + tol))), selected_columns]
    
    if kwargs.get("Print", False): 
        print(returned_data)

    return returned_data


class HandleTest:
    def __init__(self,path,**kwargs):
        self.test_path=path
        self.debug = kwargs.get("debug", False)
    
    ## The function to load All data based on Pattern
    def load_data(self,pattern="*MHz*.txt"):
        """
        Loads and processes data files matching a specified pattern.

        This function searches for files within the specified eqrlier 
        directory that match the provided filename pattern. It reads the 
        content of the matching files into a pandas DataFrame, processes the data 
        (e.g., adds a "Run" column and filename), and combines all files into a 
        single DataFrame.

        Parameters:
            pattern (str, optional): A wildcard pattern to search for files.
                                    Defaults to "*MHz*.txt".

        Returns:
            pd.DataFrame: A DataFrame containing the combined and processed data
                        from all matching files. If an exception occurs, an
                        empty DataFrame is returned.
        """
        
        pattern = os.path.join(self.test_path, pattern)
        pathlist = glob.glob(pattern)
        

        try:
            # Raise an exception if no files match the pattern
            if not pathlist:
                raise ValueError("No Data found with this pattern!!")
            
            nfilelist=[]
            # Load all files and compose them into a DataFrame object
            for file_path in pathlist:
                procfile = pd.read_csv(
                    file_path,
                    sep="\t", 
                    header=0,
                    na_values="NaN",
                )
                file_name = os.path.basename(file_path)
                if procfile.empty:
                    if self.debug: print(f"File {file_path} contains No Data and will be skipped.")
                    pass
                else:
                    runloc=file_name.find(FieldNames.RUNMARK) # Finding Run Number inside file name
                    extracted_run = file_name[runloc + 3:runloc + 5].strip("_.-")

                    if self.debug: 
                        print(
                            f"In your file {color.RED}{file_name}{color.END}, "
                            f"Run loc was: {color.RED}{runloc}{color.END} "
                            f"And extracted number: {extracted_run}"
                        )
                    procfile[FieldNames.RUN] = int(extracted_run) if (runloc > 0) else None 
                    procfile[FieldNames.FNAME] = file_name
                    nfilelist.append(procfile)

            nfile=pd.concat(nfilelist, ignore_index=True)
            nfile[FieldNames.DATE] = pd.to_datetime(nfile[FieldNames.DATE] + ' ' + nfile[FieldNames.TIME], format='%Y/%m/%d %H:%M:%S')
            nfile.drop(columns=[FieldNames.TIME], inplace=True)
            nfile.rename(columns={FieldNames.DATE:FieldNames.DATETIME}, inplace=True)
            self.data = nfile
            return self.data
        except Exception as e:
            print(color.BOLD + color.RED + "Exeption raised: " + color.END + color.END + str(e))
            self.data=pd.DataFrame()
            return self.data
    
    def load_recalc(self):
        pass
    
    def plot_histogram(self,**kwargs):
        """
        Returns Dataframe of selected Run, x y x_err y_err
        """
        x = kwargs.get("x", FieldNames.PEAK_FIELD)
        y = kwargs.get("y", FieldNames.RS) #second scatter plot
        ParamName = kwargs.get("ParamName", FieldNames.SENS_B) #parameter
        ParamVal = kwargs.get("ParamVal", 2.5)
        ParamTol = kwargs.get("ParamTol", 0.05)

        step = kwargs.get("step", 1.0)
        Run = kwargs.get("Run", None)

        # User Input Normalization: let's make sure 'Run' is always a list
        Run = [Run] if not isinstance(Run, list) else Run

        Dataset = filter_by_param(self.data, ParamName, ParamVal, ParamTol) 
        
        # Filtering data Corresponding to RunN; Takes all Runs if None is entered
        if Run  != [None]:
            # Filter only data corresponding to entered Run N list
            Dataset = Dataset[Dataset["Run"].isin(Run)] 

        self.HistogramData = Dataset
        try:
            if Dataset.empty:
                raise ValueError("No Data found with Run and/or Parameter!!")
            
            MaxX=Dataset[x].max()+step
            self.HistoX=list(np.arange(0,MaxX,step))
            self.HistoY=[]

            #calculating count of number of points in each interval
            for point in self.HistoX:
                DataRange = Dataset[(Dataset[x] >= point - step / 2) & (Dataset[x] < point + step / 2)][x]
                self.HistoY.append(DataRange.count())
        

            return self.HistoX, self.HistoY, Dataset[x], Dataset[y]

        except Exception as e:
            print(color.BOLD + color.RED + "Exeption raised: " + color.END + color.END + str(e))
        
    def filter_data(self, **kwargs):
        x_axis = kwargs.get("x", FieldNames.PEAK_FIELD)
        y_axis = kwargs.get("y", FieldNames.RS) #second scatter plot
        param_name = kwargs.get("param_name", FieldNames.SENS_B) #parameter
        param_val = kwargs.get("param_val", 2.5)
        param_tol = kwargs.get("param_tol", 0.05)
        res = kwargs.get("Res", 1.0)
        run = kwargs.get("Run", None)

        # User Input Normalization: let's make sure 'Run' is always a list
        run = [run] if not isinstance(run, list) else run

        dataset = filter_by_param(self.data, param_name, param_val, param_tol) 
        
        # Filtering data Corresponding to RunN; Takes all Runs if None is entered
        if run  != [None]:
            # Filter only data corresponding to entered Run N list
            dataset = dataset[dataset["Run"].isin(run)] 

        self.FilteredData = dataset

        max_x=dataset[x_axis].max() + res

        index = 0
        sum = 0
        npoint = 0
        avg =[]
        while index <= dataset[x_axis].indexmax():
            avg.append(dataset[index, x_axis])
            index += 1
            npoint += 1


        
        #for
        #  
        pass