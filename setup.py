# from distutils.core import setup, Extension
# from Cython.Build import cythonize

from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import numpy


# local path to include resources
intelPCSDK = r"C:\Program Files (x86)\Intel\PCSDK"
visualStudio = r"C:\Program Files (x86)\Microsoft Visual Studio 9.0"
pxcupipeline = r"C:\Users\antoi_000\Documents\dev\senz3d\pxcupipeline"

extensions = [
    Extension("pysenz3d", 
    	sources = ["pysenz3d.pyx", "senz3d.cpp"],
        include_dirs = [
        				visualStudio+r"\VC\include",
    					intelPCSDK+r"\sample\common\include",
        				intelPCSDK+r"\include",
        				pxcupipeline+r"\include",
                        numpy.get_include(),
        				],
        libraries = ['libpxcupipeline_d'],
        library_dirs = ['.\include'],
        language="c++",
        ),
]

setup(
    name = "pysenz3d",
    ext_modules = cythonize(extensions),
)
