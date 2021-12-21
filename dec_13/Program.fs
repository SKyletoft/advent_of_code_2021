open System;;
open System.Text;;

type Instruction =
  | X of int64
  | Y of int64

type Coord = int64 list

let parse_line (s: string) =
  s.Split ','
  |> Array.toList
  |> List.map Int64.Parse

let parse_instruction (s: string) =
  let xy ss = match ss with
    | ["x"; coord] -> X (Int64.Parse coord)
    | ["y"; coord] -> Y (Int64.Parse coord)
    | other -> X 0
  s.Split("fold along ")
    |> fun sss -> sss.[1].Split('=')
    |> Array.toList
    |> xy

let coords:Coord list =
  let rec add_line (so_far: Coord list) =
    match Console.ReadLine() with
      | "" -> so_far
      | other -> add_line (parse_line other :: so_far)
  add_line [] |> List.rev

let instructions: Instruction list =
  let rec add_line (so_far: Instruction list) =
    match Console.ReadLine() with
      | "" -> so_far
      | other -> add_line (parse_instruction other :: so_far)
  add_line [] |> List.rev

let fold_horizontal at [x; y] =
  let new_x = match x < at with
    | true -> x
    | false -> 2L * at - x
  [new_x; y]

let fold_vertical at [x; y] =
  let new_y = match y <= at with
    | true -> y
    | false -> 2L * at - y
  [x; new_y]

let fold at = match at with
  | X a -> fold_horizontal a
  | Y a -> fold_vertical a

let debug_print a =
  printfn "%A" a
  a

let render (xs: Coord list) =
  let max_x = xs |> List.map (fun x -> x.[0]) |> List.max
  let max_y = xs |> List.map (fun x -> x.[1]) |> List.max
  let render_char c = match List.exists (fun x -> x = c) xs with
    | true -> '#'
    | false -> ' '
  let hw2 chars = 
    string (List.fold (fun (sb:StringBuilder) (c:char) -> sb.Append(c)) 
                      (new StringBuilder())
                       chars)
  [ for y in 0L..max_y do
    hw2 [ for x in 0L..max_x do render_char [x;y] ]]

let part_one =
  coords
  |> List.map (fold (instructions.[0]))
  |> List.distinct
  |> List.length
printfn "%A" part_one

let part_two =
  let f:(Coord -> Instruction -> Coord) = fun a b -> fold b a
  coords
  |> List.map (fun coord -> List.fold f coord instructions)
  |> List.distinct
  |> render
let _ = List.map (printfn "%s") part_two

