import scala.collection.mutable.Map
import scala.io.StdIn

class Node(val name: String, var links: Array[Node], val is_big: Boolean)

object Day12 {
	def main(args: Array[String]) = {
		val input    = parse_input()
		val result_1 = part_1(input)
		val result_2 = part_2(input)

		println(result_1)
		println(result_2)
	}

	def parse_input(): Node = {
		var nodes: Map[String, Node] = Map()

		def get_or_add(from: String): Node = {
			nodes get from match {
				case Some(n) => n
				case None    => {
					val new_node = new Node(from, Array(), from(0).isUpper)
					nodes       += (from -> new_node)
					new_node
				}
			}
		}

		var line = StdIn.readLine()
		while (line != null) {
			val words       = line.split('-')
			var from_node   = get_or_add(words(0))
			var to_node     = get_or_add(words(1))
			from_node.links = from_node.links :+ to_node
			to_node.links   = to_node.links :+ from_node
			line            = StdIn.readLine()
		}

		nodes("start")
	}

	def part_1(start: Node): Int = {
		def find_paths(at: Node, visited: Set[Node]): Int = {
			at.name match {
				case "end" => 1
				case _     => at
					.links
					.filter(n => !visited.contains(n))
					.map(n => {
						val new_visited = if (n.is_big) {
							visited
						} else {
							visited + n
						}
						find_paths(n, new_visited)
					})
					.sum
			}
		}

		find_paths(start, Set(start))
	}

	def part_2(start: Node): Int = {
		def find_paths(at: Node, visited: Set[Node], have_visited: Boolean): Int = {
			at.name match {
				case "end" => 1
				case _     => {
					val without_return = at
						.links
						.filter(n => !visited.contains(n))
						.map(n => {
							val new_visited = if (n.is_big) {
								visited
							} else {
								visited + n
							}
							find_paths(n, new_visited, have_visited)
						})
						.sum
					val with_return = if (have_visited) { 0 } else {
						at
							.links
							.filter(n => visited.contains(n) && n.name != "start")
							.map(n => {
								val new_visited = if (n.is_big) {
									visited
								} else {
									visited + n
								}
								find_paths(n, new_visited, true)
							})
							.sum
					}
					without_return + with_return
				}
			}
		}

		find_paths(start, Set(start), false)
	}
}

