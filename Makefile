CC=gcc
FLEX=flex
test:
	$(FLEX) tlex.l
	$(CC) lex.yy.c -lfl -o test.out
main:
	$(FLEX) lex.l
	$(CC) lex.yy.c -lfl -o main.out
clean:
	rm -rf ./lex.yy.c ./test.out ./main.out