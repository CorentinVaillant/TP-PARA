from subprocess import run
import json

from common import *

# Makking the tests
results = []
for test in TO_TEST:
    for nbT in TO_TEST[test]:
        result = {
            "test_file" : test,
            "nbT":nbT,
            "time" : 0
        }
        command = [f"./{EXEC_NAME}", test ,str(nbT)]
        print(f"Exec : {command}, {TEST_ITERATION} times")
        for i in range(TEST_ITERATION):
            out = run(command, capture_output=True, text=True)
            out.check_returncode()
            loaded = json.loads(out.stdout)
            result["time"] += loaded["time"]
        result["time"] /= TEST_ITERATION
        results.append(result)

# Compile in one json file
parsed = {}

for r in results:
    file = r["test_file"]
    nbT = str(r["nbT"])

    if file not in parsed:
        parsed[file] = {}

    parsed[file][nbT] = {
        "time": r["time"],
    }

with open("results.json", "w") as f:
    f.write(json.dumps(parsed))

print("Done !")