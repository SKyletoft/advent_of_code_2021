is_forward ←     {×/('forward '=⍵[⍳((((⍴⍵)≥8)×7)  + 1)])}
is_backward ←    {×/('backward '=⍵[⍳((((⍴⍵)≥9)×8)  + 1)])}
is_up ←          {×/('up '=⍵[⍳((((⍴⍵)≥3)×2)  + 1)])}
is_down ←        {×/('down '=⍵[⍳((((⍴⍵)≥5)×4)  + 1)])}
parse_digit ←    {('0123456789'⍳⍵)-1}
parse_string ←   {{(⍵×10)+⍺}/⌽parse_digit ⍵}

⍝ Order matters because of untrustworth ifs
origo ←          (0 0)
get_backward ←   {(is_backward ⍵) × (parse_backward ⍵)}
get_forward ←    {(is_forward ⍵) ×  (parse_forward ⍵)}
get_down ←       {(is_down ⍵) ×     (parse_down ⍵)}
get_up ←         {(is_up ⍵) ×       (parse_up ⍵)}

parse_down ←     {(parse_digit (⍵[(((⍴⍵)≥6)×5)  + 1])) × (1  0)}
parse_up ←       {(parse_digit (⍵[(((⍴⍵)≥4)×3)  + 1])) × (-1 0)}
parse_backward ← {(parse_digit (⍵[(((⍴⍵)≥10)×9) + 1])) × (0 (-1))}
parse_forward ←  {(parse_digit (⍵[(((⍴⍵)≥9)×8)  + 1])) × (0  1)}

parse_line ← {(get_up ⍵) + (get_down ⍵) + (get_backward ⍵) + (get_forward ⍵)}

⍝ test_line ← {( (((⍴⍵)≥9)×9) (((⍴⍵)≥10)×10) (((⍴⍵)≥4)×4) (((⍴⍵)≥6)×6) )}

⍝ lines ← ('up 5' 'forward 3' 'backward 2' 'down 7')
coords←⊃(+/(parse_line ¨ lines))
coords[1]×coords[2]

)OFF

