#include "senz3d.h"
#include "stdio.h"
#include "pxcupipeline.h"

namespace senz3d {

    Senz3d::Senz3d() {
        instance = PXCUPipeline_Create();
        mode = PXCU_PIPELINE_COLOR_VGA;
    }
    Senz3d::Senz3d(PXCUPipeline CamMode) {
        instance = PXCUPipeline_Create();
        mode = CamMode;
    }

    Senz3d::~Senz3d() {
        PXCUPipeline_Destroy(instance);
    }

    bool Senz3d::init() {
        bool init;
        init = PXCUPipeline_Init(instance, mode);
        getPictureSize(&width, &height);
        return init;
    }

    void Senz3d::close() {
        PXCUPipeline_Close(instance);
    }

    void Senz3d::getPictureSize(int* width, int* height) {
        PXCUPipeline_AcquireFrame(instance, true);
        
        switch (mode) {
            case PXCU_PIPELINE_COLOR_VGA:
            case PXCU_PIPELINE_COLOR_WXGA:
                PXCUPipeline_QueryRGBSize(instance, width, height);
            case PXCU_PIPELINE_DEPTH_QVGA:
            case PXCU_PIPELINE_DEPTH_QVGA_60FPS:
                PXCUPipeline_QueryDepthMapSize(instance, width, height);
        }

        PXCUPipeline_ReleaseFrame(instance);
    }

    void* Senz3d::getPicture() {

        PXCUPipeline_AcquireFrame(instance, true);

        void* data = NULL;

        switch (mode) {
            case PXCU_PIPELINE_COLOR_VGA:
            case PXCU_PIPELINE_COLOR_WXGA:
                data = new unsigned int[height*width];
                PXCUPipeline_QueryRGB(instance, (unsigned char*)data);
                break;

            case PXCU_PIPELINE_DEPTH_QVGA:
            case PXCU_PIPELINE_DEPTH_QVGA_60FPS:
                data = new short[height*width];
                PXCUPipeline_QueryDepthMap(instance, (short*)data);
                break;

            // add case for IR and UV images

            default:
                break;
        }

        PXCUPipeline_ReleaseFrame(instance);

        return (void*)data;
    }
}