import json
import scipy

input_file = open("Location.json", "r")

results = json.load(input_file)["results"]
input_file.close()

mode1_results = []
mode2_results = []
mode3_results = []

for result in results:
    mode = int(result["mode"])
    if mode == 0:
        mode1_results.append(result)
    elif mode == 1:
        mode2_results.append(result)
    else:
        mode3_results.append(result)

print len(results)
print len(mode1_results)
print len(mode2_results)
print len(mode3_results)