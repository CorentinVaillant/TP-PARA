from subprocess import run
import json

from common import *

# Makking the tests
results = []
for pb in TO_TEST:
    for nbT in TO_TEST[pb]:
        result = {
            "pb" : pb,
            "nbT":nbT,
            "maxUtility" : 0,
            "time" : 0
        }
        command = [f"./{EXEC_NAME}", pb, str(nbT)]
        print(f"Exec : {command}, {TEST_ITERATION} times")
        for i in range(TEST_ITERATION):
            out = run(command, capture_output=True, text=True)
            out.check_returncode()
            loaded = json.loads(out.stdout)
            result["maxUtility"] = loaded["maxUtility"]
            result["time"] += loaded["time"]
        result["time"] /= TEST_ITERATION
        results.append(result)
        


# Compile in one json file
parsed = {}

for r in results:
    pb = r["pb"]
    nbT = str(r["nbT"])

    if pb not in parsed:
        parsed[pb] = {}

    parsed[pb][nbT] = {
        "time": r["time"],
        "maxUtility": r["maxUtility"]
    }

with open("results.json", "w") as f:
    f.write(json.dumps(parsed, indent=2))

print("Done !")