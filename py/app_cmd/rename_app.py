import subprocess
import os
import shutil

appName = "POS Billing"
bundleId = "com.ganpatitechnologies.posbilling"
flavor = "posbilling"



# # For Window
# dirInfoCMD = "dir"

# For Linux/Mac
dirInfoCMD = "ls"



def setAppInfo():
    commands = [
        # 'dart pub global activate rename',
        f'rename setAppName --targets ios,android --value "{appName}"', 
        f'rename setBundleId --targets android --value "{bundleId}"',
        f'dart run flutter_native_splash:create --flavor {flavor}', 
        f'dart run icons_launcher:create --path {flavor}_icons_launcher.yaml', 
    ]

    


    for cmd in commands:
          print(f"cmd : {cmd}")
          result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
          print(result.stdout)

# moving to lib dir


i = 0

while i < 5 :
    result = subprocess.run(dirInfoCMD, shell=True, capture_output=True, text=True)
    dirInfo = str(result.stdout).lower()
    if 'lib' in dirInfo and 'pubspec.yaml' in dirInfo:
        setAppInfo()
        break
    i+=1



## web setup


# base_input_path = "./white_label/web"
# base_output_path = "./web"

# def isValidFile(name):
#     for ext in [".html",".ico"]:
#         if ext in name:
#             return True
#     return False


# for file in os.listdir(base_input_path):
#     if not (isValidFile(file)):
#         continue
#     if flavor in file: 
#         outName = file.replace(f"{flavor}_","")
#         shutil.copy(f"{base_input_path}/{file}", f"{base_output_path}/{outName}")

        


