#include "stdio.h"
#include "pxcupipeline.h"

namespace senz3d {

    class Senz3d {

        PXCUPipeline_Instance instance;

        public:
            
            Senz3d();
            ~Senz3d();

            // size of the image
            int width, height;

            // get Image Size
            void getPictureSize(int* width, int* height);

            // get One Picture
            unsigned int* getPicture(void);

            // capture image stream

            // release image stream


    };
}