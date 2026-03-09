import os
import json
from pathlib import Path
import subprocess

translations = {}
currentDir = Path(__file__).parent






def loadJson(path):
    with open(path, "r", encoding="utf-8") as f:
        try:
            return json.load(f)
        except :
            return {}



def addTranslation(lang,key,value):
    if translations.get(lang) != None:
        translations[lang][key] = value
    else:
        translations[lang] = {key : value}



# json_path = currentDir / "translation_v1.json"
dataV1 = loadJson(currentDir / "translation_v1.json")

for key, value in dataV1.items():

    addTranslation("en",key,key)
    if isinstance(value,dict):
        for key0, value0 in value.items():
            addTranslation(key0,key,value0)

    

# print(translations)


for lang, dataV1 in translations.items():
    fileName = f"{lang}.i18n.json"
    trdir = "./lib/i18n"
    with open(f"{trdir}/{fileName}","w+",encoding="utf-8") as f:
        json.dump(dataV1, f, ensure_ascii=False, indent=2)

cmd = "dart run slang"

result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
print(result.stdout)