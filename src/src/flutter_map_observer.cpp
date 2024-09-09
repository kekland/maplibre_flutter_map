#include "flutter_map_observer.hpp"

#include <mbgl/map/map.hpp>
#include <mbgl/map/map_options.hpp>
#include <mbgl/util/image.hpp>
#include <mbgl/util/run_loop.hpp>

#include <mbgl/gfx/backend.hpp>
#include <mbgl/gfx/headless_frontend.hpp>
#include <mbgl/style/style.hpp>

#include <cstdlib>
#include <iostream>
#include <fstream>

using namespace std;
using namespace mbgl;

void FlutterMapLibreObserver::onDidFinishRenderingFrame(RenderFrameStatus status)
{
    std::cout << "Finished rendering frame" << status.frameRenderingTime << std::endl;
    on_map_change();
}