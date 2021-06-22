import pandas as pd
from matplotlib import pyplot as plt
plt.style.use("fivethirtyeight")

file = open("latestresult.csv", "r")

data = file.read()

passes = data.count("Pass:")
fails = data.count("Fail:")


slices = [passes, fails]
labels = ['Passes', 'Fails']

plt.pie(slices, labels=labels, autopct='%1.1f%%')

plt.title("Pass/Fail graph")
plt.show()

