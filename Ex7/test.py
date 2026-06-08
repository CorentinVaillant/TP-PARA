from subprocess import run
import json

from common import *

# Makking the tests
results = {}
for (file, clusters, nb_t) in TO_TEST:
    command = [f"./{EXEC_NAME}", file ,str(clusters), str(nb_t)]
    print(f"Exec : {command}, {TEST_ITERATION} times")
    for i in range(TEST_ITERATION):
        out = run(command, capture_output=True, text=True)
        out.check_returncode()
        print(f"\t-> {out.stdout}", end="")
        loaded = json.loads(out.stdout)
        if(str((file, clusters, nb_t)) not in results):
            results[str((file, clusters, nb_t))] = loaded["time"]
        else:
            results[str((file, clusters, nb_t))] += loaded["time"]
    results[str((file, clusters, nb_t))] /= TEST_ITERATION
        

with open("results.json", "w") as f:
    f.write(json.dumps(results))
print("Done !")