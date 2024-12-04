import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

# File path
file_path = '2022-09-01 415MHz RvsB 3.50K.txt'
file_path2 = '2022-09-01 415MHz RvsB 3.50K-2.txt'
pathlist = [file_path, file_path2]

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

pd.set_option('display.max_rows', None)
print(nfile.info())
print(nfile)
#ax = nfile.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")

# Save the plot as a vector-based PDF
#plt.savefig("scatter_plot.pdf", format="pdf", bbox_inches="tight")

#nfile.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")
#plt.show()
