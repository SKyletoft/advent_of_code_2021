import std/sequtils
import std/sugar
import strutils as str

type
  range = tuple
    min: int
    max: int

func between(r: range, v: int): bool =
  v >= r.min and v <= r.max

func parse(s: string): range =
  let
    cut = s[2..s.len - 1]
    nums = cut.split("..")
  (min: nums[0].parseInt(), max: nums[1].parseInt())

func valid_x(dx: int, rx: range): bool =
  var
    x = 0
    dx = dx
  while dx >= 0:
    if between(rx, x):
      return true
    x += dx
    dx -= 1
  false

func valid_y(dy: int, ry: range): bool =
  var
    y = 0
    dy = dy
  while y >= ry.min:
    if between(ry, y):
      return true
    y += dy
    dy -= 1
  false

func valid_together(dx: int, dy: int, rx: range, ry: range): bool =
  var
    x = 0
    y = 0
    dx = dx
    dy = dy
  while y >= ry.min:
    if between(ry, y) and between(rx, x):
      return true
    x += dx
    y += dy
    dx =
      if dx == 0:
        0
      else:
        dx - 1
    dy -= 1
  false

func max_height(dy: int): int =
  var
    y = 0
    dy = dy
    last_y = -1
  while y > last_y:
    last_y = y
    y += dy
    dy -= 1
  last_y

func solve_1(x: range, y: range): int =
  toSeq(-1000..1000)
    .filterIt(valid_y(it, y))
    .mapIt(max_height(it))
    .max()

proc solve_2(x: range, y: range): int =
  let
    dx = toSeq(1..x.max).filterIt(valid_x(it, x))
    dy = toSeq(-1000..1000).filterIt(valid_y(it, y))
    candidates = collect:
      for cx in dx:
        for cy in dy:
          if valid_together(cx, cy, x, y):
            (cx, cy)
  candidates.len()

var
  input = readLine(stdin)
str.removePrefix(input, "target area: ")

let
  xy = input.split(", ")
  x = parse(xy[0])
  y = parse(xy[1])
  res_1 = solve_1(x, y)
  res_2 = solve_2(x, y)

echo x
echo y
echo res_1
echo res_2
