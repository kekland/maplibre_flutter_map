#!/usr/bin/env python3

import subprocess
import shlex
import pathlib
import sys

plugin_root = pathlib.Path(__file__).parent.parent
maplibre_native_root = plugin_root / 'third-party/maplibre-native'

# copy contents of `src` to `third-party/maplibre-native/platform/flutter`
def copy_src_to_maplibre_native():
    print('Copying src to maplibre-native')

    src = plugin_root / 'src'
    maplibre_native = plugin_root / 'third-party/maplibre-native/platform/flutter'

    exclusion_list = ['MODULE.bazel']

    # remove old files
    subprocess.run(shlex.split(f'rm -rf {maplibre_native}'), check=False)

    # create directory
    maplibre_native.mkdir(parents=True, exist_ok=True)

    for item in src.iterdir():
        if item.name not in exclusion_list:
            subprocess.run(shlex.split(f'cp -rf {item} {maplibre_native}'), check=True)

    # copy MODULE.bazel
    subprocess.run(shlex.split(f'cp -rf {src / "MODULE.bazel"} {maplibre_native_root}'), check=True)

    print('Copied src to maplibre-native')

    # patch platform/default/BUILD.bazel so that Flutter has visibility
    lines = []
    with open(maplibre_native_root / 'platform/default/BUILD.bazel', 'r') as f:
        lines = f.readlines()

    index = lines.index('        "//platform/macos:__pkg__",\n')
    lines.insert(index + 1, '        "//platform/flutter:__pkg__",\n')

    with open(maplibre_native_root / 'platform/default/BUILD.bazel', 'w') as f:
        f.writelines(lines)

    print('Patched platform/default/BUILD.bazel')

BZL_FLAGS = '--experimental_google_legacy_api --experimental_enable_android_migration_apis'

def build_android_dynamic_library():
    # TODO
    # Command: bazel build //platform/flutter:maplibre_flutter_map_android --//:renderer=drawable --experimental_google_legacy_api --experimental_enable_android_migration_apis --platforms=//platform/flutter:android_arm64
    pass

def build_ios_dynamic_library():
    print('Building iOS dynamic library')
    
    # Run bazel build for iOS dynamic library
    subprocess.run(
        shlex.split(f'bazel build //platform/flutter:maplibre_flutter_map_ios_universal --//:renderer=metal {BZL_FLAGS}'), 
        cwd=maplibre_native_root,
        check=True
    )

    # Copy the built dynamic library to the plugin directory
    bazel_out_ios_dynamic_library = maplibre_native_root / 'bazel-bin/platform/flutter/libmaplibre_flutter_map_ios.dylib'
    ios_dynamic_library = plugin_root / 'darwin/Libraries/ios/libmaplibre_flutter_map_ios.dylib'

    subprocess.run(shlex.split(f'cp -rf {bazel_out_ios_dynamic_library} {ios_dynamic_library}'), check=True)

    return ios_dynamic_library

def build_macos_dynamic_library():
    print('Building macOS dynamic library')
    
    # Run bazel build for macOS dynamic library
    subprocess.run(
        shlex.split(f'bazel build //platform/flutter:maplibre_flutter_map_macos --//:renderer=metal {BZL_FLAGS}'),
        cwd=maplibre_native_root,
        check=True
    )

    # Copy the built dynamic library to the plugin directory
    bazel_out_macos_dynamic_library = maplibre_native_root / 'bazel-bin/platform/flutter/libmaplibre_flutter_map_macos.dylib'
    macos_dynamic_library = plugin_root / 'darwin/Libraries/macos/libmaplibre_flutter_map_macos.dylib'

    subprocess.run(shlex.split(f'cp -rf {bazel_out_macos_dynamic_library} {macos_dynamic_library}'), check=True)

    return macos_dynamic_library

def fix_dylib_rpath(path):
    print(f'Fixing dylib rpath for {path}')

    name = path.name

    # Run install_name_tool to fix rpath
    subprocess.run(
        shlex.split(f'install_name_tool -id @rpath/{name} {path}'),
        check=True
    )

def run_ffigen():
    print('Running ffigen')
    subprocess.run(
        shlex.split('dart run ffigen --config ffigen.yaml'),
        check=True,
        cwd=plugin_root
    )

args = sys.argv[1:]

copy_src_to_maplibre_native()

has_args = len(args) > 0

is_darwin = 'darwin' in args
is_ios = is_darwin or 'ios' in args
is_macos = is_darwin or 'macos' in args

if not has_args or is_ios:
  print('-' * 50)
  print('🕛 Building iOS dynamic library')
  print('-' * 50)

  ios_dynamic_library = build_ios_dynamic_library()
  fix_dylib_rpath(ios_dynamic_library)

  print('-' * 50)
  print('🔥 iOS dynamic library built successfully')
  print('-' * 50)

if not has_args or is_macos:
  print('-' * 50)
  print('🕛 Building macOS dynamic library')
  print('-' * 50)

  macos_dynamic_library = build_macos_dynamic_library()
  fix_dylib_rpath(macos_dynamic_library)

  print('-' * 50)
  print('🔥 macOS dynamic library built successfully')
  print('-' * 50)

run_ffigen()