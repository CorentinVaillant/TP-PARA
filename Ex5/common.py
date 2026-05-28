EXEC_NAME = "out.exe"

IM_PATH = "./resources/"
IMS = ["image0.ppm", "image1.ppm", "image2.ppm"]

NB_THREAD_MAX = 16

TEST_ITERATION = 100

TO_TEST = {
    im : list(range(1, NB_THREAD_MAX+1))
    for im in IMS
}

print(TO_TEST)