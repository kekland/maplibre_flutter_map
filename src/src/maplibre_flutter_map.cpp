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
    void (*invalidateFlutterTicker)(),
    void (*onFrameRendered)())
{
    auto run_loop = mbgl::util::RunLoop(mbgl::util::RunLoop::Type::New);

    auto width = 512;
    auto height = 512;
    auto pixel_ratio = 1.0;

    auto frontend = new fml::FlutterRendererFrontend({ width, height },
        pixel_ratio,
        mbgl::gfx::Renderable::SwapBehaviour::NoFlush,
        mbgl::gfx::ContextMode::Unique,
        std::nullopt,
        invalidateFlutterTicker);

    auto observer = new fml::FlutterMapObserver();
    observer->on_map_change = onFrameRendered;

    auto rendererObserver = new fml::FlutterRendererObserver();
    frontend->setObserver(*rendererObserver);

    auto options = mbgl::TileServerOptions::MapTilerConfiguration();

    auto map = new mbgl::Map(
        *frontend, *observer,
        mbgl::MapOptions()
            .withMapMode(mbgl::MapMode::Continuous)
            .withSize(frontend->getSize())
            .withPixelRatio(pixel_ratio),
        mbgl::ResourceOptions().withApiKey("5IZuFl4CkB3Io0SjxUVJ").withTileServerOptions(options));

    auto style = "https://api.maptiler.com/maps/7d5f4aed-f3bb-4c46-8dee-e1e79cd2e12b/style.json?key=5IZuFl4CkB3Io0SjxUVJ";
    map->getStyle().loadURL(style);

    p.set_value(std::make_tuple(&run_loop, frontend, map));
    std::cout << "Thread replied" << std::endl;

    run_loop.run();

    std::cout << "Thread finished" << std::endl;
}

maplibre_thread_data start_run_loop_thread(
    void (*_invalidateFlutterTicker)(),
    void (*_onFrameRendered)())
{
    std::promise<std::tuple<mbgl::util::RunLoop*, fml::FlutterRendererFrontend*, mbgl::Map*>> p;
    auto future = p.get_future();
    
    auto thread = std::thread(_run_loop_thread, std::ref(p), _invalidateFlutterTicker, _onFrameRendered);

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
    frontend_->asyncRenderFrame();
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
    std::cout << "JUMPING HAHA" << std::endl;

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
