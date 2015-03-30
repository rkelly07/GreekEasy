import json
import matplotlib.pyplot as plt

input_file = open("Location.json", "r")
output_file = open("Location.csv", "w")

print "Loading JSON results..."
results = json.load(input_file)["results"]
input_file.close()
print "Done. Writing results to CSV..."

colors = {0: "red", 1: "blue", 2: "green"}
for result in results:
    output_file.write("%s,%s,%s\n" % (result["latitude"], result["longitude"], colors[int(result["mode"])]))
print "Done."
output_file.close()