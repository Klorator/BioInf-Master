# Module 8: Data management
# Imports:
import csv

# Functions:

##############################

# read csv
with open('Programming 1\\Module 8\\people.csv', 'r') as csvFile:
    reader = csv.reader(csvFile)
    for row in reader:
        print(row)

