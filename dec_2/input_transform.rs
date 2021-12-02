use std::io::{Read, stdin};

fn main() {
	let mut input = String::new();
	let mut stdin = stdin();
	stdin.read_to_string(&mut input).expect("STDIN read error");
	print!("lines ← (");
	for line in input.lines() {
		print!("'{}' ", line);
	}
	println!(")");
}
