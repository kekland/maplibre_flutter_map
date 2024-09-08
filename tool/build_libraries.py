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

    subprocess.run(shlex.split(f'rm -rf {maplibre_native}'), check=False)
    subprocess.run(shlex.split(f'cp -r {src} {maplibre_native}'), check=True)

def build_ios_dynamic_library():
    print('Building iOS dynamic library')
    
    # Run bazel build for iOS dynamic library
    subprocess.run(
        shlex.split(f'bazel build //platform/flutter:maplibre_flutter_map_ios_universal --//:renderer=metal'), 
        cwd=maplibre_native_root,
        check=True
    )

    # Copy the built dynamic library to the plugin directory
    bazel_out_ios_dynamic_library = maplibre_native_root / 'bazel-bin/platform/flutter/libmaplibre_flutter_map_ios.dylib'
    ios_dynamic_library = plugin_root / 'ios/Libraries/libmaplibre_flutter_map_ios.dylib'

    subprocess.run(shlex.split(f'cp -rf {bazel_out_ios_dynamic_library} {ios_dynamic_library}'), check=True)

    return ios_dynamic_library

def build_macos_dynamic_library():
    print('Building macOS dynamic library')
    
    # Run bazel build for macOS dynamic library
    subprocess.run(
        shlex.split(f'bazel build //platform/flutter:maplibre_flutter_map_macos --//:renderer=metal'), 
        cwd=maplibre_native_root,
        check=True
    )

    # Copy the built dynamic library to the plugin directory
    bazel_out_macos_dynamic_library = maplibre_native_root / 'bazel-bin/platform/flutter/libmaplibre_flutter_map_macos.dylib'
    macos_dynamic_library = plugin_root / 'macos/Libraries/libmaplibre_flutter_map_macos.dylib'

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
        check=True
    )

args = sys.argv[1:]

copy_src_to_maplibre_native()

has_args = len(args) > 0
is_ios = 'ios' in args
is_macos = 'macos' in args

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