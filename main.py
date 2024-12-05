import glob, os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from funclib.importf import *

# File path
Test1 = HandleTest(r"D:\PhD\QPR Data\2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS")
Test1Data = Test1.LoadData("*41*MHz*.txt")

pd.set_option('display.max_rows', 100)
print(Test1Data.info())


#print(nfile["Surface Resistance [nOhm]"])
#ax = nfile.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")

# Save the plot as a vector-based PDF
#plt.savefig("scatter_plot.pdf", format="pdf", bbox_inches="tight")

Test1Data.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")
plt.show()
