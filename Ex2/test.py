from subprocess import run
import json

from common import *

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