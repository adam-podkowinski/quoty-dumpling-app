from os import path
import json
import random
import string

basepath = path.dirname(__file__)
filepath = path.abspath(
    path.join(basepath, "..", "assets", "quotes", "quotes.json"))

usedIds = []

with open(filepath) as f:
    data = json.load(f)
    for e in data:
        try:
            if (e['id'] is None):
                pass
        except KeyError:
            e['id'] = ''
            pass

for e in data:
    if e['id'] is not '':
        usedIds.append(e['id'])

for e in data:
    if e['id'] is not '':
        continue
    checked = False
    while not checked:
        randomId = ''.join([random.choice(string.ascii_letters
                                          + string.digits) for n in range(8)])
        if randomId in usedIds:
            continue
        else:
            e['id'] = randomId
            checked = True

with open(filepath, 'w') as f:
    json.dump(data, f, indent=2)

print(data)
