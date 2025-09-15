# Module 6 stuff
# Imports:


# Functions:
def filter_numeric(lst):
    num = []
    for x in lst:
        if type(x) == int or type(x) == float:
            num.append(x)
    return num

def mean_lst(lst):
    num = filter_numeric(lst)
    lst_mean = sum(num) / len(num)
    return lst_mean

def median_lst(lst):
    num = filter_numeric(lst)
    num.sort()
    if len(num) % 2 == 0:
        middle = [num[int((len(num) / 2) - 1)], num[int(len(num) / 2)]]
        lst_median = sum(middle) / 2
    else:
        lst_median = num[int(len(num) // 2)]
    
    return lst_median

def remove_negative(lst_numeric):
    lst_positive = []
    for x in lst_numeric:
        if x >= 0:
            lst_positive.append(x)
    
    return lst_positive

def between(lst, low, high):
    lst_between = []
    for x in lst:
        if low < x < high:
            lst_between.append(x)
    
    return lst_between

def smooth(lst):
    smooth_lst = [lst[0]]
    for i in range(1, len(lst) - 1):
        temp_avg = sum([lst[i-1], lst[i], lst[i+1]]) / 3
        smooth_lst.append(temp_avg)
    smooth_lst.append(lst[-1])
    return smooth_lst

def counter2(x, lst):
    count_x = 0
    for i in lst:
        if type(i) == list:
            count_x += i.count(x)
        elif type(i) == type(x):
            count_x += 1
    return count_x
#################################################
# my_list = ["A", 5, 6.5, 7, 8, 9, 10]
# filter_numeric(my_list)
# mean_lst(my_list)
# median_lst(my_list)
# my_list = [-1, -2, -3, 5, 6, 7, 8]
# remove_negative(my_list)
# between(my_list, -2, 7)

# my_numeric = [1, 2, 6, 4, 5, 0]
# smooth(my_numeric)

# nested_lst = [ [[1, 1]], [1, 2, 1], 1, [1, 2], 1]
# counter2(1, nested_lst)

