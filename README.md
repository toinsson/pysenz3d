# pysenz3d

This is a Python wrapper for the libpxcupipeline from the [Intel Percpetual Computing SDK] (https://software.intel.com/sites/landingpage/perceptual_computing/documentation/html/). 

The library **libpxcupipeline** provides a highly simplified level interface to the SDK with access to color picture capturing, 
as well as face location, finger tracking and voice recognition. 
The focus if this wrapper is to provide an efficient interface to picture capturing only, but it can easily be extended.

The Python interface is built using Cython, and is using the DLLs from libxcupipeline and libpxcutils. 

## Compiling the python wrapper
The compilation relies on the above mentioned DLLs, and the compilation with Visual Studio 2008 for compatibility reason with Python.
Using the distutils methods, you can execute:

```
python setup.py build
```

to create the pysenz3d python module.

## Usage:
To start the you will choose the mode with which the module is supposed to operate. This is static per instance.
Mode available are RGB, Depth, UV, ...
```
from pysenz3d import PySenz3d
```
Once the instance is created, you can query the image size and a picture at a time with `getPicture()`.
```
cam = PySenz3d()
pic = cam.getPicture()
```
The other way is to set up a process that will create an image stream into a deque that is accessible from the main process.

## Compiling the libxcupipeline DLL
The project is provided as a Visual Studio 2013 file, note that this is usually included in the SDK.

## Compiling the libpxcutils DLL
The project is provided as a Visual Studio 2013 file, note that this is usually included in the SDK.
