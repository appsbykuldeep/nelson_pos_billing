//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <downloadsfolder/downloadsfolder_plugin_c_api.h>
#include <firebase_core/firebase_core_plugin_c_api.h>
#include <flutter_blue_plus_winrt/flutter_blue_plus_plugin.h>
#include <move_app_background/move_app_background_plugin_c_api.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <printing/printing_plugin.h>
#include <restart_app/restart_app_plugin_c_api.h>
#include <share_plus/share_plus_windows_plugin_c_api.h>
#include <thermal_printer_plus/thermal_printer_plugin.h>
#include <universal_ble/universal_ble_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  DownloadsfolderPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("DownloadsfolderPluginCApi"));
  FirebaseCorePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FirebaseCorePluginCApi"));
  FlutterBluePlusPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterBluePlusPlugin"));
  MoveAppBackgroundPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("MoveAppBackgroundPluginCApi"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  PrintingPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PrintingPlugin"));
  RestartAppPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("RestartAppPluginCApi"));
  SharePlusWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SharePlusWindowsPluginCApi"));
  ThermalPrinterPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ThermalPrinterPlugin"));
  UniversalBlePluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UniversalBlePluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
