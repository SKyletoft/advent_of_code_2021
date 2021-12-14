import sys
import more_itertools

class memoise(dict):
	def __init__(self, func):
		self.func = func

	def __call__(self, *args):
		return self[args]

	def __missing__(self, key):
		result = self[key] = self.func(*key)
		return result

conversion = {}

@memoise
def expand_single(left, right):
	return conversion[(left, right)]

def merge(left, right):
	copy = dict(left)
	for (key, value) in right.items():
		copy[key] = (left.get(key) or 0) + value
	return copy

@memoise
def expand_generation(left, right, depth):
	middle = expand_single(left, right)

	if depth == 0:
		return merge({left: 1}, {middle: 1})

	left_res = dict(expand_generation(left, middle, depth - 1))
	right_res = dict(expand_generation(middle, right, depth - 1))
	res = merge(left_res, right_res)
	return res

def main():
	input_string = sys.stdin.readline().strip()
	sys.stdin.readline()
	
	for line in sys.stdin:
		parts = line.split(" -> ")
		conversion[(parts[0][0], parts[0][1])] = parts[1][0]

	so_far = {}
	for (left, right) in more_itertools.windowed(input_string, 2):
		res = dict(expand_generation(left, right, 9))
		so_far = merge(so_far, res)
	so_far = merge(so_far, {input_string[-1]: 1})

	print(max(so_far.values()) - min(so_far.values()))

	so_far = {}
	for (left, right) in more_itertools.windowed(input_string, 2):
		res = dict(expand_generation(left, right, 39))
		so_far = merge(so_far, res)
	so_far = merge(so_far, {input_string[-1]: 1})

	print(max(so_far.values()) - min(so_far.values()))

if __name__ == "__main__":
	main()

