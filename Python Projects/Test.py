
n = int(input("Enter a number : "))
t = input("Enter a letter : ")
def sum_eo(n,t):

    even = 0
    odd = 0
    i = 1
    if t == "e":
        while i < n:
            if i % 2 == 0:
                even = even + i
            i += 1
        print(even)
    elif t == "o":
        while i < n:
            if i % 2 != 0:
                odd = odd + i
            i += 1
        print(odd)
    else:
        print(-1)

sum_eo(n, t)