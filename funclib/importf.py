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

class HandleTest:
    def __init__(self,Path):
        self.TestPath=Path
    
    def LoadData(self,pattern="*MHz*.txt"):
        pattern = os.path.join(self.TestPath, pattern)
        pathlist = glob.glob(pattern)

        nfilelist=[]
        # Load all files and compose them into a DataFrame object
        for file_path in pathlist:
            procfile= pd.read_csv(
                file_path,
                sep="\t", 
                header=0,
                na_values="NaN",
            )
            
            if procfile.empty:
                print(f"File {file_path} contains No Data and will be skipped.")
                pass
            else:
                procfile["Run"] = 1
                nfilelist.append(procfile)


        try:
            nfile=pd.concat(nfilelist, ignore_index=True)
            nfile['Date'] = pd.to_datetime(nfile['Date'] + ' ' + nfile['Time'], format='%Y/%m/%d %H:%M:%S')
            nfile.drop(columns=["Time"], inplace=True)
            nfile.rename(columns={"Date":"Date_Time"}, inplace=True)
            self.Data = nfile
            return self.Data
        except Exception as e:
            print(color.BOLD + color.RED + "Exeption raised: " + color.END + color.END + str(e))
            self.Data=pd.DataFrame()
            return self.Data
    
    def LoadRecalc(self):
        pass
    
    def plotHistogram(self,**kwargs):
        x = kwargs.get("x", "Peak Field on Sample [mT]")
        y = kwargs.get("y", "Surface Resistance [nOhm]")
        step = kwargs.get("step", 1.0)
        Run = kwargs.get("Run", None)

        # Filtering data Corresponding to RunN
        if Run is None:
            Dataset = self.Data  # Take all Runs
        else:
            Dataset = self.Data[self.Data["Run"].isin(Run)]

        MaxX=Dataset[x].max()+step
        self.HistoX=list(np.arange(0,MaxX,step))
        self.HistoY=[]

        #calculating count of number of points in each interval
        for point in self.HistoX:
            DataRange = Dataset[(Dataset[x] >= point - step / 2) & (Dataset[x] < point + step / 2)][x]
            self.HistoY.append(DataRange.count())

        
        # Create the figure and first Y-axis
        fig, ax1 = plt.subplots()
        # Plot histogram on the first Y-axis
        ax1.bar(self.HistoX, self.HistoY, width=1.0, align='center', alpha=0.7, label="Histogram")
        ax1.set_xlabel("Peak Field [mT]")
        ax1.set_ylabel("Point Number", color="blue")
        ax1.tick_params(axis="y", labelcolor="blue")
        ax1.grid(True)

        # Create the second Y-axis
        ax2 = ax1.twinx()
        ax2.scatter(self.Data[x], self.Data[y], color="red", label="Scatter Plot")
        ax2.set_ylabel("Surface Resistance [nOhm]", color="red")
        ax2.tick_params(axis="y", labelcolor="red")

        # Add legends
        ax1.legend(loc="upper left")
        ax2.legend(loc="upper right")

        # Set title
        plt.title("Histogram with Scatter Overlay")
        plt.show()

        pass