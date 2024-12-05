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
            
            if procfile.isna().all().all():
                print(f"File {file_path} contains an all-NaN DataFrame and will be skipped.")
            else:
                nfilelist.append(procfile)


        try:
            nfile=pd.concat(nfilelist, ignore_index=True)
            nfile['Date'] = pd.to_datetime(nfile['Date'] + ' ' + nfile['Time'], format='%Y/%m/%d %H:%M:%S')
            nfile.drop(columns=["Time"], inplace=True)
            nfile.rename(columns={"Date":"Date_Time"}, inplace=True)
            return nfile
        except Exception as e:
            print(color.BOLD + color.RED + "Exeption raised: " + color.END + color.END + str(e))
            nfile=pd.DataFrame()
            return nfile
    def LoadRecalc(self):
        pass