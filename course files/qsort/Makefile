all: qsort

qsort: qsort.o
	ld $^ -o $@

%.o: %.asm
	as $^ -o $@
