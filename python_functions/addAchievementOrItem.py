import json
from os import path

basepath = path.dirname(__file__)

choice = input("What do you wanna add?\n1. Achievement\n2.Item(not implemented yet)\n")

filename = ""
if choice == "1":
    filename = "achievements"
else:
    filename = "items"
    print("Ending program...\n")
    exit(0)

filepath = path.abspath(
    path.join(basepath, "..", "assets", filename, filename + ".json"))

with open(filepath) as f:
    data = json.load(f)

lastId = data[-1]["id"]
nextId = lastId

nextId = list(nextId)


def findNextId(nextIdList, n):
    if nextIdList[n] != "9":
        intNextIdDigit = int(nextIdList[n])
        intNextIdDigit += 1
        nextIdList[n] = str(intNextIdDigit)
    elif n != 0:
        nextIdList[n] = "0"
        findNextId(nextIdList, n - 1)
    else:
        print("No ids left")


findNextId(nextId, 2)
nextId = "".join(nextId)
print("\nID: ", nextId)

if choice == "1":
    title = input("\nTitle: ")
    description = input("\nDescription: ")
    maxToDoVal = input("\nMax to do value: ")

    data.append(
        {"id": nextId, "title": title, "description": description, "maxToDoVal": int(maxToDoVal)})
    print(data)

with open(filepath, 'w') as f:
    json.dump(data, f, indent=2)
