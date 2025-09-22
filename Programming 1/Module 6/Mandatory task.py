# Module 6: mandatory task
# Imports:

# Functions:
def smooth_a(a, n):
    x = [lst[0]]*n + lst + [lst[-1]]*n
    a_smooth = [ sum( x[i-n:i+n+1] ) / (n*2 + 1) \
                for i in range(n, len(a)+n) ]

    return a_smooth

def smooth_b(a, n):
    b_smooth = [ sum( a[max(i-n, 0):min(i+n+1, len(a))] ) / (len(a[max(i-n, 0) : min(i+n+1, len(a))]))   \
                for i in range(len(a))]
    
    return b_smooth
#########################################

lst = [1, 2, 6, 4, 5, 0, 1, 2]

smooth_a(lst, 1)
smooth_a(lst, 2)

smooth_b(lst, 1)
smooth_b(lst, 2)
