struct Open end
struct Close end

const Token = Union{Open, Close, Int64}

function main()
	lines = [parse(readline())]

	line = readline()
	while line != ""
		parsed = parse(line)
		push!(lines, parsed)
		line = readline()
	end

	function part_one(acc::Array{Token}, next::Array{Token})::Array{Token}
		added = addition(acc, next)
		reduce!(added)
		added
	end

	sum = reduce(part_one, lines)

	print("$(tokens_to_string(sum))\n")
	print("$(magnitude!(sum))\n")

	function part_two((lhs, rhs)::Tuple{Array{Token}, Array{Token}})::Int64
		added = addition(lhs, rhs)
		reduce!(added)
		magnitude!(added)
	end

	pairs::Array{Tuple{Array{Token}, Array{Token}}} =
	      [(x, y) for x=lines, y=lines]
	max = maximum(map(part_two, pairs))

	print("$(max)\n")
end

function parse(line)::Array{Token}
	valid_tokens = (x) -> x != ',' && x != '\n'
	function convert(x)::Token
		if x >= '0' && x <= '9'
			return Int64(x) - Int64('0')
		elseif x == '['
			return Open()
		elseif x == ']'
			return Close()
		else
			print("Parse error: Invalid token ($(x))\n")
			return -1
		end
	end
	map(convert, filter(valid_tokens, collect(line)))
end

function tokens_to_string(tokens::Array{Token})::String
	function token_to_string(token::Token)::String
		if token == Open()
			return "["
		elseif token == Close()
			return "]"
		else
			string(Int64(token))
		end
	end
	reduce(*, map(token_to_string, tokens))
end

function addition(left::Array{Token}, right::Array{Token})::Array{Token}
	start::Array{Token} = [Open()]
	append!(start, left)
	append!(start, right)
	push!(start, Close())
	start
end

function find_number_left(arr::Array{Token}, idx)::Int64
	while idx > 1
		idx -= 1
		if !(arr[idx] == Open() || arr[idx] == Close())
			return idx
		end
	end
	-1
end

function find_number_right(arr::Array{Token}, idx)::Int64
	while idx < length(arr)
		idx += 1
		if !(arr[idx] == Open() || arr[idx] == Close())
			return idx
		end
	end
	-1
end

function explode!(arr::Array{Token}, idx::Int64)
	left_idx = find_number_left(arr, idx)
	right_idx = find_number_right(arr, idx + 1)

	if arr[idx - 1] != Open()  ||
	   arr[idx]     == Open()  ||
	   arr[idx]     == Close() ||
	   arr[idx + 1] == Open()  ||
	   arr[idx + 1] == Close() ||
	   arr[idx + 2] != Close()
	
		print("Cancelled explode\n")
		return

	end

	if left_idx != -1
		arr[left_idx] = arr[left_idx] + arr[idx]
	end
	if right_idx != -1
		arr[right_idx] = arr[right_idx] + arr[idx + 1]
	end

	arr[idx - 1] = 0
	splice!(arr, idx)
	splice!(arr, idx)
	splice!(arr, idx)

	return
end

function split!(arr::Array{Token}, idx::Int64)
	if arr[idx] == Open() || arr[idx] == Close() || arr[idx] <= 9
		return
	end

	num  = Int64(arr[idx]) / 2
	up   = Int64(ceil(num))
	down = Int64(floor(num))
	
	arr[idx] = Close()
	insert!(arr, idx, up)
	insert!(arr, idx, down)
	insert!(arr, idx, Open())

	return
end

function split_one!(statement::Array{Token})
	idx = 0
	while idx < length(statement)
		idx += 1
		if statement[idx] != Open() &&
		   statement[idx] != Close() &&
		   statement[idx] > 9
			split!(statement, idx)
			return true
		end
	end

	false
end

function explode_all!(statement::Array{Token})::Bool
	idx     = 0
	depth   = 0
	changed = false
	while idx < length(statement) - 2
		idx += 1
		if statement[idx] == Open()
			depth += 1
		elseif statement[idx] == Close()
			depth -= 1
		elseif depth > 4
			explode!(statement, idx)
			idx = 0
			depth = 0
			changed = true
		end
	end
	changed
end

function reduce!(statement::Array{Token})
	while true
		a = explode_all!(statement)
		b = split_one!(statement)

		if !(a || b)
			break
		end
	end
end

function magnitude!(arr::Array{Token}, idx::Int64)::Int64
	if length(arr) == 1
		return Int64(arr[1])
	elseif length(arr) == 3
		return Int64(arr[2])
	elseif (idx + 3) > length(arr)
		return magnitude!(arr, 1)
	elseif arr[idx] == Open() && arr[idx + 3] == Close()	
		arr[idx] = arr[idx + 1] * 3 +
		           arr[idx + 2] * 2
		splice!(arr, idx + 1)
		splice!(arr, idx + 1)
		splice!(arr, idx + 1)
		return magnitude!(arr, 1)
	else
		return magnitude!(arr, idx + 1)
	end
end

function magnitude!(arr)
	magnitude!(arr, 1)
end

main()

