
even = 0
odd = 0

n, t = input('Enter the number n:'), input('Enter the letter t:')


def sum_eo(n, t):
	if t == "e":
		while i <= n:
			if i%2 == 0:
				even = i + even
	print(even)

	if  t == "o":
		while i <= n:
				if i%2 != 0:
					odd = i + odd
		print(odd)
	else :

		print(-1)

