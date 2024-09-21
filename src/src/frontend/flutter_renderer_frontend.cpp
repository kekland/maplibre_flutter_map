#include "flutter_renderer_frontend.hpp"

#include <mbgl/actor/scheduler.hpp>
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

#include <mbgl/mtl/headless_backend.hpp>

#include <future>
#include <iostream>

// update -> wake ticker -> renderFrame

extern "C" void flutter_texture_frame_available(int64_t textureId);
extern "C" void mapLibreFlutterTexture_createBuffer(void* ptr, int64_t width, int64_t height, int64_t channels);
extern "C" void mapLibreFlutterTexture_setRenderCallback(void* ptr, void* frontendPtr, void* (*callback)(void*));

void* flutter_texture_render_callback(void* frontendPtr)
{
    auto frontend = reinterpret_cast<fml::FlutterRendererFrontend*>(frontendPtr);

    bool didRender = frontend->asyncRenderFrameBlocking();

    if (!didRender) {
        return nullptr;
    }

    auto stillImage = frontend->readStillImage();
    std::cout << "Rendered" << std::endl;
    std::cout << "Address: " << (void*)stillImage.data.get() << std::endl;
    std::cout << "Bytes: " << stillImage.bytes() << std::endl;

    // Allocate new memory for the data
    size_t dataSize = stillImage.bytes();
    void* dataCopy = malloc(dataSize);
    memcpy(dataCopy, stillImage.data.get(), dataSize);

    return dataCopy;
}

namespace fml {
FlutterRendererFrontend::FlutterRendererFrontend(mbgl::Size size_,
    float pixelRatio_,
    int64_t flutterTextureId_,
    void* flutterTexturePointer_,
    mbgl::gfx::HeadlessBackend::SwapBehaviour swapBehavior,
    const mbgl::gfx::ContextMode contextMode,
    const std::optional<std::string>& localFontFamily,
    std::function<void()> flutterInvalidateTicker_)
    : size(size_)
    , pixelRatio(pixelRatio_)
    , flutterTextureId(flutterTextureId_)
    , flutterTexturePointer(flutterTexturePointer_)
    , frameTime(0)
    , backend(mbgl::gfx::HeadlessBackend::Create(
          { static_cast<uint32_t>(size.width * pixelRatio), static_cast<uint32_t>(size.height * pixelRatio) },
          swapBehavior,
          contextMode))
    , asyncInvalidate([this] { renderFrame(); })
    , renderer(std::make_unique<mbgl::Renderer>(*getBackend(), pixelRatio, localFontFamily))
    , flutterInvalidateTicker(flutterInvalidateTicker_)
{
    auto backendSize = backend->getSize();
    mapLibreFlutterTexture_createBuffer(flutterTexturePointer, backendSize.width, backendSize.height, 4);
    mapLibreFlutterTexture_setRenderCallback(
        flutterTexturePointer,
        this,
        flutter_texture_render_callback);
}

FlutterRendererFrontend::~FlutterRendererFrontend() = default;

void FlutterRendererFrontend::reset()
{
    assert(renderer);
    renderer.reset();
}

void FlutterRendererFrontend::update(std::shared_ptr<mbgl::UpdateParameters> updateParameters_)
{
    updateParameters = updateParameters_;

    flutter_texture_frame_available(flutterTextureId);
}

const mbgl::TaggedScheduler& FlutterRendererFrontend::getThreadPool() const
{
    return backend->getRendererBackend()->getThreadPool();
}

void FlutterRendererFrontend::setObserver(mbgl::RendererObserver& observer_)
{
    assert(renderer);
    renderer->setObserver(&observer_);
}

double FlutterRendererFrontend::getFrameTime() const
{
    return frameTime;
}

mbgl::Size FlutterRendererFrontend::getSize() const
{
    return size;
}

mbgl::Renderer* FlutterRendererFrontend::getRenderer()
{
    assert(renderer);
    return renderer.get();
}

mbgl::gfx::RendererBackend* FlutterRendererFrontend::getBackend()
{
    return backend->getRendererBackend();
}

mbgl::CameraOptions FlutterRendererFrontend::getCameraOptions()
{
    if (updateParameters)
        return mbgl::RendererState::getCameraOptions(*updateParameters);

    static mbgl::CameraOptions nullCamera;
    return nullCamera;
}

bool FlutterRendererFrontend::hasImage(const std::string& id)
{
    if (updateParameters) {
        return mbgl::RendererState::hasImage(*updateParameters, id);
    }

    return false;
}

bool FlutterRendererFrontend::hasLayer(const std::string& id)
{
    if (updateParameters) {
        return mbgl::RendererState::hasLayer(*updateParameters, id);
    }

    return false;
}

bool FlutterRendererFrontend::hasSource(const std::string& id)
{
    if (updateParameters) {
        return mbgl::RendererState::hasSource(*updateParameters, id);
    }

    return false;
}

mbgl::ScreenCoordinate FlutterRendererFrontend::pixelForLatLng(const mbgl::LatLng& coordinate)
{
    if (updateParameters) {
        return mbgl::RendererState::pixelForLatLng(*updateParameters, coordinate);
    }

    return mbgl::ScreenCoordinate {};
}

mbgl::LatLng FlutterRendererFrontend::latLngForPixel(const mbgl::ScreenCoordinate& point)
{
    if (updateParameters) {
        return mbgl::RendererState::latLngForPixel(*updateParameters, point);
    }

    return mbgl::LatLng {};
}

void FlutterRendererFrontend::setSize(mbgl::Size size_)
{
    if (size != size_) {
        size = size_;
        backend->setSize(
            { static_cast<uint32_t>(size_.width * pixelRatio), static_cast<uint32_t>(size_.height * pixelRatio) });
    }
}

float FlutterRendererFrontend::getPixelRatio() const
{
    return pixelRatio;
}

void FlutterRendererFrontend::setPixelRatio(float ratio)
{
    if (pixelRatio != ratio) {
        pixelRatio = ratio;
        backend->setSize(
            { static_cast<uint32_t>(size.width * pixelRatio), static_cast<uint32_t>(size.height * pixelRatio) });
    }
}

std::atomic<bool> pendingSizeChange = false;

void FlutterRendererFrontend::setSizeAndPixelRatio(mbgl::Size size_, float ratio)
{
    if (size != size_ || pixelRatio != ratio) {
        std::cout << "Setting size and pixel ratio" << std::endl;
        std::cout << "Size: " << size_.width << "x" << size_.height << std::endl;
        std::cout << "Pixel ratio: " << ratio << std::endl;

        size = size_;
        pixelRatio = ratio;

        backend->setSize({ static_cast<uint32_t>(size.width * pixelRatio), static_cast<uint32_t>(size.height * pixelRatio) });
        auto backendSize = backend->getSize();

        mapLibreFlutterTexture_createBuffer(flutterTexturePointer, backendSize.width, backendSize.height, 4);
    }
}

mbgl::PremultipliedImage FlutterRendererFrontend::readStillImage()
{
    return backend->readStillImage();
}

int renderCount = 0;
std::atomic<bool> isRendering = false;

std::promise<bool>* framePromisePtr;

bool FlutterRendererFrontend::renderFrame()
{
    if (isRendering) {
        if (framePromisePtr != nullptr) {
            framePromisePtr->set_value(false);
        }

        return false;
    }

    if (renderer && updateParameters) {
        isRendering = true;

        mbgl::gfx::BackendScope guard { *getBackend() };

        // onStyleImageMissing might be called during a render. The user
        // implemented method could trigger a call to
        // MLNRenderFrontend#update which overwrites `updateParameters`.
        // Copy the shared pointer here so that the parameters aren't
        // destroyed while `render(...)` is still using them.
        auto updateParameters_ = updateParameters;
        renderer->render(updateParameters_);

        std::cout << "Texture ID: " << flutterTextureId << " Rendered: " << renderCount++ << std::endl;

        isRendering = false;

        if (framePromisePtr != nullptr) {
            framePromisePtr->set_value(true);
        }

        return true;
    }

    if (framePromisePtr != nullptr) {
        framePromisePtr->set_value(false);
    }

    return false;
}

void FlutterRendererFrontend::asyncRenderFrame()
{
    asyncInvalidate.send();
}

bool FlutterRendererFrontend::asyncRenderFrameBlocking()
{
    auto promise = std::promise<bool>();

    framePromisePtr = &promise;
    asyncInvalidate.send();

    bool result = promise.get_future().get();
    framePromisePtr = nullptr;

    return result;
}

void FlutterRendererFrontend::reduceMemoryUse()
{
    if (!renderer)
        return;
    renderer->reduceMemoryUse();
}

std::optional<mbgl::TransformState> FlutterRendererFrontend::getTransformState() const
{
    if (updateParameters) {
        return updateParameters->transformState;
    } else {
        return {};
    }
}

} // namespace fml
