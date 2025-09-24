# Mandatory task 8: A
# Imports:
import csv
import tkinter as tk
from tkinter import filedialog
# import os.path
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches

# Functions:
def load_csv(fileName = None):
    # Interactively ask for a file
    if fileName == None:
        root = tk.Tk()
        root.withdraw()
        fileName = filedialog.askopenfilename()
    # Open and read file
    with open(fileName, 'r') as csvFile:
        reader = csv.reader(csvFile)
        next(reader, None) # Skip header line
        df = {row[0]:[row[1].lower(), row[2]] + [float(x) for x in row[3:]] \
                for row in reader}
    return df

# def load_csv2(fileName = None):
#     # Interactively ask for a file
#     if fileName == None:
#         root = tk.Tk()
#         root.withdraw()
#         fileName = filedialog.askopenfilename()
#     # Open and read file
#     with open(fileName, 'r') as csvFile:
#         reader = csv.reader(csvFile)
#         next(reader, None) # Skip header line
#         df = {row[1].lower():[float(x) for x in row[3:]] \
#                 for row in reader}
#     return df

def smooth_a(a, n):
    x = [a[0]]*n + a + [a[-1]]*n
    a_smooth = [ sum( x[i-n:i+n+1] ) / (n*2 + 1) \
                for i in range(n, len(a)+n) ]

    return a_smooth

def smooth_b(a, n):
    b_smooth = [ sum( a[max(i-n, 0):min(i+n+1, len(a))] ) / (len(a[max(i-n, 0):min(i+n+1, len(a))]))   \
                for i in range(len(a))]
    
    return b_smooth

##################################

# Load data
CO2_data = load_csv('Programming 1\\Module 8\\CO2Emissions_filtered.csv')

# Countries & palette
countries = ['dnk',     'fin',     'isl',     'nor',     'swe']
colors =    ["#1B9E77", "#D95F02", "#7570B3", "#E7298A", "#66A61E"]
line_type = ['dotted', 'solid', 'dashed']

# Filter & process data
CO2_filtered = {v[0]:v[2:] \
                for k, v in CO2_data.items() \
                    if v[0] in countries}
time = list(range(1960, 2015))

n = 5 # smooth over 11 years
CO2_smooth_a = {k:smooth_a(v, n) \
                for k, v in CO2_filtered.items()}

CO2_smooth_b = {k:smooth_b(v, n) \
                for k, v in CO2_filtered.items()}
df_lst = [CO2_filtered, CO2_smooth_a, CO2_smooth_b]

# Plot
fig, ax = plt.subplots()

## Lines
for i_df in range(len(df_lst)): # loop line type
    
    for j_row in range(len(CO2_filtered)): # loop color/country
        v = df_lst[i_df].values()
        # k = df_lst[i_df].keys()
        ax.plot(
            time, 
            list(v)[j_row], 
            linestyle = line_type[i_df],
            color = colors[j_row]
            # label = list(k)[j_row]
            )

## Labels & legend
country_patches = []
for i in range(len(CO2_filtered)):
    k = CO2_filtered.keys()
    country_patches.append(mpatches.Patch(color = colors[i], label = list(k)[i]))
ax.legend(
    handles = country_patches,
    loc = "upper right"
    )
ax.set(
    title = "Yearly emissions of CO2 in nordic countries",
    xlabel = "Year", 
    ylabel = "CO2 Emissions [kt]"
    )

## Show window and close plot
plt.show()
plt.close()
