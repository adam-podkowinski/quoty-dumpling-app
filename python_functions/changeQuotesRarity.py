import json
from os import path

basepath = path.dirname(__file__)
filepath = path.abspath(
    path.join(basepath, "..", "assets", "quotes", "quotes.json"))

checked = False

print('Welcome in rarity changing application.\nMake sure that \'quotes.json\' file is in project directory!')
while checked is False:
    commonPercentage = float(input('Type common unlocking propability: '))
    rarePercentage = float(input('Type rare unlocking propability: '))
    epicPercentage = float(input('Type epic unlocking propability: '))
    legendaryPercentage = float(
        input('Type legendary unlocking propability: '))

    if commonPercentage > 1 or rarePercentage > 1 or epicPercentage > 1 or legendaryPercentage > 1:
        print('All propabilities must be less or equal to 1')
    else:
        checked = True

with open(filepath) as f:
    data = json.load(f)

for n in range(len(data)):
    if n <= (len(data) * commonPercentage):
        data[n]['rarity'] = 'common'
    elif n <= (len(data) * (rarePercentage + commonPercentage)):
        data[n]['rarity'] = 'rare'
    elif n <= (len(data) * (epicPercentage + rarePercentage + commonPercentage)):
        data[n]['rarity'] = 'epic'
    elif n <= (len(data) * (legendaryPercentage + epicPercentage + rarePercentage + commonPercentage)):
        data[n]['rarity'] = 'legendary'

with open(filepath, 'w') as f:
    json.dump(data, f, indent=2)
