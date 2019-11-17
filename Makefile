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
splc: lex.l syntax.y AST.c AST.h parser.c parser.h statement.h symbol.c symbol.h tools.c tools.h
	$(FLEX) lex.l
	$(BISON) -d syntax.y
	$(CC) -w syntax.tab.c AST.c symbol.c parser.c tools.c -lfl -o ./bin/splc
debug:
	$(FLEX) lex.l
	$(BISON) -d -t -v syntax.y
	$(CC) syntax.tab.c AST.c -lfl -o ./bin/splc -DDEBUG
clean:
	rm -rf ./lex.yy.c ./bin/splc ./syntax.tab.c ./syntax.tab.h ./syntax.output