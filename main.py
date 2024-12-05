import glob, os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from funclib.importf import *

# File path
<<<<<<< HEAD
Test1 = HandleTest(r"D:\PhD\QPR Data\2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS")
Test1Data = Test1.LoadData("*41*MHz*.txt")
=======
script_dir = os.path.dirname(os.path.abspath(__file__))
phd_dir = os.path.dirname(script_dir)
TestPath = os.path.join(phd_dir, "QPR Data", "2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS")
#TestPath=r"D:\PhD\QPR Data\2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS"

pattern = os.path.join(TestPath, "*MHz*.txt")
pathlist = glob.glob(pattern)

nfilelist=[]

# Load the file into a DataFrame
for file_path in pathlist:
    procfile= pd.read_csv(
        file_path,
        sep="\t", 
        header=0,
        na_values="NaN",
        #parse_dates=[['Date', 'Time']],
        #date_format='%Y/%m/%d %H:%M:%S',
        #dtype=float
    )
    nfilelist.append(procfile)

nfile=pd.concat(nfilelist, ignore_index=True)


nfile['Date'] = pd.to_datetime(nfile['Date'] + ' ' + nfile['Time'], format='%Y/%m/%d %H:%M:%S')
nfile.drop(columns=["Time"], inplace=True)
nfile.rename(columns={"Date":"Date_Time"}, inplace=True)
>>>>>>> fc165bafb18b2b92281e924c0f61ae650303868c

pd.set_option('display.max_rows', 100)
print(Test1Data.info())


#print(nfile["Surface Resistance [nOhm]"])
#ax = nfile.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")

# Save the plot as a vector-based PDF
#plt.savefig("scatter_plot.pdf", format="pdf", bbox_inches="tight")

Test1Data.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")
plt.show()
