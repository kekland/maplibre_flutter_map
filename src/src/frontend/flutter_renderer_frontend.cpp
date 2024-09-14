#include "flutter_renderer_frontend.hpp"

#include <mbgl/gfx/backend_scope.hpp>
#include <mbgl/gfx/context.hpp>
#include <mbgl/gfx/headless_frontend.hpp>
#include <mbgl/map/map.hpp>
#include <mbgl/map/transform_state.hpp>
#include <mbgl/renderer/renderer.hpp>
#include <mbgl/renderer/renderer_state.hpp>
#include <mbgl/renderer/update_parameters.hpp>
#include <mbgl/util/monotonic_timer.hpp>
#include <mbgl/util/run_loop.hpp>

// update -> wake ticker -> renderFrame

namespace fml {
FlutterRendererFrontend::FlutterRendererFrontend(mbgl::Size size_,
                                   float pixelRatio_,
                                   mbgl::gfx::HeadlessBackend::SwapBehaviour swapBehavior,
                                   const mbgl::gfx::ContextMode contextMode,
                                   const std::optional<std::string>& localFontFamily,
                                   std::function<void()> flutterInvalidateTicker_)
    : size(size_),
      pixelRatio(pixelRatio_),
      frameTime(0),
      backend(mbgl::gfx::HeadlessBackend::Create(
          {static_cast<uint32_t>(size.width * pixelRatio), static_cast<uint32_t>(size.height * pixelRatio)},
          swapBehavior,
          contextMode)),
      asyncInvalidate([this] { renderFrame(); }),
      renderer(std::make_unique<mbgl::Renderer>(*getBackend(), pixelRatio, localFontFamily)),
      flutterInvalidateTicker(flutterInvalidateTicker_) {}

FlutterRendererFrontend::~FlutterRendererFrontend() = default;

void FlutterRendererFrontend::reset() {
    assert(renderer);
    renderer.reset();
}

void FlutterRendererFrontend::update(std::shared_ptr<mbgl::UpdateParameters> updateParameters_) {
    updateParameters = updateParameters_;

    // std::cout << "Flutter Ticker call goes here to queue rendering..." << std::endl;

    // flutterInvalidateTicker();

    asyncInvalidate.send();
}

const mbgl::TaggedScheduler& FlutterRendererFrontend::getThreadPool() const {
    return backend->getRendererBackend()->getThreadPool();
}

void FlutterRendererFrontend::setObserver(mbgl::RendererObserver& observer_) {
    assert(renderer);
    renderer->setObserver(&observer_);
}

double FlutterRendererFrontend::getFrameTime() const {
    return frameTime;
}

mbgl::Size FlutterRendererFrontend::getSize() const {
    return size;
}

mbgl::Renderer* FlutterRendererFrontend::getRenderer() {
    assert(renderer);
    return renderer.get();
}

mbgl::gfx::RendererBackend* FlutterRendererFrontend::getBackend() {
    return backend->getRendererBackend();
}

mbgl::CameraOptions FlutterRendererFrontend::getCameraOptions() {
    if (updateParameters) return mbgl::RendererState::getCameraOptions(*updateParameters);

    static mbgl::CameraOptions nullCamera;
    return nullCamera;
}

bool FlutterRendererFrontend::hasImage(const std::string& id) {
    if (updateParameters) {
        return mbgl::RendererState::hasImage(*updateParameters, id);
    }

    return false;
}

bool FlutterRendererFrontend::hasLayer(const std::string& id) {
    if (updateParameters) {
        return mbgl::RendererState::hasLayer(*updateParameters, id);
    }

    return false;
}

bool FlutterRendererFrontend::hasSource(const std::string& id) {
    if (updateParameters) {
        return mbgl::RendererState::hasSource(*updateParameters, id);
    }

    return false;
}

mbgl::ScreenCoordinate FlutterRendererFrontend::pixelForLatLng(const mbgl::LatLng& coordinate) {
    if (updateParameters) {
        return mbgl::RendererState::pixelForLatLng(*updateParameters, coordinate);
    }

    return mbgl::ScreenCoordinate{};
}

mbgl::LatLng FlutterRendererFrontend::latLngForPixel(const mbgl::ScreenCoordinate& point) {
    if (updateParameters) {
        return mbgl::RendererState::latLngForPixel(*updateParameters, point);
    }

    return mbgl::LatLng{};
}

void FlutterRendererFrontend::setSize(mbgl::Size size_) {
    if (size != size_) {
        size = size_;
        backend->setSize(
            {static_cast<uint32_t>(size_.width * pixelRatio), static_cast<uint32_t>(size_.height * pixelRatio)});
    }
}

mbgl::PremultipliedImage FlutterRendererFrontend::readStillImage() {
    return backend->readStillImage();
}

void FlutterRendererFrontend::renderFrame() {
    if (renderer && updateParameters) {
        auto startTime = mbgl::util::MonotonicTimer::now();
        mbgl::gfx::BackendScope guard{*getBackend()};

        // onStyleImageMissing might be called during a render. The user
        // implemented method could trigger a call to
        // MLNRenderFrontend#update which overwrites `updateParameters`.
        // Copy the shared pointer here so that the parameters aren't
        // destroyed while `render(...)` is still using them.
        auto updateParameters_ = updateParameters;
        renderer->render(updateParameters_);

        auto endTime = mbgl::util::MonotonicTimer::now();
        frameTime = (endTime - startTime).count();
    }
}

void FlutterRendererFrontend::asyncRenderFrame() {
    asyncInvalidate.send();
}

    void FlutterRendererFrontend::reduceMemoryUse() {
        if (!renderer) return;
        renderer->reduceMemoryUse();
    }

std::optional<mbgl::TransformState> FlutterRendererFrontend::getTransformState() const {
    if (updateParameters) {
        return updateParameters->transformState;
    } else {
        return {};
    }
}

} // namespace fml
