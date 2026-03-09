import os
import re


# Validating path is file or folder
def isfile(basename:str):
    return re.match(r".*\.[a-z]{2,15}$", basename)

def splitPath(path):
    return re.split(r"[\\/]",path)


def create_dir(path):
    fullPath:str = os.path.abspath(path) 
    pathParts = splitPath(fullPath)
    basename = os.path.basename(fullPath)
    if "lib" not in pathParts:
        print("lib folder not found !")
        return
    
    if os.path.exists(fullPath):
        print(f"{path}::alredy exists.")
        return
    
    

    if isfile(basename):
        dir_path = os.path.dirname(fullPath)
        os.makedirs(dir_path ,exist_ok=True)
        with open(fullPath, 'w') as file:
            file.write("// Auto generated.")
        print(f"{path}::file created successfully.")   
        return
    else:
        os.makedirs(fullPath ,exist_ok=True)
        print(f"{fullPath}::folder created successfully.")
        return
    





lib_feature = [
# Data
"lib/features/#feature#/data/source/local",
"lib/features/#feature#/data/source/local/#feature#_local_source.dart",
"lib/features/#feature#/data/source/remote",
"lib/features/#feature#/data/source/remote/#feature#_remote_source.dart",
"lib/features/#feature#/data/models",
"lib/features/#feature#/data/repo_impl",
"lib/features/#feature#/data/repo_impl/#feature#_repo_impl.dart",


# domain
"lib/features/#feature#/domain/entities",
"lib/features/#feature#/domain/repo",
"lib/features/#feature#/domain/repo/#feature#_repo.dart",
"lib/features/#feature#/domain/usecases",

# Presentation
"lib/features/#feature#/presentation/screens/#feature#_screen.dart",
"lib/features/#feature#/presentation/states",
"lib/features/#feature#/presentation/widgets",

]


feature_name = input("Please enter feature name :")


feature_name = feature_name.strip().lower().replace(" ","_")

isValidName = True

# checking valid feature name
size = len(feature_name)
if size < 3:
    isValidName = False
    print("feature name required !" if size == 0 else "feature name should have least 3 char !")


if isValidName and not re.match(r"^[a-z]+[a-z0-9\_]*[a-z0-9]$", feature_name):
    isValidName = False
    print("Invalid file name !")




if isValidName:
    for path in lib_feature:
        path = path.replace("#feature#",feature_name) 
        create_dir(path)