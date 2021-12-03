index_op ← {(((⍴⍵) ≥ ⍺) × (⍺ - 1)) + 1}

is_forward ←     {×/('forward '  =⍵[⍳(8 index_op ⍵)])}
is_backward ←    {×/('backward ' =⍵[⍳(9 index_op ⍵)])}
is_up ←          {×/('up '       =⍵[⍳(3 index_op ⍵)])}
is_down ←        {×/('down '     =⍵[⍳(5 index_op ⍵)])}
parse_digit ←    {('0123456789' ⍳ ⍵) - 1}
parse_string ←   {{(⍵ × 10) + ⍺} / ⌽ parse_digit ⍵}

⍝ Because bounds checking doesn't seem to work
get_backward ←   {(is_backward ⍵) × (parse_backward ⍵)}
get_forward ←    {(is_forward ⍵) ×  (parse_forward ⍵)}
get_down ←       {(is_down ⍵) ×     (parse_down ⍵)}
get_up ←         {(is_up ⍵) ×       (parse_up ⍵)}

parse_down ←     {(parse_digit (⍵[ 6 index_op ⍵])) × (  1   0 )}
parse_up ←       {(parse_digit (⍵[ 4 index_op ⍵])) × ((-1)  0 )}
parse_backward ← {(parse_digit (⍵[10 index_op ⍵])) × (  0 (-1))}
parse_forward ←  {(parse_digit (⍵[ 9 index_op ⍵])) × (  0   1 )}

parse_line ← {(get_up ⍵) + (get_down ⍵) + (get_backward ⍵) + (get_forward ⍵)}

parsed_lines ← parse_line ¨ lines
⊃parsed_lines
parsed_lines_3 ← {( ⍵[2] ⍵[1] 0 )} ¨ parsed_lines

coords ← ⊃( + / parsed_lines )
coords[1] × coords[2]

part_2 ← { ⍺ + ( ⍵[1] ⍵[2] (⍵[1] × ⍺[2]) ) }

⍝ w ← ⊃parsed_lines_3[1]
⍝ w ← w part_2 (⊃parsed_lines_3[2])
⍝ w ← w part_2 (⊃parsed_lines_3[3])
⍝ w ← w part_2 (⊃parsed_lines_3[4])
⍝ w ← w part_2 (⊃parsed_lines_3[5])
⍝ w ← w part_2 (⊃parsed_lines_3[6])
⍝ w ← w part_2 (⊃parsed_lines_3[7])
⍝ w

⍝ This does somehow not do the same thing as the repeated assignments above because of course not
⍝ ⊃parsed_lines_3
⊃(part_2\parsed_lines_3)

⍝ coords_2 ← ⊃(part_2 \ ⍉parsed_lines_3 )
⍝ coords_2
⍝ coords_2[1] × coords_2[3]

)OFF
