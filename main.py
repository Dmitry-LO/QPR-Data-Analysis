import glob, os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from funclib.importf import *

script_dir = os.path.dirname(os.path.abspath(__file__))
phd_dir = os.path.dirname(script_dir)
TestPath = os.path.join(phd_dir, "QPR Data", "2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS")
#TestPath=r"D:\PhD\QPR Data\2022-04-04 - test #36 - ARIES B-3.19 Siegen SIS"


# File path
Test1 = HandleTest(TestPath)
Test1Data = Test1.LoadData("*41*MHz*.txt")

pd.set_option('display.max_rows', 100)
print(Test1Data.info())


#print(nfile["Surface Resistance [nOhm]"])
#ax = nfile.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")

# Save the plot as a vector-based PDF
#plt.savefig("scatter_plot.pdf", format="pdf", bbox_inches="tight")

Test1Data.plot.scatter(x="Peak Field on Sample [mT]", y="Surface Resistance [nOhm]")
plt.show()
