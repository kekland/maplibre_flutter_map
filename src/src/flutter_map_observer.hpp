#include <iostream>

#include <mbgl/map/map.hpp>

using namespace mbgl;

namespace fml {

class FlutterMapObserver : public mbgl::MapObserver {
public:
    void (*on_map_change)();

    void onCameraWillChange(CameraChangeMode) override
    {
        std::cout << " -- onCameraWillChange" << std::endl;
    }

    void onCameraIsChanging() override
    {
        std::cout << " -- onCameraIsChanging" << std::endl;
    }

    void onCameraDidChange(CameraChangeMode) override
    {
        std::cout << " -- onCameraDidChange" << std::endl;
    }

    void onWillStartLoadingMap() override
    {
        std::cout << " -- onWillStartLoadingMap" << std::endl;
    }

    void onDidFinishLoadingMap() override
    {
        std::cout << " -- onDidFinishLoadingMap" << std::endl;
    }

    void onDidFailLoadingMap(MapLoadError, const std::string&) override
    {
        std::cout << " -- onDidFailLoadingMap" << std::endl;
    }

    void onWillStartRenderingFrame() override
    {
        std::cout << " -- onWillStartRenderingFrame" << std::endl;
    }

    void onDidFinishRenderingFrame(RenderFrameStatus status) override
    {
        std::cout << " -- onDidFinishRenderingFrame" << std::endl;
        std::cout << status.frameEncodingTime << " " << status.frameRenderingTime << " " << (uint32_t)status.mode << " " << status.needsRepaint << " " << status.placementChanged << std::endl;
        on_map_change();
    }

    void onWillStartRenderingMap() override
    {
        std::cout << " -- onWillStartRenderingMap" << std::endl;
    }

    void onDidFinishRenderingMap(RenderMode mode) override
    {
        std::cout << " -- onDidFinishRenderingMap" << std::endl;
        std::cout << (uint32_t)mode << std::endl;
    }

    void onDidFinishLoadingStyle() override
    {
        std::cout << " -- onDidFinishLoadingStyle" << std::endl;
    }

    void onSourceChanged(style::Source&) override
    {
        std::cout << " -- onSourceChanged" << std::endl;
    }

    void onDidBecomeIdle() override
    {
        std::cout << " -- onDidBecomeIdle" << std::endl;
    }

    void onStyleImageMissing(const std::string&) override
    {
        std::cout << " -- onStyleImageMissing" << std::endl;
    }

    bool onCanRemoveUnusedStyleImage(const std::string&) override
    {
        std::cout << " -- onCanRemoveUnusedStyleImage" << std::endl;
        return true;
    }

    void onRegisterShaders(gfx::ShaderRegistry&) override
    {
        std::cout << " -- onRegisterShaders" << std::endl;
    }

    void onPreCompileShader(shaders::BuiltIn, gfx::Backend::Type, const std::string&) override
    {
        std::cout << " -- onPreCompileShader" << std::endl;
    }

    void onPostCompileShader(shaders::BuiltIn, gfx::Backend::Type, const std::string&) override
    {
        std::cout << " -- onPostCompileShader" << std::endl;
    }

    void onShaderCompileFailed(shaders::BuiltIn, gfx::Backend::Type, const std::string&) override
    {
        std::cout << " -- onShaderCompileFailed" << std::endl;
    }

    void onGlyphsLoaded(const FontStack&, const GlyphRange&) override
    {
        std::cout << " -- onGlyphsLoaded" << std::endl;
    }

    void onGlyphsError(const FontStack&, const GlyphRange&, std::exception_ptr) override
    {
        std::cout << " -- onGlyphsError" << std::endl;
    }

    void onGlyphsRequested(const FontStack&, const GlyphRange&) override
    {
        std::cout << " -- onGlyphsRequested" << std::endl;
    }

    void onTileAction(TileOperation operation, const OverscaledTileID& id, const std::string& action) override
    {
        std::cout << " -- onTileAction" << std::endl;
        std::cout << (uint32_t)operation << " " << id.overscaledZ << " " << id.canonical.z << " " << id.canonical.x << " " << id.canonical.y << " " << action << std::endl;
    }

    void onSpriteLoaded(const std::optional<style::Sprite>&) override
    {
        std::cout << " -- onSpriteLoaded" << std::endl;
    }

    void onSpriteError(const std::optional<style::Sprite>&, std::exception_ptr) override
    {
        std::cout << " -- onSpriteError" << std::endl;
    }

    void onSpriteRequested(const std::optional<style::Sprite>&) override
    {
        std::cout << " -- onSpriteRequested" << std::endl;
    }
};
}