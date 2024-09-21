#include <chrono>
#include <future>
#include <iostream>
#include <memory>
#include <thread>
#include <tuple>

#include <mbgl/actor/scheduler.hpp>
#include <mbgl/gfx/backend.hpp>
#include <mbgl/gfx/context.hpp>
#include <mbgl/gfx/headless_backend.hpp>
#include <mbgl/gfx/headless_frontend.hpp>
#include <mbgl/gfx/renderable.hpp>
#include <mbgl/gfx/renderer_backend.hpp>
#include <mbgl/map/map.hpp>
#include <mbgl/map/map_options.hpp>
#include <mbgl/style/style.hpp>
#include <mbgl/util/image.hpp>
#include <mbgl/util/logging.hpp>
#include <mbgl/util/run_loop.hpp>

#include "../src/flutter_map_observer.hpp"
#include "../src/flutter_renderer_observer.hpp"
#include "../src/frontend/flutter_renderer_frontend.hpp"
#include "../src/maplibre_flutter_map.h"

std::atomic<bool> dirty = false;

void _frameThread(fml::FlutterRendererFrontend* frontend)
{
    std::this_thread::sleep_for(std::chrono::seconds(8));

    // Execute a frame request every 16ms

    while (true) {
        std::this_thread::sleep_for(std::chrono::milliseconds(8));

        if (dirty) {
            frontend->asyncRenderFrame();
            dirty = false;
        }
    }
}

int main()
{
    auto run_loop = mbgl::util::RunLoop(mbgl::util::RunLoop::Type::Default);

    auto width = 512;
    auto height = 512;
    auto pixel_ratio = 1.0;

    int frameCount = 0;

    std::unique_ptr<fml::FlutterRendererFrontend>
        frontend(new fml::FlutterRendererFrontend({ width, height },
            pixel_ratio,
            mbgl::gfx::Renderable::SwapBehaviour::Flush, mbgl::gfx::ContextMode::Unique, std::nullopt, [&]() {
                dirty = true;
            }));

    auto observer = new fml::FlutterMapObserver();
    observer->on_map_change = []() {
        std::cout << "Map changed" << std::endl;
    };

    auto options = mbgl::TileServerOptions::MapboxConfiguration();

    auto map = new mbgl::Map(
        *frontend, *observer,
        mbgl::MapOptions()
            .withMapMode(mbgl::MapMode::Continuous)
            .withSize(frontend->getSize())
            .withPixelRatio(pixel_ratio),
        mbgl::ResourceOptions().withApiKey("pk.eyJ1Ijoia2VrbGFuZCIsImEiOiJjbHJ6Nm43cmsxcHdqMmlvNnB6ZW1xYWk3In0.JKPLXqYPGxdkz8jwzRrgBg").withTileServerOptions(options));

    map->getStyle().loadURL("mapbox://styles/mapbox/streets-v11");

    // Create a thread to execute the frame request
    std::thread frameThread(_frameThread, frontend.get());

    run_loop.run();
}
