import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


class HandleTest:
    def __init__(self):
        pass
    def LoadData(self,path="",pattern="*MHz*.txt",mode=1):
        
        pass
    def LoadRecalc(self):
        pass


# File path
file_path = '2022-09-01 415MHz RvsB 3.50K.txt'

# Load the file into a DataFrame
nfile = pd.read_csv(
    file_path,
    sep="\t", 
    header=0,
    na_values="NaN",
    #parse_dates=[['Date', 'Time']],
    #date_format='%Y/%m/%d %H:%M:%S',
    #dtype=float
)

nfile['Date'] = pd.to_datetime(nfile['Date'] + ' ' + nfile['Time'], format='%Y/%m/%d %H:%M:%S')
nfile.drop(columns=["Time"], inplace=True)
nfile.rename(columns={"Date":"Date_Time"}, inplace=True)

print(nfile.info())
print(nfile.head())
ax = nfile.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")

# Save the plot as a vector-based PDF
#plt.savefig("scatter_plot.pdf", format="pdf", bbox_inches="tight")

#nfile.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")
plt.show()
