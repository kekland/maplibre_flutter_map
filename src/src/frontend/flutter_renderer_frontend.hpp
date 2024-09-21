#pragma once

#include <mbgl/gfx/headless_backend.hpp>
#include <mbgl/gfx/rendering_stats.hpp>
#include <mbgl/map/camera.hpp>
#include <mbgl/renderer/renderer_frontend.hpp>
#include <mbgl/util/async_task.hpp>
#include <mbgl/map/transform_state.hpp>
#include <mbgl/renderer/renderer.hpp>

#include <atomic>
#include <memory>
#include <optional>
#include <future>

namespace fml {

class FlutterRendererFrontend : public mbgl::RendererFrontend {
public:
    FlutterRendererFrontend(mbgl::Size,
        float pixelRatio_,
        int64_t flutterTextureId,
        void* flutterTexturePointer,
        mbgl::gfx::HeadlessBackend::SwapBehaviour swapBehavior = mbgl::gfx::HeadlessBackend::SwapBehaviour::NoFlush,
        mbgl::gfx::ContextMode mode = mbgl::gfx::ContextMode::Unique,
        const std::optional<std::string>& localFontFamily = std::nullopt,
        std::function<void()> flutterInvalidateTicker = []() {});
    ~FlutterRendererFrontend() override;

    void reset() override;
    void update(std::shared_ptr<mbgl::UpdateParameters>) override;
    const mbgl::TaggedScheduler& getThreadPool() const override;
    void setObserver(mbgl::RendererObserver&) override;

    double getFrameTime() const;

    mbgl::Size getSize() const;
    void setSize(mbgl::Size);

    float getPixelRatio() const;
    void setPixelRatio(float);

    void setSizeAndPixelRatio(mbgl::Size, float);

    mbgl::Renderer* getRenderer();
    mbgl::gfx::RendererBackend* getBackend();
    mbgl::gfx::HeadlessBackend* getHeadlessBackend() { return backend.get(); }
    mbgl::CameraOptions getCameraOptions();

    bool hasImage(const std::string&);
    bool hasLayer(const std::string&);
    bool hasSource(const std::string&);

    mbgl::ScreenCoordinate pixelForLatLng(const mbgl::LatLng&);
    mbgl::LatLng latLngForPixel(const mbgl::ScreenCoordinate&);

    mbgl::PremultipliedImage readStillImage();
    bool renderFrame();
    bool asyncRenderFrameBlocking();
    void asyncRenderFrame();

    void reduceMemoryUse();

    std::optional<mbgl::TransformState> getTransformState() const;

private:
    mbgl::Size size;
    float pixelRatio;

    int64_t flutterTextureId;
    void* flutterTexturePointer;

    std::atomic<double> frameTime;
    std::unique_ptr<mbgl::gfx::HeadlessBackend> backend;
    mbgl::util::AsyncTask asyncInvalidate;

    std::unique_ptr<mbgl::Renderer> renderer;
    std::shared_ptr<mbgl::UpdateParameters> updateParameters;

    std::function<void()> flutterInvalidateTicker;
};

} // namespace fml
