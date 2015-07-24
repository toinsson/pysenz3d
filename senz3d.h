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

            // size of the image
            int width, height;

            // connect to the camera
            bool init(void);
            // close the connection
            void close(void);

            // get Image Size
            void getPictureSize(int* width, int* height);

            // get One Picture
            void* getPicture(void);
    };
}