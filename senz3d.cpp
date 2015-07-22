#include "senz3d.h"
#include "stdio.h"
#include "pxcupipeline.h"

namespace senz3d {

    Senz3d::Senz3d() {
        // 
        instance = PXCUPipeline_Create();
        PXCUPipeline_Init(instance, PXCU_PIPELINE_COLOR_VGA);

        // set the size for future
        getPictureSize(&width, &height);
    }

    Senz3d::~Senz3d() { 
        PXCUPipeline_Close(instance);
    }

    // // get Picture Size
    void Senz3d::getPictureSize(int* width, int* height) {
        // is it needed to acquire frame for this function call .. ?
        PXCUPipeline_AcquireFrame(instance, true);
        PXCUPipeline_QueryRGBSize(instance, width, height);
        PXCUPipeline_ReleaseFrame(instance);
    }

    // get One Picture
    unsigned int* Senz3d::getPicture() {

        PXCUPipeline_AcquireFrame(instance, true);

        int width, height = 0;
        PXCUPipeline_QueryRGBSize(instance, &width, &height);

        unsigned int* data = new unsigned int[height*width];

        PXCUPipeline_QueryRGB(instance, (unsigned char *)data);
        PXCUPipeline_ReleaseFrame(instance);

        return data;
    }

    // capture image stream
    // TBD

    // release image stream
    // TBD
}