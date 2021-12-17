struct Position: Hashable {
	let x: Int
	let y: Int
}

func parse_line() -> [Int] {
	let err_value = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	guard let line = readLine() else { return err_value }
	if line.count != 10 {
		return err_value
	}
	var ret_val = err_value
	for (index, char) in line.enumerated() {
		guard let v = char.wholeNumberValue else { return err_value }
		ret_val[index] = v
	}

	return ret_val
}

func simulate_step(_ board: inout [[Int]]) -> Int {
	let surrounding = [
		(-1, -1), (0, -1), (1, -1),
		(-1,  0),          (1,  0),
		(-1,  1), (0,  1), (1,  1)
	]
	var visited = Set<Position>();
	var to_visit = Array<Position>();

	// Initial adds
	for y in board.indices {
		for x in board[y].indices {
			board[x][y] += 1
			if board[x][y] >= 10 {
				let position = Position(x: x, y: y)
				to_visit.append(position)
				visited.insert(position)
			}
		}
	}

	// Spill
	while !to_visit.isEmpty {
		let top = to_visit.removeFirst()
		let x = top.x
		let y = top.y
		for (dx, dy) in surrounding {
			let rx = x + dx
			let ry = y + dy
			if rx < 0 || ry < 0 || rx > 9 || ry > 9 {
				continue
			}
			board[rx][ry] += 1
			let position = Position(x: rx, y: ry)
			if board[rx][ry] >= 10 && !visited.contains(position) {
				to_visit.append(position)
				visited.insert(position)
			}
		}
	}

	// And reset overflows
	for y in board.indices {
		for x in board[y].indices {
			if board[x][y] > 9 {
				board[x][y] = 0
			}
		}
	}
	return visited.count
}

func print_board(_ board: [[Int]]) {
	for line in board {
		print(line)
	}
	print()
}

func main() {
	var lines = [
		parse_line(),
		parse_line(),
		parse_line(),
		parse_line(),
		parse_line(),
		parse_line(),
		parse_line(),
		parse_line(),
		parse_line(),
		parse_line(),
	]

	var sum = 0
	for _ in 0...99 {
		sum += simulate_step(&lines)
	}
	print(sum)

	var steps = 100
	while true {
		steps += 1
		let flashes = simulate_step(&lines)
		if flashes == 100 {
			break
		}
	}
	print(steps)
}

main()

