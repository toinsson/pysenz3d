from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
import numpy


# local path to include resources
intelPCSDK = r"C:\Program Files (x86)\Intel\PCSDK"
pxcupipeline = r"\framework\common\pxcupipeline"

extensions = [
    Extension("pysenz3d", 
        sources = ["pysenz3d.pyx", "senz3d.cpp"],
        include_dirs = [
                        intelPCSDK+r"\include",
                        intelPCSDK+pxcupipeline+r"\include",
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
