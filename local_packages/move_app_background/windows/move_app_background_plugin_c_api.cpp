#include "include/move_app_background/move_app_background_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "move_app_background_plugin.h"

void MoveAppBackgroundPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  move_app_background::MoveAppBackgroundPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
