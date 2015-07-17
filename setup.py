# from distutils.core import setup, Extension
# from Cython.Build import cythonize


from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize


extensions = [
    Extension("rect", 
    	sources = ["rect.pyx", "Rectangle.cpp"],
        include_dirs = [
        				r"C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\include",
    					r"C:\Program Files (x86)\Intel\PCSDK\sample\common\include",
        				r"C:\Program Files (x86)\Intel\PCSDK\include",
        				r"C:\Users\antoi_000\Documents\dev\senz3d\pxcupipeline\include",
        				],
        libraries = ['libpxcupipeline_d'],
        library_dirs = ['.\include'],
        language="c++",
        ),
    # # Everything but primes.pyx is included here.
    # Extension("*", ["*.pyx"],
    #     include_dirs = [...],
    #     libraries = [...],
    #     library_dirs = [...]),
]

# include_path=[r"C:\Users\antoi_000\Documents\dev\senz3d\pxcupipeline\include"],


setup(
    name = "My hello app",
    ext_modules = cythonize(extensions),
)

# setup(ext_modules = cythonize(Extension(
#            "rect",                                # the extesion name
#            sources=["rect.pyx", "Rectangle.cpp"], # the Cython source and
#                                                   # additional C++ source files
#            language="c++",                        # generate and compile C++ code
#       )))