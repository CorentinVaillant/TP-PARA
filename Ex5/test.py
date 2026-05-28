from subprocess import run
import json

from common import *

# Makking the tests
results = []
for im in TO_TEST:
    for nbT in TO_TEST[im]:
        result = {
            "image" : im,
            "nbT":nbT,
            "time" : 0
        }
        command = [f"./{EXEC_NAME}", IM_PATH+im, "out.pgm" ,str(nbT)]
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
    im = r["image"]
    nbT = str(r["nbT"])

    if im not in parsed:
        parsed[im] = {}

    parsed[im][nbT] = {
        "time": r["time"],
    }

with open("results.json", "w") as f:
    f.write(json.dumps(parsed))

print("Done !")