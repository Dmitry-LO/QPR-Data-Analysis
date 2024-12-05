import glob, os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# File path
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

pd.set_option('display.max_rows', 100)
print(nfile.info())
#print(nfile["Surface Resistance [nOhm]"])

nan_rows = nfile[nfile["Surface Resistance [nOhm]"].isna()]
print(nan_rows)
#ax = nfile.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")

# Save the plot as a vector-based PDF
#plt.savefig("scatter_plot.pdf", format="pdf", bbox_inches="tight")

#nfile.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")
#plt.show()
