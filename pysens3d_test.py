import numpy as np
from pysenz3d import PySenz3d, Senz3dMode

cam = PySenz3d()

def test_init():
    assert cam.init()

def test_get_picture_size():
    size = cam.get_picture_size()
    assert size == (640, 480)

def test_get_picture():
    size = cam.get_picture_size()
    pic = cam.get_picture()
    picShaped = pic.reshape(size[::-1])
    pass

def test_pickle():
    import pickle
    pickle.dumps(cam)
    pass