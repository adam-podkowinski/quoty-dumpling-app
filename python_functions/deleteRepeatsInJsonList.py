import json
from os import path

basepath = path.dirname(__file__)
filepath = path.abspath(
    path.join(basepath, "..", "assets", "quotes", "quotes.json"))

with open(filepath) as f:
    data = json.load(f)

wasInList = []

dataCopy = data.copy()
print(len(dataCopy))

for x in data:
    if x["quoteText"] in wasInList:
        dataCopy.remove(x)
    else:
        wasInList.append(x["quoteText"])

print(len(dataCopy))

with open(filepath, 'w') as f:
    json.dump(dataCopy, f, indent=2)
