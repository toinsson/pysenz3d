import logging
import matplotlib.pyplot as plt
from matplotlib import animation
import numpy as np
from multiprocessing import Process, Queue

# import os
# cwd = os.getcwd()
# os.chdir(r"C:\Users\antoi_000\Documents\dev\pysenz3d\build\lib.win32-2.7")
# import pysenz3d
# os.chdir(cwd)

import pysenz3d

cam = pysenz3d.PySenz3d(pysenz3d.Senz3dMode.COLOR_VGA)

def example1():
    """print one picture to screen."""
    s = cam.get_picture_size()
    p = cam.get_picture()
    p1 = p.reshape(s[::-1])
    plt.imshow(p1)
    plt.show()

def example2():
    """print the video stream to screen."""
    fig = plt.figure()
    ax = fig.add_subplot(111)

    s = cam.get_picture_size()
    a = cam.get_picture()
    b = a.reshape(s[::-1])
    im = ax.imshow(b)

    def handle_close(event):

        pass
    fig.canvas.mpl_connect('close_event', handle_close)
        
    def update_img(n):
        a = cam.get_picture()
        b = a.reshape(s[::-1])
        im.set_data(b)
        return im

    ani = animation.FuncAnimation(fig, update_img, 1, interval=30)
    plt.show()

class DataCapture(Process):
    def __init__(self, queue):
        super(DataCapture, self).__init__()
        self.queue = queue
        self.obj = pysenz3d.PySenz3d(pysenz3d.Senz3dMode.COLOR_WXGA)

    def run(self):
        self.obj.init()
        data = self.obj.get_picture_size()
        self.queue.put(data)
        data = self.obj.get_picture()
        self.queue.put(data)

def example3():
    """print the video stream to screen with dedicated process."""
    q = Queue()
    p = DataCapture(q)
    p.start()
    s = q.get()    # prints "[42, None, 'hello']"
    a = q.get()
    b = a.reshape(s[::-1])
    plt.imshow(b)
    plt.show()
    p.join()

if __name__ == '__main__':
    cam.init()
    example1()
    try:
        example2()
    except AttributeError:
        pass
    cam.close()
    
    example3()
