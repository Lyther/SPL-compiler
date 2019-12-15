splc:
	flex lex.l
	bison -vdty syntax.y
	g++ -std=c++11 -o ./bin/splc tree.cpp parser.cpp ir.cpp extension.cpp optimize.cpp lex.yy.c y.tab.c
clean:
	rm -rf ./y.tab.c ./y.tab.h ./y.output ./lex.yy.c ./bin/splc