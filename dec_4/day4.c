#include <stdio.h>

#include "llvm_types.h"

typedef struct {
	i32 board[25];
	bool opened[25];
} BingoBoard;

i32 read_number(char **str) {
	i32 val = 0;
	while (**str >= '0' && **str <= '9') {
		val *= 10;
		val += **str - '0';
		(*str)++;
	}
	return val;
}

void skip_whitespace(char **str) {
	while (**str == ' ' || **str == '\t' || **str == '\n') {
		(*str)++;
	}
}

void read_bingo_line(i32 bingo_line[], i32 *bingo_index) {
	char input[500];
	char *read_at = input;
	scanf("%s", input);
	while (*read_at) {
		bingo_line[(*bingo_index)++] = read_number(&read_at);
		read_at++;
	}
}

BingoBoard read_bingo_board() {
	BingoBoard board = {.opened = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	                               0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}};
	for (i32 y = 0; y < 5; y++) {
		scanf("%d %d %d %d %d", &board.board[y * 5], &board.board[y * 5 + 1],
		      &board.board[y * 5 + 2], &board.board[y * 5 + 3],
		      &board.board[y * 5 + 4]);
	}
	return board;
}

void read_all_boards(BingoBoard boards[500], i32 *index) {
	while (!feof(stdin)) {
		boards[(*index)++] = read_bingo_board();
	}
}

void play_number(BingoBoard *board, i32 number) {
	for (i32 i = 0; i < 25; i++) {
		if (board->board[i] == number) {
			board->opened[i] = true;
			break;
		}
	}
}

bool check_win(BingoBoard *board) {
	i32 win_patterns[10][5] = {
	    {0, 1, 2, 3, 4},      {5, 6, 7, 8, 9},      {10, 11, 12, 13, 14},
	    {15, 16, 17, 18, 19}, {20, 21, 22, 23, 24},

	    {0, 5, 10, 15, 20},   {1, 6, 11, 16, 21},   {2, 7, 12, 17, 22},
	    {3, 8, 13, 18, 23},   {4, 9, 14, 19, 24}

	    //,   {0, 6, 12, 18, 24},   {4, 8, 12, 16, 20}
	};
	for (i32 i = 0; i < 10; i++) {
		bool win = true;
		for (i32 j = 0; j < 5; j++) {
			win &= board->opened[win_patterns[i][j]];
		}
		if (win) {
			return true;
		}
	}
	return false;
}

void destroy_board(BingoBoard *board) {
	*board =
	    (BingoBoard){.board = {
	                     -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
	                     -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
	                 }};
}

int main() {
	i32 bingo_line[500];
	i32 line_index = 0;
	BingoBoard bingo_boards[50];
	i32 board_index = 0;

	read_bingo_line(bingo_line, &line_index);
	read_all_boards(bingo_boards, &board_index);

	// ------------------- PART 1 -------------------------------------

	BingoBoard *winner = NULL;
	i32 last_number    = 0;
	i32 sum            = 0;
	for (i32 i = 0; i < line_index; i++) {
		for (i32 j = 0; j < board_index; j++) {
			play_number(&bingo_boards[j], bingo_line[i]);
			if (check_win(&bingo_boards[j])) {
				winner      = &bingo_boards[j];
				last_number = bingo_line[i];
				goto end_outer; // break outer
			}
		}
	}
end_outer:
	if (winner) {
		for (i32 i = 0; i < 25; i++) {
			if (!winner->opened[i]) {
				sum += winner->board[i];
			}
		}
		printf("1: %d * %d = %d\n", last_number, sum, last_number * sum);
	}

	// ------------------- PART 2 -------------------------------------

	winner          = NULL;
	last_number     = 0;
	sum             = 0;
	i32 boards_done = 0;
	for (i32 i = 0; i < line_index; i++) {
		for (i32 j = 0; j < board_index; j++) {
			play_number(&bingo_boards[j], bingo_line[i]);
			if (check_win(&bingo_boards[j])) {
				if (boards_done != board_index - 2) {
					boards_done++;
					destroy_board(&bingo_boards[j]);
					continue;
				}
				winner      = &bingo_boards[j];
				last_number = bingo_line[i];
				goto end_outer_2; // break outer
			}
		}
	}
end_outer_2:
	if (winner) {
		for (i32 i = 0; i < 25; i++) {
			if (!winner->opened[i]) {
				sum += winner->board[i];
			}
		}
		printf("2: %d * %d = %d\n", last_number, sum, last_number * sum);
	}
}
