// #include "src.h"
// #include "flutter_map_observer.hpp"

// #include <mbgl/map/map.hpp>
// #include <mbgl/map/map_options.hpp>
// #include <mbgl/util/image.hpp>
// #include <mbgl/util/run_loop.hpp>

// #include <mbgl/gfx/backend.hpp>
// #include <mbgl/gfx/headless_frontend.hpp>
// #include <mbgl/style/style.hpp>

// #include <cstdlib>
// #include <iostream>
// #include <fstream>

// using namespace std;
// using namespace mbgl;

// int test_function()
// {
//     return 42;
// }

// mbgl_run_loop_t run_loop_create()
// {
//     auto run_loop = new mbgl::util::RunLoop();
//     return run_loop;
// }

// mbgl_run_loop_t run_loop_create_with_platform_callback(void (*callback)())
// {
//     auto run_loop = new mbgl::util::RunLoop();
//     run_loop->setPlatformCallback(callback);
//     return run_loop;
// }

// void run_loop_run(mbgl_run_loop_t run_loop)
// {
//     auto run_loop_ = static_cast<mbgl::util::RunLoop *>(run_loop);
//     run_loop_->run();
// }

// void run_loop_run_once(mbgl_run_loop_t run_loop)
// {
//     auto run_loop_ = static_cast<mbgl::util::RunLoop *>(run_loop);
//     run_loop_->runOnce();
// }

// void run_loop_wait_for_empty(mbgl_run_loop_t run_loop)
// {
//     auto run_loop_ = static_cast<mbgl::util::RunLoop *>(run_loop);
//     run_loop_->waitForEmpty();
// }

// void run_loop_stop(mbgl_run_loop_t run_loop)
// {
//     auto run_loop_ = static_cast<mbgl::util::RunLoop *>(run_loop);
//     run_loop_->stop();
// }

// void run_loop_destroy(mbgl_run_loop_t run_loop)
// {
//     auto run_loop_ = static_cast<mbgl::util::RunLoop *>(run_loop);
//     run_loop_->stop();

//     delete run_loop_;
// }

// mbgl_headless_frontend_t headless_frontend_create(
//     int width,
//     int height,
//     float pixel_ratio)
// {
//     auto frontend = new HeadlessFrontend({width, height}, pixel_ratio);
//     return frontend;
// }

// void headless_frontend_render_frame(
//     mbgl_headless_frontend_t frontend,
//     mbgl_map_t map
// )
// {
//     auto frontend_ = static_cast<HeadlessFrontend *>(frontend);
//     auto map_ = static_cast<Map *>(map);
    
//     frontend_->renderFrame();
//     cout << "Rendered" << endl;

//     auto image = frontend_->readStillImage();
//     cout << image.bytes() << endl;
//     cout << image.channels << endl;
// }

// void headless_frontend_copy_image_to_buffer(
//     mbgl_headless_frontend_t frontend,
//     uint8_t *buffer
// ) {
//     auto frontend_ = static_cast<HeadlessFrontend *>(frontend);
//     auto image = frontend_->readStillImage();
    
//     if (image.data.get() == nullptr)
//     {
//         cout << "Image data is null" << endl;
//         return;
//     }

//     cout << "Image data is not null" << endl;
//     cout << image.bytes() << endl;
//     std::memcpy(buffer, image.data.get(), image.bytes());
// }

// uint8_t* headless_frontend_get_image_data_ptr(mbgl_headless_frontend_t frontend) {
//     auto frontend_ = static_cast<HeadlessFrontend *>(frontend);
//     auto image = frontend_->readStillImage();
//     return image.data.get();
// }

// void headless_frontend_destroy(
//     mbgl_headless_frontend_t frontend)
// {
//     auto frontend_ = static_cast<HeadlessFrontend *>(frontend);
//     delete frontend_;
// }

// mbgl_tile_server_options_t tile_server_options_map_tiler_create()
// {
//     auto options = TileServerOptions::MapTilerConfiguration();
//     return new TileServerOptions(options);
// }

// void tile_server_options_destroy(
//     mbgl_tile_server_options_t options)
// {
//     auto options_ = static_cast<TileServerOptions *>(options);
//     delete options_;
// }

// mbgl_map_observer_t map_observer_create(void (*on_map_change)())
// {
//     auto observer = new FlutterMapLibreObserver();
//     observer->on_map_change = on_map_change;

//     return observer;
// }

// void map_observer_destroy(
//     mbgl_map_observer_t observer)
// {
//     auto observer_ = static_cast<mbgl::MapObserver *>(observer);
//     delete observer_;
// }

// mbgl_map_t map_create(
//     mbgl_headless_frontend_t frontend,
//     mbgl_map_observer_t observer,
//     uint32_t map_mode,
//     float pixel_ratio,
//     char *api_key,
//     mbgl_tile_server_options_t tile_server_options)
// {
//     cout << "MAP CREATE" << endl;
//     auto frontend_ = static_cast<HeadlessFrontend *>(frontend);
//     auto options_ = static_cast<TileServerOptions *>(tile_server_options);
//     auto observer_ = static_cast<mbgl::MapObserver *>(observer);

//     auto map = new Map(
//         *frontend_,
//         *observer_,
//         MapOptions()
//             .withMapMode(static_cast<MapMode>(map_mode))
//             .withSize(frontend_->getSize())
//             .withPixelRatio(pixel_ratio),
//         ResourceOptions()
//             .withApiKey(api_key)
//             .withTileServerOptions(*options_));

//     return map;
// }

// void map_set_style(
//     mbgl_map_t map,
//     char *style)
// {
//     auto map_ = static_cast<Map *>(map);
//     map_->getStyle().loadURL(style);
// }

// void map_jump_to(
//     mbgl_map_t map,
//     double lat,
//     double lon,
//     double zoom,
//     double bearing,
//     double pitch)
// {
//     auto map_ = static_cast<Map *>(map);
//     map_->jumpTo(CameraOptions().withCenter(LatLng{lat, lon}).withZoom(zoom).withBearing(bearing).withPitch(pitch));
// }

// void map_destroy(mbgl_map_t map)
// {
//     auto map_ = static_cast<Map *>(map);
//     delete map_;
// }

// void a()
// {
//     try
//     {
//         mbgl::util::RunLoop();

//         auto mapboxConfiguration = mbgl::TileServerOptions::MapTilerConfiguration();
//         std::string style = "https://api.maptiler.com/maps/7d5f4aed-f3bb-4c46-8dee-e1e79cd2e12b/style.json?key=5IZuFl4CkB3Io0SjxUVJ";

//         auto width = 3000;
//         auto height = 3000;
//         auto pixelRatio = 1.0;

//         HeadlessFrontend frontend({width, height}, static_cast<float>(pixelRatio));
//         Map map = Map(frontend,
//                       MapObserver::nullObserver(),
//                       MapOptions()
//                           .withMapMode(MapMode::Continuous)
//                           .withSize(frontend.getSize())
//                           .withPixelRatio(static_cast<float>(pixelRatio)),
//                       ResourceOptions()
//                           .withApiKey("5IZuFl4CkB3Io0SjxUVJ")
//                           // .withApiKey("pk.eyJ1Ijoia2VrbGFuZCIsImEiOiJjbHJ6Nm43cmsxcHdqMmlvNnB6ZW1xYWk3In0.JKPLXqYPGxdkz8jwzRrgBg")
//                           .withTileServerOptions(mapboxConfiguration));

//         if (style.find("://") == std::string::npos)
//         {
//             style = std::string("file://") + style;
//         }

//         map.getStyle().loadURL(style);
//         map.jumpTo(CameraOptions().withCenter(LatLng{43.1991413838172, 76.85274264579952}).withZoom(16.0).withBearing(0.0).withPitch(45.0));

//         try
//         {
//             frontend.render(map);
//             std::cout << "Rendered" << std::endl;
//         }
//         catch (std::exception &e)
//         {
//             std::cout << "Error: " << e.what() << std::endl;
//             exit(1);
//         }
//     }
//     catch (const std::exception &e)
//     {
//         std::cout << e.what() << std::endl;
//     }
// }