// #include <mbgl/map/map.hpp>
// #include <mbgl/map/map_options.hpp>
// #include <mbgl/util/image.hpp>
// #include <mbgl/util/run_loop.hpp>

// #include <mbgl/gfx/backend.hpp>
// #include <mbgl/gfx/headless_frontend.hpp>
// #include <mbgl/renderer/renderer.hpp>
// #include <mbgl/style/style.hpp>

// #include <cstdlib>
// #include <fstream>
// #include <iostream>

// using namespace std;
// using namespace mbgl;

// class FlutterRendererFrontend : public mbgl::RendererFrontend {
// public:
//     FlutterRendererFrontend(std::unique_ptr<mbgl::Renderer> renderer_,
//         mbgl::gfx::RendererBackend& mbglBackend_)
//         : renderer(std::move(renderer_))
//         , mbglBackend(mbglBackend_)
//     {
//         mbgl::gfx::Backend::Create()
//     }

//     void reset() override
//     {
//         if (renderer) {
//             renderer.reset();
//         }
//     }

//     void update(std::shared_ptr<mbgl::UpdateParameters> updateParameters_) override
//     {
//         updateParameters = std::move(updateParameters_);
//         if (asyncInvalidate) {
//             asyncInvalidate->send();
//         }
//     }

//     const mbgl::TaggedScheduler& getThreadPool() const override
//     {
//         return mbglBackend.getThreadPool();
//     }

//     void setObserver(mbgl::RendererObserver& observer) override
//     {
//         if (!renderer)
//             return;

//         renderer->setObserver(&observer);
//     }

// private:
//     std::unique_ptr<mbgl::Renderer> renderer;
//     mbgl::gfx::RendererBackend& mbglBackend;
//     std::shared_ptr<mbgl::UpdateParameters> updateParameters;
//     std::optional<mbgl::util::AsyncTask> asyncInvalidate;
// };