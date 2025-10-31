//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <camera_windows/camera_windows.h>
#include <emoji_picker_flutter/emoji_picker_flutter_plugin_c_api.h>
#include <file_selector_windows/file_selector_windows.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <sqlite3_flutter_libs/sqlite3_flutter_libs_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  CameraWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("CameraWindows"));
  EmojiPickerFlutterPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("EmojiPickerFlutterPluginCApi"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  Sqlite3FlutterLibsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("Sqlite3FlutterLibsPlugin"));
}
