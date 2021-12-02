rustc input_transform.rs && ./input_transform < input > input_mod && cat day2.apl >> input_mod && apl -f input_mod; rm input_mod input_transform
