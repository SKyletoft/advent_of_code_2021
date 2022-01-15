
let sum = reduce (+) 0i32

let square_sum (grid: [][]i32): i32 =
	sum (map sum grid)

let expand_2 't n (value: t) (line: []t): [n]t =
	[value, value] ++ line ++ [value, value] :> [n]t

let expand 't n (value: t) (line: []t): [n]t =
	[value] ++ line ++ [value] :> [n]t

let indicies (x: i64) (y: i64): [9](i64, i64) =
	let f (a: i64): [3]i64 = [a + 1, a, a - 1]
	let x' = flatten <| map (replicate 3) <| f x :> [9]i64
	let y' = flatten <| replicate 3 <| f y       :> [9]i64
	in zip x' y'

let apply_alg (image: [][]i32) (alg: []i32) (x: i64) (y: i64): i32 =
	let idx = reduce (\i j -> (i << 1) + j) 0 <|
		map (\(x, y) -> image[x, y]) <|
		indicies x y
	in alg[idx]

let run [m] [n] (alg: []i32) (image: [m][m]i32): [n][n]i32 =
	let o = m + 2
	let p = m + 4
	let expanded_h = map (expand_2 p 0) image   :> [m][p]i32
	let line = replicate p 0                    :> [p]i32
	let expanded_v = expand_2 p line expanded_h :> [p][p]i32
	let xs = (1 ... o)                          :> [o]i64
	let f' = apply_alg expanded_v alg
	in map (\i -> map (f' i) xs) xs             :> [n][n]i32

let main (alg: []i32) (image: [5][5]i32): i32 =
	let a = run alg image :> [7][7]i32
	let b = run alg a     :> [9][9]i32
	in square_sum b

