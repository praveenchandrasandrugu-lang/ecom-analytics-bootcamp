import sys
import pandas as pd

print("Python executable:", sys.executable)
print("Python version:", sys.version.split()[0])
print("Pandas version:", pd.__version__)

df = pd.DataFrame({"a": [1, 2, 3], "b": [10, 20, 30]})
print(df)