#include <chrono>
#include <future>
#include <iostream>
#include <thread>
#include <tuple>

#include <mbgl/gfx/backend.hpp>
#include <mbgl/gfx/headless_frontend.hpp>
#include <mbgl/map/map.hpp>
#include <mbgl/map/map_options.hpp>
#include <mbgl/style/style.hpp>
#include <mbgl/util/image.hpp>
#include <mbgl/util/run_loop.hpp>

#include "../src/flutter_map_observer.hpp"
#include "../src/maplibre_flutter_map.h"

void _run_loop_thread(std::promise<std::tuple<mbgl::util::RunLoop*, mbgl::HeadlessFrontend*, mbgl::Map*>>& p, void (*_observer)())
{
    auto run_loop = mbgl::util::RunLoop(mbgl::util::RunLoop::Type::New);

    auto width = 512;
    auto height = 512;
    auto pixel_ratio = 1.0;

    auto frontend = new mbgl::HeadlessFrontend({ width, height }, pixel_ratio);
    auto observer = new FlutterMapLibreObserver();
    observer->on_map_change = _observer;

    auto options = TileServerOptions::MapTilerConfiguration();

    auto map = new Map(
        *frontend, *observer,
        MapOptions()
            .withMapMode(MapMode::Continuous)
            .withSize(frontend->getSize())
            .withPixelRatio(pixel_ratio),
        ResourceOptions().withApiKey("5IZuFl4CkB3Io0SjxUVJ").withTileServerOptions(options));

    p.set_value(std::make_tuple(&run_loop, frontend, map));
    std::cout << "Thread replied" << std::endl;

    run_loop.run();

    std::cout << "Thread finished" << std::endl;
}

void run_loop_invoke_wait(mbgl::util::RunLoop* run_loop, std::function<void()> fn)
{
    std::promise<void> p;
    auto f = p.get_future();

    run_loop->invoke(mbgl::util::RunLoop::Priority::High, [&]() {
        fn();
        p.set_value();
    });

    f.get();
}

void wait_for_seconds(int seconds)
{
    std::this_thread::sleep_for(std::chrono::seconds(seconds));
}

int main()
{
    std::promise<std::tuple<mbgl::util::RunLoop*, mbgl::HeadlessFrontend*, mbgl::Map*>> p;
    auto f = p.get_future();

    std::thread t(_run_loop_thread, std::ref(p), []() {
        std::cout << "Map changed" << std::endl;
    });

    auto [run_loop, frontend, map] = f.get();
    auto style = "https://api.maptiler.com/maps/7d5f4aed-f3bb-4c46-8dee-e1e79cd2e12b/style.json?key=5IZuFl4CkB3Io0SjxUVJ";

    std::cout << "Main thread received" << std::endl;

    run_loop_invoke_wait(run_loop, [&]() {
        map->getStyle().loadURL(style);
    });

    std::cout << "Main thread loaded style" << std::endl;

    wait_for_seconds(2);

    std::cout << "Beginning test sequence" << std::endl;

    run_loop_invoke_wait(run_loop, [&]() {
        map->jumpTo(CameraOptions().withCenter(LatLng(37.7749, -122.4194)).withZoom(12));
    });

    run_loop_invoke_wait(run_loop, [&]() {
        map->jumpTo(CameraOptions().withCenter(LatLng(37.7749, -122.4194)).withZoom(12));
    });

    t.join();
    return 0;
}
