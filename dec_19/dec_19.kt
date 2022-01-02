
val MATCH_LIMIT = 12

data class Vector(val x: Int, val y: Int, val z: Int) {
	operator fun plus(rhs: Vector) =
		Vector(x + rhs.x, y + rhs.y, z + rhs.z)

	operator fun minus(rhs: Vector) =
		Vector(x - rhs.x, y - rhs.y, z - rhs.z)

	operator fun times(rhs: Vector) =
		Vector(x * rhs.x, y * rhs.y, z * rhs.z)
}
	
fun manhattan(v: Vector): Int {
	return kotlin.math.abs(v.x) + kotlin.math.abs(v.y) + kotlin.math.abs(v.z)
}

fun parse_line(line: String): Vector {
	val split = line.split(',').map{x -> x.toInt()}
	return Vector(split[0], split[1], split[2])
}

fun parse_input(): List<Set<Vector>> {
	var inputs: MutableList<Set<Vector>> = mutableListOf()
	var current_node: MutableSet<Vector> = mutableSetOf()

	readLine()
	for (line in generateSequence { readLine() }) {
		if (line.isEmpty()) {
			continue
		} else if (line.startsWith("--- scanner ")) {
			inputs.add(current_node)
			current_node = mutableSetOf()
		} else {
			val vector = parse_line(line)
			current_node.add(vector)
		}
	}
	inputs.add(current_node)

	return inputs
}

fun rotate(v: Vector, variation: Int): Vector {
	val x = v.x
	val y = v.y
	val z = v.z
	return when (variation) {
		0  -> Vector( x,  y,  z)
		1  -> Vector( y,  z,  x)
		2  -> Vector( z,  x,  y)
		3  -> Vector( x,  z, -y)
		4  -> Vector( y,  x, -z)
		5  -> Vector( z,  y, -x)
		6  -> Vector( x, -z,  y)
		7  -> Vector( y, -x,  z)
		8  -> Vector( z, -y,  x)
		9  -> Vector( x, -y, -z)
		10 -> Vector( y, -z, -x)
		11 -> Vector( z, -x, -y)
		12 -> Vector(-x,  z,  y)
		13 -> Vector(-y,  x,  z)
		14 -> Vector(-z,  y,  x)
		15 -> Vector(-x,  y, -z)
		16 -> Vector(-y,  z, -x)
		17 -> Vector(-z,  x, -y)
		18 -> Vector(-x, -y,  z)
		19 -> Vector(-y, -z,  x)
		20 -> Vector(-z, -x,  y)
		21 -> Vector(-x, -z, -y)
		22 -> Vector(-y, -x, -z)
		23 -> Vector(-z, -y, -x)
		else -> v
	}
}

fun matches(
	lhs:     Set<Vector>,
	rhs:     Set<Vector>,
	sensors: MutableSet<Vector>
): Set<Vector>? {
	for (rotation_index in 0..23) {
		val rotated = rhs.map {v -> rotate(v, rotation_index)}
		for (cmp_node in rotated) {
			for (base_node in lhs) {
				val diff = base_node - cmp_node
				val translated = rotated.map {v -> v + diff}.toSet()

				val shared = translated.intersect(lhs).size
				check(shared >= 1)
				if (shared >= MATCH_LIMIT) {
					sensors.add(diff)
					return translated
				}
			}
		}
	}

	return null
}

fun part_one(input: MutableList<Set<Vector>>, sensors: MutableSet<Vector>): Int {
	var connected: MutableSet<Set<Vector>> = mutableSetOf(input[0])
	var nodes: MutableSet<Vector> = input[0].toMutableSet()
	var tested: MutableSet<Pair<Set<Vector>, Set<Vector>>> = mutableSetOf()
	input.removeAt(0)

	outer@while (input.isNotEmpty()) {
		for (searching_set in input) {
			inner@for (placed_set in connected) {
				val pair = Pair(searching_set, placed_set)
				if (tested.contains(pair)) {
					continue
				}
				tested.add(pair)
				val intersection = matches(placed_set, searching_set, sensors)
				if (intersection == null) {
					continue@inner
				}

				connected.add(intersection)
				nodes.addAll(intersection)
				input.remove(searching_set)
				continue@outer
			}
		}

		println("Did nothing")
		break
	}

	return nodes.size
}

fun part_two(sensors: Set<Vector>): Int {
	var distances: MutableSet<Int> = mutableSetOf()

	for (lhs in sensors) {
		for (rhs in sensors) {
			distances.add(manhattan(
				rhs - lhs
			))
		}
	}

	val res = distances.maxOrNull()
	if (res == null) {
		return 0
	}
	return res
}

fun main() {
	val input = parse_input()
	var sensors: MutableSet<Vector> = mutableSetOf()

	val result_one = part_one(input.toMutableList(), sensors)
	val result_two = part_two(sensors)
	println("$result_one, $result_two")
}

