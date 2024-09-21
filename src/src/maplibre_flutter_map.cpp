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
#include "flutter_renderer_observer.hpp"
#include "frontend/flutter_renderer_frontend.hpp"

using namespace std;
using namespace mbgl;

int test_function()
{
    return 42;
}

void _run_loop_thread(
    std::promise<std::tuple<mbgl::util::RunLoop*, fml::FlutterRendererFrontend*, mbgl::Map*>>& p,
    int64_t flutterTextureId,
    void* flutterTexturePointer,
    void (*invalidateFlutterTicker)(),
    void (*onFrameRendered)())
{
    auto run_loop = mbgl::util::RunLoop(mbgl::util::RunLoop::Type::New);

    auto width = 966 / 2;
    auto height = 966 / 2;
    auto pixel_ratio = 2.0;

    auto frontend = new fml::FlutterRendererFrontend({ width, height },
        pixel_ratio,
        flutterTextureId,
        flutterTexturePointer,
        mbgl::gfx::Renderable::SwapBehaviour::Flush,
        mbgl::gfx::ContextMode::Shared,
        std::nullopt,
        invalidateFlutterTicker);

    auto observer = new fml::FlutterMapObserver();
    observer->on_map_change = onFrameRendered;

    auto rendererObserver = new fml::FlutterRendererObserver();
    frontend->setObserver(*rendererObserver);

    auto options = mbgl::TileServerOptions::MapboxConfiguration();

    auto map = new mbgl::Map(
        *frontend, *observer,
        mbgl::MapOptions()
            .withMapMode(mbgl::MapMode::Continuous)
            .withSize(frontend->getSize())
            .withPixelRatio(pixel_ratio),
        mbgl::ResourceOptions().withApiKey("pk.eyJ1Ijoia2VrbGFuZCIsImEiOiJjbHJ6Nm43cmsxcHdqMmlvNnB6ZW1xYWk3In0.JKPLXqYPGxdkz8jwzRrgBg").withTileServerOptions(options));

    auto style = "mapbox://styles/mapbox/streets-v11";
    map->getStyle().loadURL(style);

    p.set_value(std::make_tuple(&run_loop, frontend, map));
    std::cout << "Thread replied" << std::endl;

    run_loop.run();

    std::cout << "Thread finished" << std::endl;
}

maplibre_thread_data start_run_loop_thread(
    int64_t flutterTextureId,
    void* flutterTexturePointer,
    void (*_invalidateFlutterTicker)(),
    void (*_onFrameRendered)())
{
    std::cout << "Hi: " << flutterTextureId << std::endl;
    std::promise<std::tuple<mbgl::util::RunLoop*, fml::FlutterRendererFrontend*, mbgl::Map*>> p;
    auto future = p.get_future();

    auto thread = std::thread(
        _run_loop_thread,
        std::ref(p),
        flutterTextureId,
        flutterTexturePointer,
        _invalidateFlutterTicker,
        _onFrameRendered);

    thread.detach();

    auto tuple = future.get();
    auto run_loop = std::get<0>(tuple);
    auto frontend = std::get<1>(tuple);
    auto map = std::get<2>(tuple);

    std::cout << "Thread started" << std::endl;
    std::cout << "Run loop: " << run_loop << std::endl;
    std::cout << "Frontend: " << frontend << std::endl;
    std::cout << "Map: " << map << std::endl;

    return { run_loop, frontend, map };
}

uint8_t* flutter_renderer_frontend_get_image_data_ptr(fml_flutter_renderer_frontend_t frontend)
{
    auto frontend_ = static_cast<fml::FlutterRendererFrontend*>(frontend);
    auto image = frontend_->readStillImage();
    return image.data.get();
}

void flutter_renderer_frontend_render_frame(fml_flutter_renderer_frontend_t frontend)
{
    auto frontend_ = static_cast<fml::FlutterRendererFrontend*>(frontend);
    frontend_->renderFrame();
}

mbgl_map_observer_t map_observer_create(void (*on_map_change)())
{
    auto observer = new fml::FlutterMapObserver();
    observer->on_map_change = on_map_change;

    return observer;
}

mbgl_tile_server_options_t tile_server_options_map_tiler_create()
{
    auto options = TileServerOptions::MapTilerConfiguration();
    return new TileServerOptions(options);
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

    // std::promise<void> p;

    // _run_loop->schedule([&] {

    _map->jumpTo(CameraOptions()
                     .withCenter(LatLng { lat, lon })
                     .withZoom(zoom)
                     .withBearing(bearing)
                     .withPitch(pitch));

    //     p.set_value();
    // });

    // auto future = p.get_future();
    // future.wait();
}

void flutter_renderer_frontend_reduce_memory_use(fml_flutter_renderer_frontend_t frontend)
{
    auto frontend_ = static_cast<fml::FlutterRendererFrontend*>(frontend);
    frontend_->reduceMemoryUse();
}

void flutter_renderer_frontend_set_size(fml_flutter_renderer_frontend_t frontend, mbgl_map_t map, int32_t width, int32_t height, double pixelRatio)
{
    auto frontend_ = static_cast<fml::FlutterRendererFrontend*>(frontend);
    auto map_ = static_cast<mbgl::Map*>(map);

    frontend_->setSizeAndPixelRatio({ width, height }, pixelRatio);
    map_->setSize({ width, height });
}
