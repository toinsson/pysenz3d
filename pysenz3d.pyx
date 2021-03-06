# distutils: language = c++
# distutils: sources = senz3d.cpp

# Import the Python-level symbols of numpy
import numpy as np
# Import the C-level symbols of numpy
cimport numpy as np
# Numpy must be initialized. When using numpy from C or Cython you must
# _always_ do that, or you will have segfaults
np.import_array()

from libc.stdlib cimport free
from cpython cimport PyObject, Py_INCREF
from libcpp cimport bool

cdef extern from "pxcupipeline.h":
    enum PXCUPipeline:
        PXCU_PIPELINE_COLOR_VGA         #=0x00000001
        PXCU_PIPELINE_COLOR_WXGA        #=0x00000010
        PXCU_PIPELINE_DEPTH_QVGA        #=0x00000020
        PXCU_PIPELINE_DEPTH_QVGA_60FPS  #=0x00000080

def enum(*sequential, **named):
    enums = dict(zip(sequential, range(len(sequential))), **named)
    reverse = dict((value, key) for key, value in enums.iteritems())
    enums['reverse_mapping'] = reverse
    return type('Enum', (), enums)

Senz3dMode = enum(
    COLOR_VGA        = PXCU_PIPELINE_COLOR_VGA,
    COLOR_WXGA       = PXCU_PIPELINE_COLOR_WXGA,
    DEPTH_QVGA       = PXCU_PIPELINE_DEPTH_QVGA,
    DEPTH_QVGA_60FPS = PXCU_PIPELINE_DEPTH_QVGA_60FPS,
    )

# include property enum in later release
# enum Property {
#     /* Single value properties */
#     PROPERTY_COLOR_EXPOSURE             =   1,
#     PROPERTY_COLOR_BRIGHTNESS           =   2,
#     PROPERTY_COLOR_CONTRAST             =   3,
#     PROPERTY_COLOR_SATURATION           =   4,
#     PROPERTY_COLOR_HUE                  =   5,
#     PROPERTY_COLOR_GAMMA                =   6,
#     PROPERTY_COLOR_WHITE_BALANCE        =   7,
#     PROPERTY_COLOR_SHARPNESS            =   8,
#     PROPERTY_COLOR_BACK_LIGHT_COMPENSATION  =   9,
#     PROPERTY_COLOR_GAIN                     =   10,
#     PROPERTY_AUDIO_MIX_LEVEL            =   100,

#     PROPERTY_DEPTH_SATURATION_VALUE     =   200,
#     PROPERTY_DEPTH_LOW_CONFIDENCE_VALUE =   201,
#     PROPERTY_DEPTH_CONFIDENCE_THRESHOLD =   202,
#     PROPERTY_DEPTH_SMOOTHING            =   203,
#     PROPERTY_DEPTH_UNIT                 =   204,   // in micron

#     PROPERTY_CAMERA_MODEL               =   300,

#     /* Two value properties */
#     PROPERTY_COLOR_FIELD_OF_VIEW        =   1000,
#     PROPERTY_COLOR_SENSOR_RANGE         =   1002,
#     PROPERTY_COLOR_FOCAL_LENGTH         =   1006,
#     PROPERTY_COLOR_PRINCIPAL_POINT      =   1008,

#     PROPERTY_DEPTH_FIELD_OF_VIEW        =   2000,
#     PROPERTY_DEPTH_SENSOR_RANGE         =   2002,
#     PROPERTY_DEPTH_FOCAL_LENGTH         =   2006,
#     PROPERTY_DEPTH_PRINCIPAL_POINT      =   2008,
    

#     /* Misc. */
#     PROPERTY_ACCELEROMETER_READING      =   3000,   // three values
#     PROPERTY_PROJECTION_SERIALIZABLE    =   3003,

#     /* Customized properties */
#     PROPERTY_CUSTOMIZED=0x04000000,
# };


cdef extern from "senz3d.h" namespace "senz3d":
    cdef cppclass Senz3d:
        Senz3d() except +
        Senz3d(PXCUPipeline) except +
        int width, height
        bool init()
        void close()
        void getPictureSize(int*, int*)
        void* getPicture()

cdef class PySenz3d:
    """
    Senz3d class to capture pictures from camera.
    The init function defaults to VGA mode but WXGA and QVGA are also
    available. The mode of choice can be passed in the init call via
    the enum Senz3dMode.
    """
    cdef Senz3d* senz3d      # hold a C++ instance which we're wrapping
    cdef PXCUPipeline mode
    cdef int data_type
    cdef readonly bool is_inited

    def __cinit__(self, PXCUPipeline mode = PXCU_PIPELINE_COLOR_VGA):
        self.is_inited = False
        self.mode = mode
        if mode == PXCU_PIPELINE_COLOR_VGA:
            self.data_type = np.NPY_INT
        if mode == PXCU_PIPELINE_COLOR_WXGA:
            self.data_type = np.NPY_INT
        if mode == PXCU_PIPELINE_DEPTH_QVGA:
            self.data_type = np.NPY_SHORT
        if mode == PXCU_PIPELINE_DEPTH_QVGA_60FPS:
            self.data_type = np.NPY_SHORT

    def __dealloc__(self):
        del self.senz3d

    def init(self):
        """Connect to the camera
        """
        self.senz3d = new Senz3d(self.mode)
        self.is_inited = True
        return self.senz3d.init()

    def close(self):
        self.is_inited = False
        self.senz3d.close()

    def get_picture_size(self):
        cdef int width, height

        self.senz3d.getPictureSize(&width, &height)
        return (width, height)

    def get_picture(self):

        cdef unsigned int* array
        cdef np.ndarray ndarray

        cdef int size = self.senz3d.width*self.senz3d.height
        array = <unsigned int*>self.senz3d.getPicture()

        array_wrapper = ArrayWrapper()
        array_wrapper.set_data(size, self.data_type, <void*> array) 

        ndarray = np.array(array_wrapper, copy=False)
        # Assign our object to the 'base' of the ndarray object
        ndarray.base = <PyObject*> array_wrapper
        # Increment the reference count, as the above assignement was done in
        # C, and Python does not know that there is this additional reference
        Py_INCREF(array_wrapper)

        return ndarray

    def __reduce__(self):
        return (rebuild, (self.mode,))

def rebuild(mode):
    p = PySenz3d(mode)
    return p

cdef class ArrayWrapper:
    cdef void* data_ptr
    cdef int data_type
    cdef int size

    cdef set_data(self, int size, int data_type, void* data_ptr):
        """ Set the data of the array
        This cannot be done in the constructor as it must receive C-level
        arguments.
        Parameters:
        -----------
        size: int
            Length of the array.
        data_ptr: void*
            Pointer to the data
        """
        self.data_ptr = data_ptr
        self.data_type = data_type
        self.size = size

    def __array__(self):
        """ Here we use the __array__ method, that is called when numpy
            tries to get an array from the object."""
        cdef np.npy_intp shape[1]
        shape[0] = <np.npy_intp> self.size
        # Create a 1D array, of length 'size'
        ndarray = np.PyArray_SimpleNewFromData(1, shape,
                                               self.data_type, self.data_ptr)
        return ndarray

    def __dealloc__(self):
        """ Frees the array. This is called by Python when all the
        references to the object are gone. """
        free(<void*>self.data_ptr)
