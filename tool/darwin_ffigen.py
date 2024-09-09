#!/usr/bin/env python3

import subprocess
import shlex
import pathlib
import sys

plugin_location = pathlib.Path(__file__).parent.parent

def compile_darwin_objc_headers():
  classes_location = plugin_location / 'darwin' / 'Classes'

  flutter_ios_headers_location = plugin_location / 'third-party' / 'engine' / 'shell' / 'platform' / 'darwin' / 'ios' / 'framework' / 'Headers'
  flutter_macos_headers_location = plugin_location / 'third-party' / 'engine' / 'shell' / 'platform' / 'darwin' / 'macos' / 'framework' / 'Headers'
  flutter_darwin_headers_location = plugin_location / 'third-party' / 'engine' / 'shell' / 'platform' / 'darwin' / 'common' / 'framework' / 'Headers'
  flutter_texture_header = flutter_darwin_headers_location / 'FlutterTexture.h'

  output_file = plugin_location / 'build' / 'ffigen' / 'maplibre_flutter_map-Swift.h'

  files = list(classes_location.glob('**/*.swift'))
  files = list(filter(lambda file: 'MaplibreFlutterMapPlugin.swift' not in file.name, files))
  joined_files = ' '.join([file.as_posix() for file in files])

  p = subprocess.Popen(shlex.split(f'swiftc -c {joined_files} -module-name maplibre_flutter_map -emit-objc-header-path {output_file} -I {flutter_darwin_headers_location} -import-objc-header {flutter_texture_header}'), cwd=classes_location.as_posix())
  p.wait()

  for file in classes_location.glob('**/*.o'):
    file.unlink()

def run_ffigen():
  print('-' * 80)
  print('Running ffigen for', 'darwin')
  print('[INFO] logs are hidden, only warnings and errors will be shown.')
  print('-' * 80)

  p = subprocess.Popen(shlex.split(f'dart run ffigen --config ffigen_darwin.yaml'), cwd=plugin_location.as_posix(), stdout = subprocess.PIPE, universal_newlines = True)

  for line in p.stdout:
    if line.strip().startswith('[INFO]'): continue
    sys.stdout.write(line)

  p.wait()

# def cleanup_generated_dart_bindings_file():
#   generated_dart_bindings_file = plugin_location / 'lib' / 'src' / '_gen' / 'darwin' / 'watchcrunch_native_video_bindings.dart'

#   file_data = ''
#   with open(generated_dart_bindings_file, 'r') as file:
#     file_data = file.read()

#   lines = file_data.split('\n')

#   # nothing here yet. if there are bugs, they will be fixed here
#   # Replace _CGImageCreate with CGImageCreate2
#   lines = [line.replace('_CGImageCreate', 'CGImageCreate2') for line in lines]

#   file_data = '\n'.join(lines)

#   with open(generated_dart_bindings_file, 'w') as file:
#     file.write(file_data)

# def cleanup_generated_objc_bindings_file():
#   generated_obc_bindings_file = plugin_location / 'darwin' / 'Classes' / f'watchcrunch_native_video_bindings.dart.m'

#   file_data = ''
#   with open(generated_obc_bindings_file, 'r') as file:
#     file_data = file.read()

#   file_lines = file_data.split('\n')

#   # Remove the import line with `watchcrunch_native_video`. It's only used for codegen
#   file_lines = [line for line in file_lines if 'watchcrunch_native_video' not in line]

#   # After line `return ^void(CMTime arg0, struct CGImage * arg1, CMTime arg2, AVAssetImageGeneratorResult arg3, NSError* arg4) {` add `CFRetain(arg1)`
#   for i, line in enumerate(file_lines):
#     if 'return ^void(CMTime arg0, struct CGImage * arg1, CMTime arg2, AVAssetImageGeneratorResult arg3, NSError* arg4) {' in line:
#       file_lines.insert(i + 1, '  CFRetain(arg1);')
#       break 

#   file_data = '\n'.join(file_lines)

#   with open(generated_obc_bindings_file, 'w') as file:
#     file.write(file_data)
  
if __name__ == '__main__':
  compile_darwin_objc_headers()
  run_ffigen()
  # cleanup_generated_dart_bindings_file()
  # cleanup_generated_objc_bindings_file()

  # if build_example:
  #   run_example_app_build('ios')
  #   run_example_app_build('macos')
