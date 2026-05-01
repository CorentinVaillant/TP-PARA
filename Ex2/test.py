from subprocess import run
import json

EXEC_NAME = "out.exe"

METHOD_SEQUENTIAL = 0
METHOD_SIMPLEREDUC = 1
METHOD_ATOMICREDUC = 2
METHOD_OPTIREDUC = 3

METHODS = [METHOD_SEQUENTIAL, METHOD_SIMPLEREDUC, METHOD_ATOMICREDUC, METHOD_OPTIREDUC]

TEST_SIZE = [1_000 * k for k in range(1,31)]

NB_THREAD_MAX = 8

TO_TEST = {
    METHOD_SEQUENTIAL: [1],
    METHOD_SIMPLEREDUC: list(range(2, NB_THREAD_MAX + 1)),
    METHOD_ATOMICREDUC: list(range(2, NB_THREAD_MAX + 1)),
    METHOD_OPTIREDUC: list(range(2, NB_THREAD_MAX + 1)),
}

# Makking the tests

results = []
for size in TEST_SIZE:
    for method, nbTs in TO_TEST.items():
        for nbT in nbTs:
            command = [f"./{EXEC_NAME}", str(method), str(nbT), str(size)]
            print(f"Exec : {command}")
            out = run(command, capture_output=True, text=True)
            out.check_returncode()
            results.append(json.loads(out.stdout))


# Parsing results
parsed = {
    M: [
        {
            "name": result["name"],
            "nbT": result["nbT"],
            "size": result["size"],
            "time": result["time"],
        }
        for result in filter(lambda r: r["method"] == M, results)
    ]
    for M in METHODS
}

with open("results.json", "w") as f:
    f.write(json.dumps(parsed, indent=2))

print("Done !")