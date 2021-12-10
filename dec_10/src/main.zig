const std = @import("std");
const stdout = std.io.getStdOut().writer();
const stdin = std.io.getStdIn().reader();

// STOLEN REVERSE ITERATOR CODE
// https://zigforum.org/t/ideomatic-reverse-iteration/799/2

fn ReverseIterator(comptime Container: type) type {
    return struct {
        items: Container,
        current: usize = 0,

        pub fn next(self: *@This()) ?std.meta.Child(Container) {
            if (self.current >= self.items.len) return null;
            self.current += 1;
            return self.items[self.items.len - self.current];
        }
    };
}

fn reverse(items: anytype) ReverseIterator(@TypeOf(items)) {
    return .{ .items = items };
}

// END OF THEFT

pub fn main() anyerror!void {
    var buffer: [1024]u8 = undefined;
    var buffer_ptr: ?[]u8 = null;

    try stdout.print("Starting\n", .{});
    var score_1: u64 = 0;
    var score_2: [100]u64 = undefined;
    var score_2_idx: usize = 0;
    buffer_ptr = try stdin.readUntilDelimiterOrEof(buffer[0..], '\n');
    while (true) {
        if (buffer_ptr) |buf| {
            try handle_line(buf, &score_1, &score_2, &score_2_idx);
            buffer_ptr = try stdin.readUntilDelimiterOrEof(buffer[0..], '\n');
        } else {
            break;
        }
    } else |err| {
        switch (err) {
            error.EndOfStream => {},
            else => return err,
        }
    }
    std.sort.sort(u64, score_2[0..score_2_idx], {}, comptime std.sort.desc(u64));
    try stdout.print("{} {}\n", .{ score_1, score_2[score_2_idx / 2] });
}

pub fn handle_line(line: []u8, part1: *u64, part2: []u64, part_2_idx: *usize) anyerror!void {
    // try stdout.print("{s}\n", .{line});
    var stack: [1024]u8 = undefined;
    var idx: usize = 0;

    for (line) |character| {
        // try stdout.print("'{c}' ", .{character});
        switch (character) {
            '<', '(', '{', '[' => {
                stack[idx] = character;
                idx += 1;
            },
            '>' => {
                if (stack[idx - 1] == '<') {
                    idx -= 1;
                } else {
                    part1.* += 25137;
                    return;
                }
            },
            ')' => {
                if (stack[idx - 1] == '(') {
                    idx -= 1;
                } else {
                    part1.* += 3;
                    return;
                }
            },
            '}' => {
                if (stack[idx - 1] == '{') {
                    idx -= 1;
                } else {
                    part1.* += 1197;
                    return;
                }
            },
            ']' => {
                if (stack[idx - 1] == '[') {
                    idx -= 1;
                } else {
                    part1.* += 57;
                    return;
                }
            },
            else => {
                return;
            },
        }
    }
    // part 2
    var score: u64 = 0;
    var it = reverse(stack[0..idx]);
    while (it.next()) |n| {
        score *= 5;
        switch (n) {
            '(' => {
                score += 1;
            },
            '[' => {
                score += 2;
            },
            '{' => {
                score += 3;
            },
            '<' => {
                score += 4;
            },
            else => {},
        }
    }
    part2[part_2_idx.*] = score;
    part_2_idx.* += 1;
    return;
}
