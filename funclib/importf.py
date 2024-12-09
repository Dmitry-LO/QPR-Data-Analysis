import glob, os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

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

class FieldNames:
    """
    Column names in the data file. Edit if something changes!

    Key Fields:
        PEAK_FIELD: "Peak Field on Sample [mT]".
        SENS_A: "LS336 A [K]" (similarly for B, C, D).
        SET_TEMP: Set Temp [K].
        RS: Surface Resistance [nOhm].
    """
    
    SET_TEMP = "Set Temp [K]"
    SET_FREQ = "Set Freq [Hz]"
    DUTY_CYCLE = "Duty Cycle [%]"
    PULSE_PERIOD = "Pulse Period [ms]"
    P_FORW = "P_forw (giga)"
    P_REFL = "P_refl (giga)"
    P_TRANS = "P_trans (giga)"
    CW_POWER = "CW Power (Tek)"
    PULSE_POWER = "Pulse Power (Tek)"
    PEAK_POWER = "Peak Power (Tek)"
    DC_MEAS = "DC meas [%] (Tek)"
    P_TRANS_CALC = "P_trans for calc"
    FREQ_MEAS = "Freq. (meas.) [Hz]"
    Q_FPC = "Q_FPC"
    Q_PROBE = "Q_Probe"
    C1 = "c1"
    C2 = "c2"
    HEATER_RESISTANCE = "Heater Resistance [Ohm]"
    REF_V = "Ref. Voltage"
    HEATER_V = "Heater Voltage"
    HEATER_P = "Heater Power [mW]"
    P_DISS = "P_diss [mW]"
    PEAK_FIELD = "Peak Field on Sample [mT]"
    RS = "Surface Resistance [nOhm]"
    SENS_A = "LS336 A [K]"
    SENS_B = "LS336 B [K]"
    SENS_C = "LS336 C [K]"
    SENS_D = "LS336 D [K]"
    MAGNETIC_FIELD = "Magnetic Field [uT]"
    PLL_ATTENUATOR = "PLL Attenuator [dB]"
    PLL_PHASE = "PLL Phase [deg]"
    KEYSIGHT_FORW = "Keysight forw [dBm]"
    KEYSIGHT_REFL = "Keysight refl [dBm]"
    KEYSIGHT_TRANS = "Keysight trans [dBm]"
    DC_CURRENT = "DC current [mA]"
    DC_REF_CURRENT = "DC Ref current [mA]"
    FREQ_HAMEG = "Freq Hameg [Hz]"
    DATE = "Date"
    TIME = "Time"
    # Those columns will be added:
    RUN = "Run"
    FNAME = "File Name"
    DATETIME = "Date_Time"
    # Auxillary
    RUNMARK = "Run" #Pattern which will be looked to determain the run numner in filename

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
    def __init__(self,path):
        self.test_path=path
    
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
                    print(f"File {file_path} contains No Data and will be skipped.")
                    pass
                else:
                    runloc=file_name.find(FieldNames.RUNMARK) # Finding Run Number inside file name
                    procfile[FieldNames.RUN] = int(file_name[runloc + 4:runloc + 6].strip("_.")) if runloc > 0 else None
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
        ParamName = kwargs.get("y", FieldNames.SENS_B) #parameter
        ParamVal = kwargs.get("ParamVal", 2.5)
        ParamTol = kwargs.get("ParamTol", 0.05)
        print(ParamVal)

        step = kwargs.get("step", 1.0)
        Run = kwargs.get("Run", None)

        # User Input Normalization: let's make sure 'Run' is always a list
        Run = [Run] if not isinstance(Run, list) else Run

        Dataset = filter_by_param(self.data, ParamName, ParamVal, ParamTol) 
        
        # Filtering data Corresponding to RunN; Takes all Runs if None is entered
        if Run  != [None]:
            # Filter only data corresponding to entered Run N list
            Dataset = Dataset[Dataset["Run"].isin(Run)] 

        self.FilteredData = Dataset
        try:
            print(Dataset[ParamName])
            if Dataset.empty:
                raise ValueError("No Data found with Run and/or Parameter!!")
            
            MaxX=Dataset[x].max()+step
            self.HistoX=list(np.arange(0,MaxX,step))
            self.HistoY=[]

            #calculating count of number of points in each interval
            for point in self.HistoX:
                DataRange = Dataset[(Dataset[x] >= point - step / 2) & (Dataset[x] < point + step / 2)][x]
                self.HistoY.append(DataRange.count())
        
            # Create the figure and first Y-axis
            fig, ax1 = plt.subplots(dpi=100)

            # Plot histogram on the first Y-axis
            ax1.bar(self.HistoX, self.HistoY, width=step, align='center', alpha=0.7, label="Histogram")
            ax1.set_xlabel("Peak Field [mT]")
            ax1.set_ylabel("Point Number", color="blue")
            ax1.tick_params(axis="y", labelcolor="blue")
            ax1.grid(True)

            # Create the second Y-axis and Plot Surface Resistance
            ax2 = ax1.twinx()
            ax2.scatter(Dataset[x], Dataset[y], color="red", label="Scatter Plot", s=2)
            ax2.set_ylabel("Surface Resistance [nOhm]", color="red")
            ax2.tick_params(axis="y", labelcolor="red")

            # Add legends
            ax1.legend(loc="upper left")
            ax2.legend(loc="upper right")

            # Set title
            plt.title("Histogram with Scatter Overlay")
            plt.show()

        except Exception as e:
            print(color.BOLD + color.RED + "Exeption raised: " + color.END + color.END + str(e))

        pass