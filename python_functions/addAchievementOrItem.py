import json
from os import path

basepath = path.dirname(__file__)

choice = input(
    "What do you wanna add?\n1. Achievement\n2.Item(not implemented yet)\n")

filename = ""
if choice == "1":
    filename = "achievements"
else:
    filename = "items"

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
    maxToDoVal = int(input("\nMax to do value: "))
    billsReward = int(input("\nBills reward: "))
    diamondsReward = int(input("\nDiamonds reward: "))

    data.append(
        {"id": nextId, "title": title, "description": description, "maxToDoVal": int(maxToDoVal),
         "billsReward": billsReward, "diamondsReward": diamondsReward})
    print(data)

elif choice == "2":
    name = input("\nName: ")
    description = input("\nDescription: ")
    item_type_inp = input("""
What's the item type (input a number)
1) upgrade
2) powerup
3) money
Your choose: """)
    switcher = {
        "1": "upgrade",
        "2": "powerup",
        "3": "money"
    }
    item_type = switcher.get(item_type_inp, "Invalid type!")
    use_case_inp = input("""
What's the use case for your item (input a number):
1) billsOnClick
2) clickMultiplier
3) billsOpening
4) bills""")
    switcher = {
        "1": "billsOnClick",
        "2": "clickMultiplier",
        "3": "billsOpening",
        "4": "bills"
    }
    useCase = switcher.get(use_case_inp, "Invalid use case!")
    default_price_bills = input("Default bills price: ")
    default_price_diamonds = input("Default diamonds price: ")
    price_usd = input("Default USD price: ")
    use_tim = input("Use time: ")

    exit(0)


with open(filepath, 'w') as f:
    json.dump(data, f, indent=2)
