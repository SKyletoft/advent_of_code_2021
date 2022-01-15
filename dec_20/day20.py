import sys

def parse_line(line):
	out = "["
	for letter in line.strip():
		if letter == '#':
			out += "1, "
		else:
			out += "0, "
	out = out[:-2]
	out += ']'
	return out

# algorithm
print(parse_line(sys.stdin.readline()))

# skip the empty line
sys.stdin.readline()

# image
image = "["
for line in sys.stdin:
	image += parse_line(line)
	image += ", "
image = image[:-2]
image += ']'
print(image)

