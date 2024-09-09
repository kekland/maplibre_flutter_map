#include "maplibre_flutter_map.h"

#include <condition_variable>
#include <future>
#include <iostream>
#include <mbgl/gfx/backend.hpp>
#include <mbgl/gfx/headless_frontend.hpp>
#include <mbgl/map/map.hpp>
#include <mbgl/map/map_options.hpp>
#include <mbgl/style/style.hpp>
#include <mbgl/util/image.hpp>
#include <mbgl/util/run_loop.hpp>
#include <queue>
#include <thread>

#include "flutter_map_observer.hpp"

using namespace std;
using namespace mbgl;

int test_function()
{
    return 42;
}

void run_loop_thread(std::promise<mbgl::util::RunLoop*>& p)
{
    auto runLoop = mbgl::util::RunLoop(mbgl::util::RunLoop::Type::New);
    p.set_value(&runLoop);

    runLoop.run();

    std::cout << "Thread finished" << std::endl;
}

mbgl_run_loop_t start_run_loop_thread()
{
    std::promise<mbgl::util::RunLoop*> p;
    auto future = p.get_future();

    auto thread = std::thread(run_loop_thread, std::ref(p));
    thread.detach();

    future.wait();
    auto runLoop = future.get();

    std::cout << "Thread started" << std::endl;
    std::cout << runLoop << std::endl;

    return runLoop;
}

mbgl_headless_frontend_t headless_frontend_create(mbgl_run_loop_t run_loop,
    int width, int height,
    float pixel_ratio)
{
    auto _run_loop = static_cast<mbgl::util::RunLoop*>(run_loop);

    std::promise<mbgl::HeadlessFrontend*> p;

    _run_loop->invoke([&] {
        auto frontend = new mbgl::HeadlessFrontend({ width, height }, pixel_ratio);
        p.set_value(frontend);
    });

    auto future = p.get_future();
    future.wait();

    return future.get();
}

uint8_t* headless_frontend_get_image_data_ptr(mbgl_headless_frontend_t frontend)
{
    auto frontend_ = static_cast<HeadlessFrontend*>(frontend);
    auto image = frontend_->readStillImage();
    return image.data.get();
}

void headless_frontend_render_frame(mbgl_run_loop_t run_loop, mbgl_headless_frontend_t frontend)
{
    auto frontend_ = static_cast<HeadlessFrontend*>(frontend);
    auto _run_loop = static_cast<mbgl::util::RunLoop*>(run_loop);

    std::promise<void> p;

    _run_loop->invoke([&] {
        frontend_->renderFrame();
        p.set_value();
    });

    auto future = p.get_future();
    future.wait();
}

mbgl_map_observer_t map_observer_create(void (*on_map_change)())
{
    auto observer = new FlutterMapLibreObserver();
    observer->on_map_change = on_map_change;

    return observer;
}

mbgl_tile_server_options_t tile_server_options_map_tiler_create()
{
    auto options = TileServerOptions::MapTilerConfiguration();
    return new TileServerOptions(options);
}

mbgl_map_t map_create(mbgl_run_loop_t run_loop,
    mbgl_headless_frontend_t frontend,
    mbgl_map_observer_t observer, uint32_t map_mode,
    float pixel_ratio, char* api_key,
    mbgl_tile_server_options_t tile_server_options)
{
    auto frontend_ = static_cast<HeadlessFrontend*>(frontend);
    auto options_ = static_cast<TileServerOptions*>(tile_server_options);
    auto observer_ = static_cast<mbgl::MapObserver*>(observer);

    std::promise<mbgl::Map*> p;

    auto _run_loop = static_cast<mbgl::util::RunLoop*>(run_loop);
    _run_loop->invoke([&] {
        auto map = new Map(
            *frontend_, *observer_,
            MapOptions()
                .withMapMode(static_cast<MapMode>(map_mode))
                .withSize(frontend_->getSize())
                .withPixelRatio(pixel_ratio),
            ResourceOptions().withApiKey(api_key).withTileServerOptions(*options_));

        p.set_value(map);
    });

    auto future = p.get_future();
    future.wait();

    return future.get();
}

void map_set_style(mbgl_run_loop_t run_loop, mbgl_map_t map, char* style)
{
    auto _run_loop = static_cast<mbgl::util::RunLoop*>(run_loop);
    auto _map = static_cast<mbgl::Map*>(map);

    std::promise<void> p;

    _run_loop->invoke([&] {
        _map->getStyle().loadURL(style);
        p.set_value();
    });

    auto future = p.get_future();
    future.wait();
}

void map_jump_to(mbgl_run_loop_t run_loop, mbgl_map_t map, double lat, double lon, double zoom,
    double bearing, double pitch)
{
    auto _run_loop = static_cast<mbgl::util::RunLoop*>(run_loop);
    auto _map = static_cast<mbgl::Map*>(map);

    std::promise<void> p;

    _run_loop->invoke([&] {
        _map->jumpTo(CameraOptions()
                         .withCenter(LatLng { lat, lon })
                         .withZoom(zoom)
                         .withBearing(bearing)
                         .withPitch(pitch));

        p.set_value();
    });

    auto future = p.get_future();
    future.wait();
}

