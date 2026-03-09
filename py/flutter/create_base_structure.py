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
    







lib_common = [

"lib/common/abstract_classes/stateful_util.dart",
# classes
"lib/common/classes/adaptive_image_provider.dart",
"lib/common/classes/permission_class.dart",
"lib/common/classes/play_store_appupdate.dart",
# Utils
"lib/common/utils",
# Dialogues
"lib/common/dialogues/show_confirmation_dialogue.dart",
"lib/common/dialogues/show_loading.dart",
"lib/common/dialogues/show_alert_dialogue.dart",
#  Entities
"lib/common/entities",
# Models
"lib/common/models/api_response_model.dart",

"lib/common/screens",
"lib/common/widgets",

]

lib_config = [

# constants 
"lib/config/constants/app_constants.dart",
"lib/config/constants/app_regx.dart",
"lib/config/constants/assets.dart",
"lib/config/constants/color_constants.dart",
"lib/config/constants/conntection_apis.dart",
"lib/config/constants/const_string.dart",

# enums
"lib/config/enums",
# firebase
"lib/config/firebase",
# themes::light_theme
"lib/config/themes/light_theme/light_theme.dart",
"lib/config/themes/light_theme/light_theme.appbar.dart",
"lib/config/themes/light_theme/light_theme.bottomsheet.dart",
"lib/config/themes/light_theme/light_theme.button.dart",
"lib/config/themes/light_theme/light_theme.checkbox.dart",
"lib/config/themes/light_theme/light_theme.constants.dart",
"lib/config/themes/light_theme/light_theme.inputdecoration.dart",
"lib/config/themes/light_theme/light_theme.listtile.dart",
"lib/config/themes/light_theme/light_theme.text.dart",

# themes::dark_theme
"lib/config/themes/dark_theme/dark_theme.dart",
"lib/config/themes/dark_theme/dark_theme.appbar.dart",
"lib/config/themes/dark_theme/dark_theme.bottomsheet.dart",
"lib/config/themes/dark_theme/dark_theme.button.dart",
"lib/config/themes/dark_theme/dark_theme.checkbox.dart",
"lib/config/themes/dark_theme/dark_theme.constants.dart",
"lib/config/themes/dark_theme/dark_theme.inputdecoration.dart",
"lib/config/themes/dark_theme/dark_theme.listtile.dart",
"lib/config/themes/dark_theme/dark_theme.text.dart",

]

# Core folder
lib_core = [
# extensions
"lib/core/extensions/context_ext.dart",
"lib/core/extensions/datetime_ext.dart",
"lib/core/extensions/map_ext.dart",
"lib/core/extensions/num_ext.dart",
"lib/core/extensions/parse_api_response.dart",
"lib/core/extensions/string_ext.dart",
"lib/core/extensions/texteditingctrl_ext.dart",
# functions
"lib/core/functions",

]


lib_feature = [
# Data
"lib/features/dashboard/data/source/local",
"lib/features/dashboard/data/source/remote",
"lib/features/dashboard/data/models",
"lib/features/dashboard/data/repo_impl",

# domain
"lib/features/dashboard/domain/entities",
"lib/features/dashboard/domain/repo",
"lib/features/dashboard/domain/usecases",

# Presentation
"lib/features/dashboard/presentation/screens",
"lib/features/dashboard/presentation/states",
"lib/features/dashboard/presentation/widgets",

]

# combining all folder and files list
all_folder_files:list[list] = [lib_common,lib_config,lib_core,lib_feature,]

# Creating all folder and files
for sublist in all_folder_files:
    for path in sublist:
        create_dir(path)

