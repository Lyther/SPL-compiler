%{
	#include "AST.h"
	#include "syntax.tab.h"
	
%}
%option yylineno
COMMENT (\/\*([^\*]|(\*+[^\*\/]))*\*+\/)|(\/\/.*)
NESTED_COMMENT \/\*([^\*]|(\*+[^\*\/]))*\/\*([^\*]|(\*+[^\*\/]))*\*+\/([^\*]|(\*+[^\*\/]))*\*+\/
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
{NESTED_COMMENT} { printf("Error type A at Line %d: syntax error\n", yylineno); exit(-1); }
{COMMENT} {}
{INT} { yylval.tr = new_node("INT", yytext, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return INT; }
{FLOAT} { yylval.tr = new_node("FLOAT", yytext, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return FLOAT; }
{CHAR} { yylval.tr = new_node("CHAR", yytext, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return CHAR; }
{STRUCT} { yylval.tr = new_node("STRUCT", yytext, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return STRUCT; }
{STRING} { yylval.tr = new_node("STRING", yytext, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return STRING; }
{TYPE} { yylval.tr = new_node("TYPE", yytext, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return TYPE; }
{IF} { yylval.tr = new_node("IF", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return IF; }
{ELSE} { yylval.tr = new_node("ELSE", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return ELSE; }
{WHILE} { yylval.tr = new_node("WHILE", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return WHILE; }
{RETURN} { yylval.tr = new_node("RETURN", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return RETURN; }
{DOT} { yylval.tr = new_node("DOT", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return DOT; }
{SEMI} { yylval.tr = new_node("SEMI", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return SEMI; }
{COMMA} { yylval.tr = new_node("COMMA", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return COMMA; }
{ASSIGN} { yylval.tr = new_node("ASSIGN", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return ASSIGN; }
{LT} { yylval.tr = new_node("LT", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return LT; }
{GT} { yylval.tr = new_node("GT", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return GT; }
{LE} { yylval.tr = new_node("LE", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return LE; }
{GE} { yylval.tr = new_node("GE", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return GE; }
{NE} { yylval.tr = new_node("NE", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return NE; }
{EQ} { yylval.tr = new_node("EQ", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return EQ; }
{PLUS} { yylval.tr = new_node("PLUS", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return PLUS; }
{MINUS} { yylval.tr = new_node("MINUS", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return MINUS; }
{MUL} { yylval.tr = new_node("MUL", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return MUL; }
{DIV} { yylval.tr = new_node("DIV", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return DIV; }
{AND} { yylval.tr = new_node("AND", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return AND; }
{OR} { yylval.tr = new_node("OR", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return OR; }
{NOT} { yylval.tr = new_node("NOT", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return NOT; }
{LP} { yylval.tr = new_node("LP", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return LP; }
{RP} { yylval.tr = new_node("RP", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return RP; }
{LB} { yylval.tr = new_node("LB", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return LB; }
{RB} { yylval.tr = new_node("RB", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return RB; }
{LC} { yylval.tr = new_node("LC", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return LC; }
{RC} { yylval.tr = new_node("RC", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return RC; }
{ID} { yylval.tr = new_node("ID", yytext, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); return ID; }
{WHITESPACE} ;
. { printf("Error type A at Line %d: unknown lexeme %s\n", yylineno, yytext); return ERR; }
%%
