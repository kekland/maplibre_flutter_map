#include <mbgl/map/map.hpp>

using namespace mbgl;

class FlutterMapLibreObserver : public mbgl::MapObserver {
  public:
    void (*on_map_change)();
  
    void onDidFinishRenderingFrame(RenderFrameStatus) override;
};