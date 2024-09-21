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
// #include <mbgl/util/logging.hpp>
// #include <mbgl/util/run_loop.hpp>

// #include <cstdlib>
// #include <iostream>
// #include <fstream>

// #include "../src/flutter_map_observer.hpp"
// #include "../src/flutter_renderer_observer.hpp"
// #include "../src/frontend/flutter_renderer_frontend.hpp"
// #include "../src/maplibre_flutter_map.h"

// int main()
// {
//     mbgl::util::RunLoop runLoop;

//     auto width = 512;
//     auto height = 512;
//     auto pixel_ratio = 1.0;

//     int frameCount = 0;

//     mbgl::HeadlessFrontend* frontend = new mbgl::HeadlessFrontend({ width, height },
//         pixel_ratio,
//         mbgl::gfx::Renderable::SwapBehaviour::Flush, mbgl::gfx::ContextMode::Unique, std::nullopt, true);

//     auto observer = new fml::FlutterMapObserver();
//     observer->on_map_change = []() {
//         std::cout << "Map changed" << std::endl;
//     };

//     auto options = mbgl::TileServerOptions::MapTilerConfiguration();

//     auto map = new mbgl::Map(
//         *frontend, *observer,
//         mbgl::MapOptions()
//             .withMapMode(mbgl::MapMode::Static)
//             .withSize(frontend->getSize())
//             .withPixelRatio(pixel_ratio),
//         mbgl::ResourceOptions().withApiKey("5IZuFl4CkB3Io0SjxUVJ").withTileServerOptions(options));

//     map->getStyle().loadURL("https://api.maptiler.com/maps/7d5f4aed-f3bb-4c46-8dee-e1e79cd2e12b/style.json?key=5IZuFl4CkB3Io0SjxUVJ");

//     try {
//         std::ofstream out("/Users/kekland/image15.png", std::ios::binary);
//         out << encodePNG(frontend->render(*map).image);
//         out.close();
//     } catch (std::exception& e) {
//         std::cout << "Error: " << e.what() << std::endl;
//         exit(1);
//     }
// }
