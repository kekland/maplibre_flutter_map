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

  maplibre_thread_data start_run_loop_thread(
    ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>
        _invalidateFlutterTicker,
    ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>> _onFrameRendered,
  ) {
    return _start_run_loop_thread(
      _invalidateFlutterTicker,
      _onFrameRendered,
    );
  }

  late final _start_run_loop_threadPtr = _lookup<
          ffi.NativeFunction<
              maplibre_thread_data Function(
                  ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>,
                  ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>)>>(
      'start_run_loop_thread');
  late final _start_run_loop_thread = _start_run_loop_threadPtr.asFunction<
      maplibre_thread_data Function(
          ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>,
          ffi.Pointer<ffi.NativeFunction<ffi.Void Function()>>)>();

  ffi.Pointer<ffi.Uint8> flutter_renderer_frontend_get_image_data_ptr(
    fml_flutter_renderer_frontend_t frontend,
  ) {
    return _flutter_renderer_frontend_get_image_data_ptr(
      frontend,
    );
  }

  late final _flutter_renderer_frontend_get_image_data_ptrPtr = _lookup<
          ffi.NativeFunction<
              ffi.Pointer<ffi.Uint8> Function(
                  fml_flutter_renderer_frontend_t)>>(
      'flutter_renderer_frontend_get_image_data_ptr');
  late final _flutter_renderer_frontend_get_image_data_ptr =
      _flutter_renderer_frontend_get_image_data_ptrPtr.asFunction<
          ffi.Pointer<ffi.Uint8> Function(fml_flutter_renderer_frontend_t)>();

  void flutter_renderer_frontend_render_frame(
    fml_flutter_renderer_frontend_t frontend,
  ) {
    return _flutter_renderer_frontend_render_frame(
      frontend,
    );
  }

  late final _flutter_renderer_frontend_render_framePtr = _lookup<
          ffi
          .NativeFunction<ffi.Void Function(fml_flutter_renderer_frontend_t)>>(
      'flutter_renderer_frontend_render_frame');
  late final _flutter_renderer_frontend_render_frame =
      _flutter_renderer_frontend_render_framePtr
          .asFunction<void Function(fml_flutter_renderer_frontend_t)>();

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

final class maplibre_thread_data extends ffi.Struct {
  external mbgl_run_loop_t run_loop;

  external fml_flutter_renderer_frontend_t frontend;

  external mbgl_map_t map;
}

typedef mbgl_run_loop_t = ffi.Pointer<ffi.Void>;
typedef fml_flutter_renderer_frontend_t = ffi.Pointer<ffi.Void>;
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
