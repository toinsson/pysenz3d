#include "stdio.h"
#include "pxcupipeline.h"

namespace senz3d {

    class Senz3d {

        PXCUPipeline_Instance instance;

        // camera mode, can be VGA, XVGA, QVGA
        PXCUPipeline mode;

        public:
            
            Senz3d();
            Senz3d(PXCUPipeline mode);
            ~Senz3d();

            //
            // bool init(void);

            // size of the image
            int width, height;

            // get Image Size
            void getPictureSize(int* width, int* height);

            // get One Picture
            void* getPicture(void);

            // capture image stream

            // release image stream


    };
}