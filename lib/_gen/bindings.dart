// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_element, unused_field, return_of_invalid_type, void_checks, annotate_overrides, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint
import 'dart:ffi' as ffi;

class MapLibreFlutterMapBindings {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  MapLibreFlutterMapBindings(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  MapLibreFlutterMapBindings.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  int test_function() {
    return _test_function();
  }

  late final _test_functionPtr =
      _lookup<ffi.NativeFunction<ffi.Int Function()>>('test_function');
  late final _test_function = _test_functionPtr.asFunction<int Function()>();

  mbgl_run_loop_t start_run_loop_thread() {
    return _start_run_loop_thread();
  }

  late final _start_run_loop_threadPtr =
      _lookup<ffi.NativeFunction<mbgl_run_loop_t Function()>>(
          'start_run_loop_thread');
  late final _start_run_loop_thread =
      _start_run_loop_threadPtr.asFunction<mbgl_run_loop_t Function()>();

  mbgl_headless_frontend_t headless_frontend_create(
    mbgl_run_loop_t run_loop,
    int width,
    int height,
    double pixel_ratio,
  ) {
    return _headless_frontend_create(
      run_loop,
      width,
      height,
      pixel_ratio,
    );
  }

  late final _headless_frontend_createPtr = _lookup<
      ffi.NativeFunction<
          mbgl_headless_frontend_t Function(mbgl_run_loop_t, ffi.Int, ffi.Int,
              ffi.Float)>>('headless_frontend_create');
  late final _headless_frontend_create =
      _headless_frontend_createPtr.asFunction<
          mbgl_headless_frontend_t Function(
              mbgl_run_loop_t, int, int, double)>();

  ffi.Pointer<ffi.Uint8> headless_frontend_get_image_data_ptr(
    mbgl_headless_frontend_t frontend,
  ) {
    return _headless_frontend_get_image_data_ptr(
      frontend,
    );
  }

  late final _headless_frontend_get_image_data_ptrPtr = _lookup<
          ffi.NativeFunction<
              ffi.Pointer<ffi.Uint8> Function(mbgl_headless_frontend_t)>>(
      'headless_frontend_get_image_data_ptr');
  late final _headless_frontend_get_image_data_ptr =
      _headless_frontend_get_image_data_ptrPtr.asFunction<
          ffi.Pointer<ffi.Uint8> Function(mbgl_headless_frontend_t)>();

  void headless_frontend_render_frame(
    mbgl_run_loop_t run_loop,
    mbgl_headless_frontend_t frontend,
  ) {
    return _headless_frontend_render_frame(
      run_loop,
      frontend,
    );
  }

  late final _headless_frontend_render_framePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(mbgl_run_loop_t,
              mbgl_headless_frontend_t)>>('headless_frontend_render_frame');
  late final _headless_frontend_render_frame =
      _headless_frontend_render_framePtr.asFunction<
          void Function(mbgl_run_loop_t, mbgl_headless_frontend_t)>();

  mbgl_map_observer_t map_observer_create(
    ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>> on_map_change,
  ) {
    return _map_observer_create(
      on_map_change,
    );
  }

  late final _map_observer_createPtr = _lookup<
          ffi.NativeFunction<
              mbgl_map_observer_t Function(
                  ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>)>>(
      'map_observer_create');
  late final _map_observer_create = _map_observer_createPtr.asFunction<
      mbgl_map_observer_t Function(
          ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>)>();

  mbgl_tile_server_options_t tile_server_options_map_tiler_create() {
    return _tile_server_options_map_tiler_create();
  }

  late final _tile_server_options_map_tiler_createPtr =
      _lookup<ffi.NativeFunction<mbgl_tile_server_options_t Function()>>(
          'tile_server_options_map_tiler_create');
  late final _tile_server_options_map_tiler_create =
      _tile_server_options_map_tiler_createPtr
          .asFunction<mbgl_tile_server_options_t Function()>();

  mbgl_map_t map_create(
    mbgl_run_loop_t run_loop,
    mbgl_headless_frontend_t frontend,
    mbgl_map_observer_t observer,
    int map_mode,
    double pixel_ratio,
    ffi.Pointer<ffi.Char> api_key,
    mbgl_tile_server_options_t tile_server_options,
  ) {
    return _map_create(
      run_loop,
      frontend,
      observer,
      map_mode,
      pixel_ratio,
      api_key,
      tile_server_options,
    );
  }

  late final _map_createPtr = _lookup<
      ffi.NativeFunction<
          mbgl_map_t Function(
              mbgl_run_loop_t,
              mbgl_headless_frontend_t,
              mbgl_map_observer_t,
              ffi.Uint32,
              ffi.Float,
              ffi.Pointer<ffi.Char>,
              mbgl_tile_server_options_t)>>('map_create');
  late final _map_create = _map_createPtr.asFunction<
      mbgl_map_t Function(
          mbgl_run_loop_t,
          mbgl_headless_frontend_t,
          mbgl_map_observer_t,
          int,
          double,
          ffi.Pointer<ffi.Char>,
          mbgl_tile_server_options_t)>();

  void map_set_style(
    mbgl_run_loop_t run_loop,
    mbgl_map_t map,
    ffi.Pointer<ffi.Char> style,
  ) {
    return _map_set_style(
      run_loop,
      map,
      style,
    );
  }

  late final _map_set_stylePtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(mbgl_run_loop_t, mbgl_map_t,
              ffi.Pointer<ffi.Char>)>>('map_set_style');
  late final _map_set_style = _map_set_stylePtr.asFunction<
      void Function(mbgl_run_loop_t, mbgl_map_t, ffi.Pointer<ffi.Char>)>();

  void map_jump_to(
    mbgl_run_loop_t run_loop,
    mbgl_map_t map,
    double lat,
    double lon,
    double zoom,
    double bearing,
    double pitch,
  ) {
    return _map_jump_to(
      run_loop,
      map,
      lat,
      lon,
      zoom,
      bearing,
      pitch,
    );
  }

  late final _map_jump_toPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(mbgl_run_loop_t, mbgl_map_t, ffi.Double, ffi.Double,
              ffi.Double, ffi.Double, ffi.Double)>>('map_jump_to');
  late final _map_jump_to = _map_jump_toPtr.asFunction<
      void Function(mbgl_run_loop_t, mbgl_map_t, double, double, double, double,
          double)>();
}

final class __mbstate_t extends ffi.Union {
  @ffi.Array.multi([128])
  external ffi.Array<ffi.Char> __mbstate8;

  @ffi.LongLong()
  external int _mbstateL;
}

final class __darwin_pthread_handler_rec extends ffi.Struct {
  external ffi
      .Pointer<ffi.NativeFunction<ffi.Void Function(ffi.Pointer<ffi.Void>)>>
      __routine;

  external ffi.Pointer<ffi.Void> __arg;

  external ffi.Pointer<__darwin_pthread_handler_rec> __next;
}

final class _opaque_pthread_attr_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([56])
  external ffi.Array<ffi.Char> __opaque;
}

final class _opaque_pthread_cond_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([40])
  external ffi.Array<ffi.Char> __opaque;
}

final class _opaque_pthread_condattr_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([8])
  external ffi.Array<ffi.Char> __opaque;
}

final class _opaque_pthread_mutex_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([56])
  external ffi.Array<ffi.Char> __opaque;
}

final class _opaque_pthread_mutexattr_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([8])
  external ffi.Array<ffi.Char> __opaque;
}

final class _opaque_pthread_once_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([8])
  external ffi.Array<ffi.Char> __opaque;
}

final class _opaque_pthread_rwlock_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([192])
  external ffi.Array<ffi.Char> __opaque;
}

final class _opaque_pthread_rwlockattr_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  @ffi.Array.multi([16])
  external ffi.Array<ffi.Char> __opaque;
}

final class _opaque_pthread_t extends ffi.Struct {
  @ffi.Long()
  external int __sig;

  external ffi.Pointer<__darwin_pthread_handler_rec> __cleanup_stack;

  @ffi.Array.multi([8176])
  external ffi.Array<ffi.Char> __opaque;
}

typedef mbgl_run_loop_t = ffi.Pointer<ffi.Void>;
typedef mbgl_headless_frontend_t = ffi.Pointer<ffi.Void>;
typedef mbgl_map_observer_t = ffi.Pointer<ffi.Void>;
typedef mbgl_tile_server_options_t = ffi.Pointer<ffi.Void>;
typedef mbgl_map_t = ffi.Pointer<ffi.Void>;

const int __WORDSIZE = 64;

const int __has_safe_buffers = 1;

const int __DARWIN_ONLY_64_BIT_INO_T = 1;

const int __DARWIN_ONLY_UNIX_CONFORMANCE = 1;

const int __DARWIN_ONLY_VERS_1050 = 1;

const int __DARWIN_UNIX03 = 1;

const int __DARWIN_64_BIT_INO_T = 1;

const int __DARWIN_VERS_1050 = 1;

const int __DARWIN_NON_CANCELABLE = 0;

const String __DARWIN_SUF_EXTSN = '\$DARWIN_EXTSN';

const int __DARWIN_C_ANSI = 4096;

const int __DARWIN_C_FULL = 900000;

const int __DARWIN_C_LEVEL = 900000;

const int __STDC_WANT_LIB_EXT1__ = 1;

const int __DARWIN_NO_LONG_LONG = 0;

const int _DARWIN_FEATURE_64_BIT_INODE = 1;

const int _DARWIN_FEATURE_ONLY_64_BIT_INODE = 1;

const int _DARWIN_FEATURE_ONLY_VERS_1050 = 1;

const int _DARWIN_FEATURE_ONLY_UNIX_CONFORMANCE = 1;

const int _DARWIN_FEATURE_UNIX_CONFORMANCE = 3;

const int __has_ptrcheck = 0;

const int __DARWIN_NULL = 0;

const int __PTHREAD_SIZE__ = 8176;

const int __PTHREAD_ATTR_SIZE__ = 56;

const int __PTHREAD_MUTEXATTR_SIZE__ = 8;

const int __PTHREAD_MUTEX_SIZE__ = 56;

const int __PTHREAD_CONDATTR_SIZE__ = 8;

const int __PTHREAD_COND_SIZE__ = 40;

const int __PTHREAD_ONCE_SIZE__ = 8;

const int __PTHREAD_RWLOCK_SIZE__ = 192;

const int __PTHREAD_RWLOCKATTR_SIZE__ = 16;

const int USER_ADDR_NULL = 0;

const int INT8_MAX = 127;

const int INT16_MAX = 32767;

const int INT32_MAX = 2147483647;

const int INT64_MAX = 9223372036854775807;

const int INT8_MIN = -128;

const int INT16_MIN = -32768;

const int INT32_MIN = -2147483648;

const int INT64_MIN = -9223372036854775808;

const int UINT8_MAX = 255;

const int UINT16_MAX = 65535;

const int UINT32_MAX = 4294967295;

const int UINT64_MAX = -1;

const int INT_LEAST8_MIN = -128;

const int INT_LEAST16_MIN = -32768;

const int INT_LEAST32_MIN = -2147483648;

const int INT_LEAST64_MIN = -9223372036854775808;

const int INT_LEAST8_MAX = 127;

const int INT_LEAST16_MAX = 32767;

const int INT_LEAST32_MAX = 2147483647;

const int INT_LEAST64_MAX = 9223372036854775807;

const int UINT_LEAST8_MAX = 255;

const int UINT_LEAST16_MAX = 65535;

const int UINT_LEAST32_MAX = 4294967295;

const int UINT_LEAST64_MAX = -1;

const int INT_FAST8_MIN = -128;

const int INT_FAST16_MIN = -32768;

const int INT_FAST32_MIN = -2147483648;

const int INT_FAST64_MIN = -9223372036854775808;

const int INT_FAST8_MAX = 127;

const int INT_FAST16_MAX = 32767;

const int INT_FAST32_MAX = 2147483647;

const int INT_FAST64_MAX = 9223372036854775807;

const int UINT_FAST8_MAX = 255;

const int UINT_FAST16_MAX = 65535;

const int UINT_FAST32_MAX = 4294967295;

const int UINT_FAST64_MAX = -1;

const int INTPTR_MAX = 9223372036854775807;

const int INTPTR_MIN = -9223372036854775808;

const int UINTPTR_MAX = -1;

const int INTMAX_MAX = 9223372036854775807;

const int UINTMAX_MAX = -1;

const int INTMAX_MIN = -9223372036854775808;

const int PTRDIFF_MIN = -9223372036854775808;

const int PTRDIFF_MAX = 9223372036854775807;

const int SIZE_MAX = -1;

const int RSIZE_MAX = 9223372036854775807;

const int WCHAR_MAX = 2147483647;

const int WCHAR_MIN = -2147483648;

const int WINT_MIN = -2147483648;

const int WINT_MAX = 2147483647;

const int SIG_ATOMIC_MIN = -2147483648;

const int SIG_ATOMIC_MAX = 2147483647;
