import json
import scipy

input_file = open("Location.json", "r")

results = json.load(input_file)["results"]
input_file.close()

total_accuracy = 0
count = 0
for result in results:
    total_accuracy += float(result["accuracy"])
    count += 1

print "Average accuracy for mode 0: %f" % (total_accuracy / count)