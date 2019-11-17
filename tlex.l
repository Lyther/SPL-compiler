%{
	#define EXIT_OK 0
	#define EXIT_FAIL -1
%}

NESTED_COMMENT \/\*([^\*]|(\*+[^\*\/]))*\/\*([^\*]|(\*+[^\*\/]))*\*+\/([^\*]|(\*+[^\*\/]))*\*+\/
COMMENT (\/\*([^*]|(\*+[^*\/]))*\*+\/)|(\/\/.*)
INT ([0-9]+)|(0x[0-9A-Fa-f]+)|(0[0-7]+)
W_INT [+-]?0x[0-9A-Za-z]+
FLOAT ([0-9]+\.[0-9]+)|([0-9]+(\.[0-9])?[fF])
CHAR ('.')|('\\x[0-9A-Fa-f]{2}')
W_CHAR '\\x[0-9A-Za-z]*'
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
W_ID [_A-Za-z0-9]*

%%

{NESTED_COMMENT} { printf("Error type A at Line %d: syntax error\n", yylineno); }
{COMMENT} {}
{INT} { printf("INT %s\n", yytext); }
{W_INT} { printf("Error type A at Line %d: Mysterious lexeme %s\n", yylineno, yytext); }
{FLOAT} { printf("FLOAT %s\n", yytext); }
{CHAR} { printf("CHAR %s\n", yytext); }
{W_CHAR} { printf("Error type A at Line %d: Mysterious lexeme %s\n", yylineno, yytext); }
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
{W_ID} { printf("Error type A at Line %d: Mysterious lexeme %s\n", yylineno, yytext); }
{WHITESPACE} {}
. { printf("Error type A at Line %d: Mysterious lexeme %s\n", yylineno, yytext); }
%%
int main(int argc, char **argv) {
	if (argc == 2) {
		if (!(yyin = fopen(argv[1], "r"))) {
			perror(argv[1]);
			return EXIT_FAIL;
		}
		printf("Lexical Analysing file: %s\n", argv[1]);
		char buffer[50] = {0};
		memcpy(buffer, argv[1], strlen(argv[1]) - 4);
		char file[80];
		strcat(file, "./test/");
		strcat(file, buffer);
		strcat(file, ".out");
		printf("print redirect to %s\n", file);
		freopen(file, "w", stdout);
		yylex();
		return EXIT_OK;
	} else if (argc < 2) {
		fprintf(stderr, "Usage: %s <file_path>\n", argv[0]);
	} else {
		fputs("Too much arguments!\n", stderr);
		return EXIT_FAIL;
	}
}