CC=gcc
FLEX=flex
BISON=bison
flex:
	$(FLEX) tlex.l
	$(CC) lex.yy.c -lfl -o ./bin/splc
main:
	$(FLEX) lex.l
	$(BISON) -d syntax.y
	$(CC) -w syntax.tab.c AST.c -lfl -o ./bin/splc
debug:
	$(FLEX) lex.l
	$(BISON) -d -t -v syntax.y
	$(CC) syntax.tab.c AST.c -lfl -o ./bin/splc -DDEBUG
clean:
	rm -rf ./lex.yy.c ./bin/splc ./syntax.tab.c ./syntax.tab.h ./syntax.output