%{
	#define EXIT_OK 0
	#define EXIT_FAIL -1
	#include "syntax.tab.h"
%}
INT ([0-9]+)|(0x[0-9A-Fa-f]+)|(0[0-7]+)
FLOAT ([0-9]+\.[0-9]+)|([0-9]+(\.[0-9])?[fF])
CHAR ('.')|('\\x[0-9A-Fa-f]{2}')
STRING \"(\\.|[^\n"\\])*\"
TYPE (int)|(float)|(char)|(string)
STRUCT struct
IF if
ELSE else
WHILE while
RETURN return
DOT \.
SEMI ;
COMMA ,
ASSIGN =
LT <
GT >
LE <=
GE >=
NE !=
EQ ==
PLUS \+
MINUS -
MUL \*
DIV \/
AND &&
OR \|\|
NOT !
LP \(
RP \)
LB \[
RB \]
LC \{
RC \}
COMMENT (\/\*([^*]|(\*+[^*\/]))*\*+\/)|(\/\/.*)
WHITESPACE [ \t\r\n]+
ID [_A-Za-z][_A-Za-z0-9]*
%%
{COMMENT} {}
{INT} { printf("INT %s\n", yytext); return INT; }
{FLOAT} { printf("FLOAT %s\n", yytext); return FLOAT; }
{CHAR} { printf("CHAR %s\n", yytext); return CHAR; }
{STRING} { printf("STRING %s\n", yytext); return STRING; }
{TYPE} { printf("TYPE %s\n", yytext); return TYPE; }
{STRUCT} { printf("STRUCT %s\n", yytext); return STRUCT; }
{IF} { printf("IF\n"); return IF; }
{ELSE} { printf("ELSE\n"); return ELSE; }
{WHILE} { printf("WHILE\n"); return WHILE; }
{RETURN} { printf("RETURN\n"); return RETURN; }
{DOT} { printf("DOT\n"); return DOT; }
{SEMI} { printf("SEMI\n"); return SEMI; }
{COMMA} { printf("COMMA\n"); return COMMA; }
{ASSIGN} { printf("ASSIGN\n"); return ASSIGN; }
{LT} { printf("LT\n"); return LT; }
{GT} { printf("GT\n"); return GT; }
{LE} { printf("LE\n"); return LE; }
{GE} { printf("GE\n"); return GE; }
{NE} { printf("NE\n"); return NE; }
{EQ} { printf("EQ\n"); return EQ; }
{PLUS} { printf("PLUS\n"); return PLUS; }
{MINUS} { printf("MINUS\n"); return MINUS; }
{MUL} { printf("MUL\n"); return MUL; }
{DIV} { printf("DIV\n"); return DIV; }
{AND} { printf("AND\n"); return AND; }
{OR} { printf("OR\n"); return OR; }
{NOT} { printf("NOT\n"); return NOT; }
{LP} { printf("LP\n"); return LP; }
{RP} { printf("RP\n"); return RP; }
{LB} { printf("LB\n"); return LB; }
{RB} { printf("RB\n"); return RB; }
{LC} { printf("LC\n"); return LC; }
{RC} { printf("RC\n"); return RC; }
{ID} { printf("ID %s\n", yytext); return ID; }
{WHITESPACE} {}
. { printf("Error type A at Line %d: Unknown characters \'%s\'\n", yylineno, yytext); return ERR; }
%%
int main(int argc, char **argv) {
	char *file_path;
	if (argc == 2) {
		file_path = argv[1];
		if (!(yyin = fopen(file_path, "r"))) {
			perror(argv[1]);
			return EXIT_FAIL;
		}
		printf("Lexical Analysing file: %s\n", argv[1]);
		yylex();
		return EXIT_OK;
	} else if (argc < 2) {
		fprintf(stderr, "Usage: %s <file_path>\n", argv[0]);
	} else {
		fputs("Too much arguments!\n", stderr);
		return EXIT_FAIL;
	}
}