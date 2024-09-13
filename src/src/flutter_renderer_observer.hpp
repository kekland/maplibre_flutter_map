#include <iostream>

#include <mbgl/map/map.hpp>
#include <mbgl/renderer/renderer_observer.hpp>

namespace fml {

class FlutterRendererObserver : public mbgl::RendererObserver {
public:
    void (*on_map_change)();

    void onInvalidate() override
    {
        std::cout << "-- onInvalidate" << std::endl;
    }
};
}