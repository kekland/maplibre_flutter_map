// #include <chrono>
// #include <future>
// #include <iostream>
// #include <thread>
// #include <tuple>

// #include <mbgl/actor/scheduler.hpp>
// #include <mbgl/gfx/backend.hpp>
// #include <mbgl/gfx/headless_backend.hpp>
// #include <mbgl/gfx/headless_frontend.hpp>
// #include <mbgl/gfx/renderable.hpp>
// #include <mbgl/map/map.hpp>
// #include <mbgl/map/map_options.hpp>
// #include <mbgl/style/style.hpp>
// #include <mbgl/util/image.hpp>
// #include <mbgl/util/run_loop.hpp>
// #include <mbgl/util/logging.hpp>

// #include "../src/frontend/flutter_renderer_frontend.hpp"
// #include "../src/flutter_map_observer.hpp"
// #include "../src/flutter_renderer_observer.hpp"
// #include "../src/maplibre_flutter_map.h"

// void _run_loop_thread(std::promise<std::tuple<mbgl::util::RunLoop*, fml::FlutterRendererFrontend*, mbgl::Map*>>& p, void (*_observer)())
// {
//     auto run_loop = mbgl::util::RunLoop(mbgl::util::RunLoop::Type::New);

//     auto width = 512;
//     auto height = 512;
//     auto pixel_ratio = 1.0;

//     auto frontend = new fml::FlutterRendererFrontend({ width, height },
//         pixel_ratio,
//         mbgl::gfx::Renderable::SwapBehaviour::NoFlush, mbgl::gfx::ContextMode::Unique, std::nullopt, []() {
//             std::cout << "Hi!" << std::endl;
//         });
//     auto observer = new fml::FlutterMapObserver();
//     observer->on_map_change = _observer;

//     auto rendererObserver = new fml::FlutterRendererObserver();
//     frontend->setObserver(*rendererObserver);

//     auto options = mbgl::TileServerOptions::MapTilerConfiguration();

//     auto map = new mbgl::Map(
//         *frontend, *observer,
//         mbgl::MapOptions()
//             .withMapMode(mbgl::MapMode::Continuous)
//             .withSize(frontend->getSize())
//             .withPixelRatio(pixel_ratio),
//         mbgl::ResourceOptions().withApiKey("5IZuFl4CkB3Io0SjxUVJ").withTileServerOptions(options));

//     p.set_value(std::make_tuple(&run_loop, frontend, map));
//     std::cout << "Thread replied" << std::endl;

//     run_loop.run();

//     std::cout << "Thread finished" << std::endl;
// }

// void run_loop_invoke_wait(mbgl::util::RunLoop* run_loop, std::function<void()> fn)
// {
//     std::promise<void> p;
//     auto f = p.get_future();

//     run_loop->invoke(mbgl::util::RunLoop::Priority::High, [&]() {
//         fn();
//         p.set_value();
//     });

//     f.get();
// }

// void scheduler_schedule_wait(mbgl::Scheduler* scheduler, std::function<void()> fn)
// {
//     std::promise<void> p;
//     auto f = p.get_future();

//     scheduler->schedule([&]() {
//         fn();
//         p.set_value();
//     });

//     f.get();
// }

// void wait_for_seconds(int seconds)
// {
//     std::this_thread::sleep_for(std::chrono::seconds(seconds));
// }

// class _Observer : public mbgl::Log::Observer {
// public:
//     bool onRecord(mbgl::EventSeverity severity, mbgl::Event event, int64_t code, const std::string& msg) override
//     {
//         std::cout << "%% Log: " << msg << std::endl;
//         return true;
//     }
// };

// int main()
// {
//     auto observer = new _Observer();
//     mbgl::Log::setObserver(std::unique_ptr<_Observer>(observer));

//     std::promise<std::tuple<mbgl::util::RunLoop*, fml::FlutterRendererFrontend*, mbgl::Map*>> p;
//     auto f = p.get_future();

//     std::thread t(_run_loop_thread, std::ref(p), []() {
//         std::cout << "Map changed" << std::endl;
//     });

//     auto [run_loop, frontend, map] = f.get();
//     auto style = "https://api.maptiler.com/maps/7d5f4aed-f3bb-4c46-8dee-e1e79cd2e12b/style.json?key=5IZuFl4CkB3Io0SjxUVJ";

//     auto sequencer = run_loop->GetSequenced();
//     std::cout << "Main thread received" << std::endl;

//     run_loop_invoke_wait(run_loop, [&]() {
//         std::cout << "Setting style" << std::endl;
//         map->getStyle().loadURL(style);

//         std::cout << "Style loaded" << std::endl;
//         map->jumpTo(mbgl::CameraOptions().withCenter(mbgl::LatLng{43.1991413838172, 76.85274264579952}).withZoom(16.0).withBearing(0.0).withPitch(45.0));

//         std::cout << "Jumped" << std::endl;
//     });

//     std::cout << "Main thread loaded style" << std::endl;

//     wait_for_seconds(2);

//     std::cout << "Beginning test sequence" << std::endl;

//     scheduler_schedule_wait(sequencer.get(), [&]() {
//         std::cout << "Jumping to SF 1" << std::endl;
//         map->jumpTo(mbgl::CameraOptions().withCenter(mbgl::LatLng(37.7749, -122.4194)).withZoom(12));
//     });

//     scheduler_schedule_wait(sequencer.get(), [&]() {
//         std::cout << "Jumping to SF 2" << std::endl;
//         map->jumpTo(mbgl::CameraOptions().withCenter(mbgl::LatLng(37.7749, -122.4194)).withZoom(12));
//     });

//     // scheduler_schedule_wait(sequencer.get(), [&]() {
//     //     std::cout << "Rendering" << std::endl;
//     //     frontend->renderFrame();
//     // });

//     t.join();
//     return 0;
// }
