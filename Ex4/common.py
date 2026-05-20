EXEC_NAME = "out.exe"

PB_PATHS = ["./pb/pb1.pb","./pb/pb2.pb", "./pb/pb6.pb"]

NB_THREAD_MAX = 16

TEST_ITERATION = 100

TO_TEST = {
    pb_path : list(range(1, NB_THREAD_MAX+1))
    for pb_path in PB_PATHS
}