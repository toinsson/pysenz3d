#include "senz3d.h"

#include "stdio.h"
#include "pxcupipeline.h"


namespace senz3d {

    Rectangle::Rectangle(int X0, int Y0, int X1, int Y1) {
        x0 = X0;
        y0 = Y0;
        x1 = X1;
        y1 = Y1;
    }

    Rectangle::~Rectangle() { }

    int Rectangle::getLength() {
        return (x1 - x0);
    }

    int Rectangle::getHeight() {
        return (y1 - y0);
    }

    int Rectangle::getArea() {
        return (x1 - x0) * (y1 - y0);
    }

    void Rectangle::move(int dx, int dy) {
        x0 += dx;
        y0 += dy;
        x1 += dx;
        y1 += dy;
    }

    int Rectangle::getPicture() {
        // create instance
        PXCUPipeline_Instance instance = PXCUPipeline_Create();
        PXCUPipeline_Init(instance, PXCU_PIPELINE_COLOR_VGA);

        int width = 0;
        int height = 0;

        PXCUPipeline_AcquireFrame(instance, true);
        PXCUPipeline_QueryRGBSize(instance, &width, &height);

        // printf("width: %i, height: %i", width, height);

        unsigned char* data = new unsigned char[height*width * 4];
        //unsigned char data1[480][640];


        //for (int i = 0; i < height; i++)
        //  data[i] = new unsigned char[width];

        PXCUPipeline_QueryRGB(instance, data);

        // ofstream myfile("image.txt");

        // if (myfile.is_open())
        // {

        //     for (int count = 0; count < height*width * 4; count++){
        //         myfile << data[count];
        //     }
        //     myfile.close();
        // }
        return 0;

    }

}