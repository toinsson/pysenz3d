import sys
sys.path.insert(1,r"C:\Users\antoi_000\Documents\dev\pysenz3d\build\lib.win32-2.7")
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

def test_close():
    cam.close()

def test_init_close_loop():
    cam.init()
    cam.close()
    cam.init()
    cam.close()
