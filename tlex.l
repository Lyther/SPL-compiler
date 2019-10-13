%{
	#define EXIT_OK 0
	#define EXIT_FAIL -1
%}
NESTED_COMMENT \/\*([^\*]|(\*+[^\*\/]))*\/\*([^\*]|(\*+[^\*\/]))*\*+\/([^\*]|(\*+[^\*\/]))*\*+\/
COMMENT (\/\*([^*]|(\*+[^*\/]))*\*+\/)|(\/\/.*)
INT ([0-9]+)|(0x[0-9A-Fa-f]+)|(0[0-7]+)
FLOAT ([0-9]+\.[0-9]+)|([0-9]+(\.[0-9])?[fF])
CHAR ('.')|('\\x[0-9A-Fa-f]{2}')
STRUCT struct
STRING \"(\\.|[^\n"\\])*\"
TYPE (int)|(float)|(char)|(string)|(struct)
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
WHITESPACE [ \t\r\n]+
ID [_A-Za-z][_A-Za-z0-9]*
%%
{NESTED_COMMENT} { printf("Error type A at Line %d: syntax error\n", yylineno); }
{COMMENT} {}
{INT} { printf("INT %s\n", yytext); }
{FLOAT} { printf("FLOAT %s\n", yytext); }
{CHAR} { printf("CHAR %s\n", yytext); }
{STRUCT} { printf("STRUCT %s\n", yytext); }
{STRING} { printf("STRING %s\n", yytext); }
{TYPE} { printf("TYPE %s\n", yytext); }
{IF} { printf("IF\n"); }
{ELSE} { printf("ELSE\n"); }
{WHILE} { printf("WHILE\n"); }
{RETURN} { printf("RETURN\n"); }
{DOT} { printf("DOT\n"); }
{SEMI} { printf("SEMI\n"); }
{COMMA} { printf("COMMA\n"); }
{ASSIGN} { printf("ASSIGN\n"); }
{LT} { printf("LT\n"); }
{GT} { printf("GT\n"); }
{LE} { printf("LE\n"); }
{GE} { printf("GE\n"); }
{NE} { printf("NE\n"); }
{EQ} { printf("EQ\n"); }
{PLUS} { printf("PLUS\n"); }
{MINUS} { printf("MINUS\n"); }
{MUL} { printf("MUL\n"); }
{DIV} { printf("DIV\n"); }
{AND} { printf("AND\n"); }
{OR} { printf("OR\n"); }
{NOT} { printf("NOT\n"); }
{LP} { printf("LP\n"); }
{RP} { printf("RP\n"); }
{LB} { printf("LB\n"); }
{RB} { printf("RB\n"); }
{LC} { printf("LC\n"); }
{RC} { printf("RC\n"); }
{ID} { printf("ID %s\n", yytext); }
{WHITESPACE} {}
. { printf("Error type A at Line %d: Unknown characters \'%s\'\n", yylineno, yytext); }
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