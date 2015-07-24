#include "senz3d.h"
#include "stdio.h"
#include "pxcupipeline.h"

namespace senz3d {

    Senz3d::Senz3d() {

        instance = PXCUPipeline_Create();
        mode = PXCU_PIPELINE_COLOR_VGA;
        PXCUPipeline_Init(instance, PXCU_PIPELINE_COLOR_VGA);

        // set the size for future use
        getPictureSize(&width, &height);
    }
    Senz3d::Senz3d(PXCUPipeline CamMode) {

        instance = PXCUPipeline_Create();
        PXCUPipeline_Init(instance, CamMode);
        mode = CamMode;

        // set the size for future use
        getPictureSize(&width, &height);
    }

    Senz3d::~Senz3d() { 
        PXCUPipeline_Close(instance);
    }

    // bool Senz3d::init() {
    //     return PXCUPipeline_Init(instance, mode);
    // }

    // get Picture Size
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

    // get One Picture
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

            default:
                break;
        }

        PXCUPipeline_ReleaseFrame(instance);

        return (void*)data;
    }

    // capture image stream
    // TBD

    // release image stream
    // TBD
}