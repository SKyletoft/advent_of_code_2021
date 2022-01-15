default:
	futhark c day20.fut
	python3 day20.py < input | ./day20

haskell:
	ghc day20.hs -prof
	python3 day20.py < test1 | ./day20
test:
	futhark c day20.fut
	python3 day20.py < test1 | ./day20

cuda:
	futhark cuda day20.fut
	python3 day20.py < input | ./day20

clean:
	-rm day20 day20.c

format:
	hindent day20.hs && stylish-haskell -i day20.hs

