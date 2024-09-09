// #include <stdint.h>

// #define MAPLIBRE_EXPORT __attribute__((__visibility__("default"))) __attribute__((__used__))

// #ifdef __cplusplus
// #define EXTERNC extern "C"
// #else
// #define EXTERNC
// #endif

// typedef void *mbgl_map_t;
// typedef void *mbgl_headless_frontend_t;
// typedef void *mbgl_tile_server_options_t;
// typedef void *mbgl_run_loop_t;
// typedef void *mbgl_map_observer_t;

// // To check that binding works
// EXTERNC int MAPLIBRE_EXPORT test_function();

// EXTERNC mbgl_run_loop_t MAPLIBRE_EXPORT run_loop_create();
// EXTERNC mbgl_run_loop_t MAPLIBRE_EXPORT run_loop_create_with_platform_callback(void (*callback)());
// EXTERNC void MAPLIBRE_EXPORT run_loop_run(mbgl_run_loop_t run_loop);
// EXTERNC void MAPLIBRE_EXPORT run_loop_run_once(mbgl_run_loop_t run_loop);
// EXTERNC void MAPLIBRE_EXPORT run_loop_wait_for_empty(mbgl_run_loop_t run_loop);
// EXTERNC void MAPLIBRE_EXPORT run_loop_stop(mbgl_run_loop_t run_loop);
// EXTERNC void MAPLIBRE_EXPORT run_loop_destroy(mbgl_run_loop_t run_loop);

// EXTERNC mbgl_headless_frontend_t MAPLIBRE_EXPORT headless_frontend_create(int width, int height, float pixel_ratio);
// EXTERNC void MAPLIBRE_EXPORT headless_frontend_render_frame(mbgl_headless_frontend_t frontend, mbgl_map_t map);
// EXTERNC void MAPLIBRE_EXPORT headless_frontend_copy_image_to_buffer(mbgl_headless_frontend_t frontend, uint8_t *buffer);
// EXTERNC uint8_t *MAPLIBRE_EXPORT headless_frontend_get_image_data_ptr(mbgl_headless_frontend_t frontend);
// EXTERNC void MAPLIBRE_EXPORT headless_frontend_destroy(mbgl_headless_frontend_t frontend);

// EXTERNC mbgl_map_observer_t MAPLIBRE_EXPORT map_observer_create(void (*on_map_change)());
// EXTERNC void MAPLIBRE_EXPORT map_observer_destroy(mbgl_map_observer_t observer);

// EXTERNC mbgl_tile_server_options_t MAPLIBRE_EXPORT tile_server_options_map_tiler_create();
// EXTERNC void MAPLIBRE_EXPORT tile_server_options_destroy(mbgl_tile_server_options_t options);

// EXTERNC mbgl_map_t MAPLIBRE_EXPORT map_create(
//     mbgl_headless_frontend_t frontend,
//     mbgl_map_observer_t observer,
//     uint32_t map_mode,
//     float pixel_ratio,
//     char *api_key,
//     mbgl_tile_server_options_t tile_server_options);

// EXTERNC void MAPLIBRE_EXPORT map_set_style(mbgl_map_t map, char *style);
// EXTERNC void MAPLIBRE_EXPORT map_jump_to(mbgl_map_t map, double lat, double lon, double zoom, double bearing, double pitch);

// EXTERNC void MAPLIBRE_EXPORT map_destroy(mbgl_map_t map);

// #undef EXTERNC
