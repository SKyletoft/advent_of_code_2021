program day5;
uses sysutils;
var
	read_line: string;
	grid_size: integer = 1000;
	grid: array [0 .. 1000] of array [0 .. 1000] of integer;
	x: integer;
	y: integer;
	x1: integer;
	y1: integer;
	x2: integer;
	y2: integer;
	tmp: integer;

function is_digit(c: char): boolean;
begin
	is_digit := (c >= '0') and (c <= '9')
end;

function parse_number(): integer;
var
	acc: integer = 0;
begin
	while (is_digit(read_line[1]) and (byte(read_line[0]) > 0)) do
	begin
		acc := acc * 10;
		acc := acc + integer(read_line[1]);
		acc := acc - integer('0');
		read_line := RightStr(read_line, byte(read_line[0]) - 1);
	end;
	parse_number := acc
end;

procedure read_input_line();
begin
	readln(read_line);
	x1 := parse_number();
	read_line := RightStr(read_line, byte(read_line[0]) - 1);
	y1 := parse_number();
	read_line := RightStr(read_line, byte(read_line[0]) - 4);
	x2 := parse_number();
	read_line := RightStr(read_line, byte(read_line[0]) - 1);
	y2 := parse_number();
end;

procedure print_state();
begin
	tmp := 0;
	for y := 0 to grid_size do
	begin
		for x := 0 to grid_size do
		begin
			if grid[x][y] = 0 then
				write('. ')
			else
				write(grid[x][y], ' ');
			if grid[x][y] >= 2 then
				tmp := tmp + 1;
		end;
		writeln();
	end;
	writeln(tmp);
end;

procedure handle_horizontal();
begin
	if (x2 < x1) then
	begin
		tmp := x1;
		x1 := x2;
		x2 := tmp;
	end;
	for x := x1 to x2 do
		grid[x][y1] := grid[x][y1] + 1;
end;

procedure handle_vertical();
begin
	if (y2 < y1) then
	begin
		tmp := y1;
		y1 := y2;
		y2 := tmp;
	end;
	for y := y1 to y2 do
		grid[x1][y] := grid[x1][y] + 1;
end;

procedure handle_diagonal();
var
	i: integer;
begin
	if (x2 < x1) and (y2 < y1) then
	begin
		tmp := x1;
		x1 := x2;
		x2 := tmp;

		tmp := y1;
		y1 := y2;
		y2 := tmp;
	end;
	if (x1 < x2) and (y1 < y2) then
	begin
		for i := 0 to (x2-x1) do
			grid[x1 + i][y1 + i] := grid[x1 + i][y1 + i] + 1;
	end
	else
	begin
		if (x1 > x2) then
		begin
			tmp := x1;
			x1 := x2;
			x2 := tmp;

			tmp := y1;
			y1 := y2;
			y2 := tmp;
		end;
		for i := 0 to (x2-x1) do
		begin
			grid[x1 + i][y1 - i] := grid[x1 + i][y1 - i] + 1;
		end;
	end;
end;

begin
	for x := 0 to grid_size do
	begin
		for y := 0 to grid_size do
		begin
			if grid[x][y] > 0 then
				tmp := 0;
		end;
	end;
	read_input_line();
	while (not ((x1 = 0) and (y1 = 0) and (x2 = 0) and (y2 = 0))) do
	begin
		if (x1 = x2) then
			handle_vertical()
		else if (y1 = y2) then
			handle_horizontal()
		else begin
			writeln(x1, ' ', y1, ', ', x2, ' ', y2);
			handle_diagonal();
		end;
		read_input_line();
	end;
	print_state();
end.

