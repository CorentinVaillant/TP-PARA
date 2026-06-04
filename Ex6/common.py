EXEC_NAME = "out.exe"

NB_THREAD_MAX = 16

TEST_ITERATION = 1
TEST_FILES = ["test/g1.gr", "test/rome.gr", "test/new_york.gr"]
# TEST_FILES = ["test/g1.gr", "test/rome.gr"]#, "test/new_york.gr"]


TO_TEST = {
    file: [nb_t for nb_t in range(1,NB_THREAD_MAX+1)]
    for file in TEST_FILES
}
