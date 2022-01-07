import std.stdio;
import std.algorithm;
import std.range;
import std.conv;
import std.math;

long read_player() {
	string buf;
	buf = readln();
	buf = buf[28.. $ - 1];
	return parse !(long, string)(buf) -1;
}

long die() {
	static long die = 0;
	long was        = die;
	die             = (die + 1) % 100;
	return was + 1;
}

long part_1(long p1, long p2) {
	long score_1 = 0;
	long score_2 = 0;
	long rolls   = 0;
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
}

struct Result {
	long p1;
	long p2;
}

Result part_2_rec(long p1, long score_1, long p2, long score_2, bool turn) {
	const long[7] die_sum  = [ 3, 4, 5, 6, 7, 8, 9 ];
	const long[7] die_prop = [ 1, 3, 6, 7, 6, 3, 1 ];

	Result ret = {0, 0};
	if (turn) {
		for (int i = 0; i < 7; i++) {
			long inner_p1      = (p1 + die_sum[i]) % 10;
			long inner_score_1 = score_1 + inner_p1 + 1;
			Result res;
			if (inner_score_1 >= 21) {
				res.p1 = 1;
			} else {
				res = part_2_rec(inner_p1, inner_score_1, p2, score_2, !turn);
			}
			ret.p1 += res.p1 * die_prop[i];
			ret.p2 += res.p2 * die_prop[i];
		}
	} else {
		for (int i = 0; i < 7; i++) {
			long inner_p2      = (p2 + die_sum[i]) % 10;
			long inner_score_2 = score_2 + inner_p2 + 1;
			Result res;
			if (inner_score_2 >= 21) {
				res.p2 = 1;
			} else {
				res = part_2_rec(p1, score_1, inner_p2, inner_score_2, !turn);
			}
			ret.p1 += res.p1 * die_prop[i];
			ret.p2 += res.p2 * die_prop[i];
		}
	}

	return ret;
}

long part_2(long p1, long p2) {
	auto res = part_2_rec(p1, 0, p2, 0, true);
	return max(res.p1, res.p2);
}

void main() {
	long player_1 = read_player();
	long player_2 = read_player();
	auto res_1    = part_1(player_1, player_2);
	auto res_2    = part_2(player_1, player_2);
	writefln("%d\n%d", res_1, res_2);
}
