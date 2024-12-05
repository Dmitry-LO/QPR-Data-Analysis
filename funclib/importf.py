import glob, os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


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
            nfilelist.append(procfile)
        nfile=pd.concat(nfilelist, ignore_index=True)
        nfile['Date'] = pd.to_datetime(nfile['Date'] + ' ' + nfile['Time'], format='%Y/%m/%d %H:%M:%S')
        nfile.drop(columns=["Time"], inplace=True)
        nfile.rename(columns={"Date":"Date_Time"}, inplace=True)
        return nfile
    
    def LoadRecalc(self):
        pass