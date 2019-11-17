%{
	#include <stdio.h>
	#include <string.h>
	#include "AST.h"
	#include "lex.yy.c"

	int errors = 0;

	void yyerror(const char* s);
	void printerr(int line, const char* message);
%}

%union {
	node* tr;
}

%token <tr> INT FLOAT CHAR STRING STRUCT TYPE
%token <tr> IF ELSE WHILE
%token <tr> RETURN
%token <tr> ID
%token <tr> LT GT LE GE NE EQ PLUS MINUS MUL DIV AND OR NOT
%token <tr> DOT SEMI COMMA ASSIGN LP RP LB RB LC RC
%token <tr> ERR

%type <tr> Program ExtDefList ExtDef ExtDecList Specifier StructSpecifier VarDec FunDec
%type <tr> VarList ParamDec CompSt StmtList Stmt Matched_Stmt Open_Stmt DefList
%type <tr> Def DecList Dec Exp Args

%nonassoc LP RP LB RB LC RC
%nonassoc ELSE
%left DOT
%right ASSIGN
%left LT GT LE GE NE EQ
%left OR
%left AND
%left PLUS MINUS
%left MUL DIV
%right NOT

%%

Program: ExtDefList { $$ = new_node("Program", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); if (errors == 0) print_tree($$, 0); };
ExtDefList: ExtDef ExtDefList { $$ = new_node("ExtDefList", NULL, $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); }
	| { $$ = new_node("Empty", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); };
ExtDef: Specifier ExtDecList SEMI { $$ = new_node("ExtDef", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Specifier SEMI { $$ = new_node("ExtDef", NULL, $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); }
	| Specifier FunDec CompSt { $$ = new_node("ExtDef", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Specifier ExtDecList { $$ = new_node("ERR", "semi error", $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); printerr($1->lineno, "Missing semicolon ';'"); }
	| Specifier { $$ = new_node("ERR", "semi error", $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); printerr($1->lineno, "Missing semicolon ';'"); };
ExtDecList: VarDec { $$ = new_node("ExtDecList", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| VarDec COMMA ExtDecList { $$ = new_node("ExtDecList", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); };
Specifier: TYPE { $$ = new_node("Specifier", NULL, yylineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| StructSpecifier { $$ = new_node("Specifier", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); };
StructSpecifier: STRUCT ID LC DefList RC { $$ = new_node("StructSpecifier", NULL, $1->lineno, $1, $2, $3, $4, $5, NULL, NULL); }
	| STRUCT ID { $$ = new_node("StructSpecifier", NULL, yylineno, $1, $2, NULL, NULL, NULL, NULL, NULL); };
VarDec: ID { $$ = new_node("VarDec", NULL, yylineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| VarDec LB INT RB { $$ = new_node("VarDec", NULL, $1->lineno, $1, $2, $3, $4, NULL, NULL, NULL); };
FunDec: ID LP VarList RP { $$ = new_node("FunDec", NULL, $1->lineno, $1, $2, $3, $4, NULL, NULL, NULL); }
	| ID LP RP { $$ = new_node("FunDec", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| ID LP { $$ = new_node("ERR", "parenthesis error", $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); printerr($1->lineno, "Missing parenthesis ')'"); };
VarList: ParamDec COMMA VarList { $$ = new_node("VarList", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| ParamDec { $$ = new_node("VarList", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); };
ParamDec: Specifier VarDec { $$ = new_node("ParamDec", NULL, $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); };
CompSt: LC DefList StmtList RC { $$ = new_node("CompSt", NULL, $1->lineno, $1, $2, $3, $4, NULL, NULL, NULL); };
StmtList: Stmt StmtList { $$ = new_node("StmtList", NULL, $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); }
	| { $$ = new_node("Empty", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); };
Stmt: Matched_Stmt { $$ = new_node("Stmt", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| Open_Stmt { $$ = new_node("Stmt", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); };
Matched_Stmt: IF LP Exp RP Matched_Stmt ELSE Matched_Stmt { $$ = new_node("Matched_Stmt", NULL, $1->lineno, $1, $2, $3, $4, $5, $6, $7); }
	| Exp SEMI { $$ = new_node("Matched_Stmt", NULL, $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); }
	| CompSt { $$ = new_node("Matched_Stmt", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| RETURN Exp SEMI { $$ = new_node("Matched_Stmt", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| WHILE LP Exp RP Stmt { $$ = new_node("Matched_Stmt", NULL, $1->lineno, $1, $2, $3, $4, $5, NULL, NULL); }
	| Exp { $$ = new_node("ERR", "semi error", $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); printerr($1->lineno, "Missing semicolon ';'"); }
	| RETURN Exp { $$ = new_node("ERR", "semi error", $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); printerr($1->lineno, "Missing semicolon ';'"); };
	| IF LP Exp Matched_Stmt ELSE Matched_Stmt { $$ = new_node("ERR", "parenthesis error", $1->lineno, $1, $2, $3, $4, $5, $6, NULL); printerr($1->lineno, "Missing parenthesis ')'"); }
	| WHILE LP Exp Stmt { $$ = new_node("ERR", "parenthesis error", $1->lineno, $1, $2, $3, $4, NULL, NULL, NULL); printerr($1->lineno, "Missing parenthesis ')'"); };
Open_Stmt: IF LP Exp RP Stmt { $$ = new_node("Open_Stmt", NULL, $1->lineno, $1, $2, $3, $4, $5, NULL, NULL); }
	| IF LP Exp RP Matched_Stmt ELSE Open_Stmt { $$ = new_node("Open_Stmt", NULL, $1->lineno, $1, $2, $3, $4, $5, $6, $7); }
	| IF LP Exp Stmt { $$ = new_node("ERR", "parenthesis error", $1->lineno, $1, $2, $3, $4, NULL, NULL, NULL); printerr($1->lineno, "Missing parenthesis ')'"); }
	| IF LP Exp Matched_Stmt ELSE Open_Stmt { $$ = new_node("ERR", "parenthesis error", $1->lineno, $1, $2, $3, $4, $5, $6, NULL); printerr($1->lineno, "Missing parenthesis ')'"); };
DefList: Def DefList { $$ = new_node("DefList", NULL, $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); }
	| { $$ = new_node("Empty", NULL, yylineno, NULL, NULL, NULL, NULL, NULL, NULL, NULL); };
Def: Specifier DecList SEMI { $$ = new_node("Def", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Specifier DecList { $$ = new_node("ERR", "semi error", $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); printerr($1->lineno, "Missing semicolon ';'"); };
DecList: Dec { $$ = new_node("DecList", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| Dec COMMA DecList { $$ = new_node("DecList", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); };
Dec: VarDec { $$ = new_node("Dec", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| VarDec ASSIGN Exp { $$ = new_node("Dec", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); };
Exp: Exp ASSIGN Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp AND Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp OR Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp LT Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp LE Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp GT Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp GE Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp NE Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp EQ Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp PLUS Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp MINUS Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp MUL Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp DIV Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp ERR Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| LP Exp RP { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| MINUS Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); }
	| NOT Exp { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, NULL, NULL, NULL, NULL, NULL); }
	| ID LP Args RP { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, $4, NULL, NULL, NULL); }
	| ID LP RP { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp LB Exp RB { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, $4, NULL, NULL, NULL); }
	| Exp DOT ID { $$ = new_node("Exp", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| ID { $$ = new_node("Exp", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| INT { $$ = new_node("Exp", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| FLOAT { $$ = new_node("Exp", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| CHAR { $$ = new_node("Exp", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| STRING { $$ = new_node("Exp", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); }
	| ERR { $$ = new_node("Exp", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); };
Args: Exp COMMA Args { $$ = new_node("Args", NULL, $1->lineno, $1, $2, $3, NULL, NULL, NULL, NULL); }
	| Exp { $$ = new_node("Args", NULL, $1->lineno, $1, NULL, NULL, NULL, NULL, NULL, NULL); };

%%

void yyerror(const char *s) {
//	 printf("Error type B at Line %d: %s\n", yylineno, s);
//	 errors++;
}

void printerr(int line, const char* message) {
	printf("Error type B at Line %d: %s\n", line, message);
	errors++;
}

int main(int argc, char **argv) {
	if (argc == 2) {
		yyin = fopen(argv[1], "r");
		char buffer[50] = {0};
		memcpy(buffer, argv[1], strlen(argv[1]) - 4);
		char file[80];
		strcat(file, buffer);
		strcat(file, ".out");
		printf("%s\n", file);
		freopen(file, "w", stdout);
		yyparse();
		fclose(yyin);
		return 0;
	} else if (argc < 2) {
		fprintf(stderr, "Usage: %s <file_path>\n", argv[0]);
		return -1;
	} else {
		fputs("Too many arguments!\n", stderr);
		return -1;
	}
}