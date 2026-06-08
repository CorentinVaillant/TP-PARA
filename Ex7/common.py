EXEC_NAME = "out.exe"

NB_THREAD_MAX = 16
TEST_NBT = list(range(1,NB_THREAD_MAX+1))

TEST_ITERATION = 10
TEST_FILES = [
    "./test/datasets/dataset_10000_4.txt",
    "./test/datasets/dataset_50000_4.txt",
    "./test/datasets/dataset_100000_4.txt",
    "./test/datasets/dataset_200000_4.txt",
    "./test/datasets/dataset_400000_4.txt",
    "./test/datasets/dataset_500000_4.txt",
    "./test/datasets/dataset_600000_4.txt",
    "./test/datasets/dataset_800000_4.txt",
    "./test/datasets/dataset_1000000_4.txt",
 ]

TEST_CLUSTER_NUM = [
    2,
    4,
    6,
    8,
    10,
]


TO_TEST = []

for file in TEST_FILES:
    for cluster in TEST_CLUSTER_NUM:
        for nb_t in TEST_NBT:
            TO_TEST.append((file, cluster, nb_t))