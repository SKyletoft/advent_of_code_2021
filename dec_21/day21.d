import std.stdio;
import std.algorithm;
import std.range;
import std.conv;

uint read_player() {
	string buf;
	buf = readln();
	buf = buf[28.. $ - 1];
	return parse !(uint, string)(buf) - 1;
}

uint die() {
	static uint die = 0;
	uint was = die;
	die = (die + 1) % 100;
	return was + 1;
}

uint part_1(uint p1, uint p2) {
	uint score_1 = 0;
	uint score_2 = 0;
	uint rolls   = 0;
	bool turn    = true;

	while (true) {
		auto roll = die() + die() + die();
		rolls += 3;

		if (turn) {
			p1 = (p1 + roll) % 10;
			score_1 += p1 + 1;
		} else {
			p2 = (p2 + roll) % 10;
			score_2 += p2 + 1;
		}

		if (score_1 >= 1000) {
			return rolls * score_2;
		} else if (score_2 >= 1000) {
			return rolls * score_1;
		}

		turn = !turn;
	}

	return 0;
}

void main() {
	uint player_1 = read_player();
	uint player_2 = read_player();
	auto res_1    = part_1(player_1, player_2);
	writefln("%d\n%d", res_1, 0);
}

