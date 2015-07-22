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


cdef extern from "senz3d.h" namespace "senz3d":
    cdef cppclass Senz3d:
        Senz3d() except +

        int width, height
        void getPictureSize(int* width, int* height)
        unsigned int* getPicture()

cdef class PySenz3d:
    """Senz3d class for rectangular shenanigans"""
    cdef Senz3d* senz3d      # hold a C++ instance which we're wrapping

    def __cinit__(self):
        self.senz3d = new Senz3d()

    def __dealloc__(self):
        del self.senz3d

    def getPictureSize(self):
        cdef int width, height

        self.senz3d.getPictureSize(&width, &height)
        return (width, height)

    def getPicture(self):

        cdef unsigned int* array
        cdef np.ndarray ndarray

        cdef int size = self.senz3d.width*self.senz3d.height
        array = self.senz3d.getPicture()

        array_wrapper = ArrayWrapper()
        array_wrapper.set_data(size, <void*> array) 

        ndarray = np.array(array_wrapper, copy=False)
        # Assign our object to the 'base' of the ndarray object
        ndarray.base = <PyObject*> array_wrapper
        # Increment the reference count, as the above assignement was done in
        # C, and Python does not know that there is this additional reference
        Py_INCREF(array_wrapper)
        
        return ndarray

cdef class ArrayWrapper:
    cdef void* data_ptr
    cdef int size

    cdef set_data(self, int size, void* data_ptr):
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
        self.size = size

    def __array__(self):
        """ Here we use the __array__ method, that is called when numpy
            tries to get an array from the object."""
        cdef np.npy_intp shape[1]
        shape[0] = <np.npy_intp> self.size
        # Create a 1D array, of length 'size'
        ndarray = np.PyArray_SimpleNewFromData(1, shape,
                                               np.NPY_INT, self.data_ptr)
        return ndarray

    def __dealloc__(self):
        """ Frees the array. This is called by Python when all the
        references to the object are gone. """
        free(<void*>self.data_ptr)

