%{

	#include <cstdlib>
	#include <cstdio>
	#include <string>
	#include "tree.h"
	#include "stmt.h"
	#include "parser.h"
	using namespace std;

	extern char *yytext;
	extern int column;
	extern FILE * yyin;
	extern FILE * yyout;
	gramTree *root;
	extern int yylineno;

	int yylex(void);
	void yyerror(const char*);

%}

%union{
	struct gramTree* gt;
}

%token <gt> IDENTIFIER CONSTANT STRING_LITERAL SIZEOF CONSTANT_INT CONSTANT_DOUBLE
%token <gt> PTR INC DEC LEFT RIGHT LE GE EQ NE
%token <gt> AND OR MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token <gt> SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token <gt> XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token <gt> CHAR INT DOUBLE VOID BOOL STRUCT

%token <gt> CASE IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token <gt> TRUE FALSE

%token <gt> SEMI COMMA COLON ASSIGN LB RB DOT AMPERSAND EXCLAMATION TILDE MINUS PLUS MUL DIV PERCENT LT GT CARET BAR QUESTION LC RC LP RP

%type <gt> primary_expression postfix_expression argument_expression_list unary_expression unary_operator
%type <gt> multiplicative_expression additive_expression shift_expression relational_expression equality_expression
%type <gt> and_expression exclusive_or_expression inclusive_or_expression logical_and_expression logical_or_expression
%type <gt> assignment_expression assignment_operator expression

%type <gt> declaration init_declarator_list init_declarator type_specifier

%type <gt> declarator

%type <gt> parameter_list parameter_declaration identifier_list
%type <gt> abstract_declarator initializer initializer_list designation designator_list
%type <gt> designator statement labeled_statement compound_statement block_item_list block_item expression_statement
%type <gt> selection_statement iteration_statement jump_statement translation_unit external_declaration function_definition
%type <gt> declaration_list

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%

Program: translation_unit { root = create_tree("Program", 1, $1); }
	;

primary_expression: IDENTIFIER { $$ = create_tree("primary_expression", 1, $1); }
	| TRUE { $$ = create_tree("primary_expression", 1, $1); }
	| FALSE { $$ = create_tree("primary_expression", 1, $1); }
	| CONSTANT_INT { $$ = create_tree("primary_expression", 1, $1); }
	| CONSTANT_DOUBLE { $$ = create_tree("primary_expression", 1, $1); }
	| LP expression RP { $$ = create_tree("primary_expression", 3, $1, $2, $3); }
	;

postfix_expression: primary_expression { $$ = create_tree("postfix_expression", 1, $1); }
	| postfix_expression LB expression RB { $$ = create_tree("postfix_expression", 4, $1, $2, $3, $4); }
	| postfix_expression LP RP { $$ = create_tree("postfix_expression", 3, $1, $2, $3); }
	| postfix_expression LP argument_expression_list RP { $$ = create_tree("postfix_expression", 4, $1, $2, $3, $4); }
	| postfix_expression INC { $$ = create_tree("postfix_expression", 2, $1, $2); }
	| postfix_expression DEC { $$ = create_tree("postfix_expression", 2, $1, $2); }
	;

argument_expression_list: assignment_expression { $$ = create_tree("argument_expression_list", 1, $1); }
	| argument_expression_list COMMA assignment_expression { $$ = create_tree("argument_expression_list", 3, $1, $2, $3); }
	;

unary_expression: postfix_expression { $$ = create_tree("unary_expression", 1, $1); }
	| INC unary_expression { $$ = create_tree("unary_expression", 2, $1, $2); }
	| DEC unary_expression { $$ = create_tree("unary_expression", 2, $1, $2); }
	| unary_operator unary_expression { $$ = create_tree("unary_expression", 2, $1, $2); }
	;

unary_operator: PLUS { $$ = create_tree("unary_operator", 1, $1); }
	| MINUS { $$ = create_tree("unary_operator", 1, $1); }
	| TILDE { $$ = create_tree("unary_operator", 1, $1); }
	| EXCLAMATION { $$ = create_tree("unary_operator", 1, $1); }
	;

multiplicative_expression: unary_expression { $$ = create_tree("multiplicative_expression", 1, $1); }
	| multiplicative_expression MUL unary_expression { $$ = create_tree("multiplicative_expression", 3, $1, $2, $3); }
	| multiplicative_expression DIV unary_expression { $$ = create_tree("multiplicative_expression", 3, $1, $2, $3); }
	| multiplicative_expression PERCENT unary_expression { $$ = create_tree("multiplicative_expression", 3, $1, $2, $3); }
	;

additive_expression: multiplicative_expression { $$ = create_tree("additive_expression", 1, $1); }
	| additive_expression PLUS multiplicative_expression { $$ = create_tree("additive_expression", 3, $1, $2, $3); }
	| additive_expression MINUS multiplicative_expression { $$ = create_tree("additive_expression", 3, $1, $2, $3); }
	;

shift_expression: additive_expression { $$ = create_tree("shift_expression", 1, $1); }
	| shift_expression LEFT additive_expression { $$ = create_tree("shift_expression", 3, $1, $2, $3); }
	| shift_expression RIGHT additive_expression { $$ = create_tree("shift_expression", 3, $1, $2, $3); }
	;

relational_expression: shift_expression { $$ = create_tree("relational_expression", 1, $1); }
	| relational_expression LT shift_expression { $$ = create_tree("relational_expression", 3, $1, $2, $3); }
	| relational_expression GT shift_expression { $$ = create_tree("relational_expression", 3, $1, $2, $3); }
	| relational_expression LE shift_expression { $$ = create_tree("relational_expression", 3, $1, $2, $3); }
	| relational_expression GE shift_expression { $$ = create_tree("relational_expression", 3, $1, $2, $3); }
	;

equality_expression: relational_expression { $$ = create_tree("equality_expression", 1, $1); }
	| equality_expression EQ relational_expression { $$ = create_tree("equality_expression", 3, $1, $2, $3); }
	| equality_expression NE relational_expression { $$ = create_tree("equality_expression", 3, $1, $2, $3); }
	;

and_expression: equality_expression { $$ = create_tree("and_expression", 1, $1); }
	| and_expression AMPERSAND equality_expression { $$ = create_tree("and_expression", 3, $1, $2, $3); }
	;

exclusive_or_expression: and_expression { $$ = create_tree("exclusive_or_expression", 1, $1); }
	| exclusive_or_expression CARET and_expression { $$ = create_tree("exclusive_or_expression", 3, $1, $2, $3); }
	;

inclusive_or_expression: exclusive_or_expression { $$ = create_tree("inclusive_or_expression", 1, $1); }
	| inclusive_or_expression BAR exclusive_or_expression { $$ = create_tree("inclusive_or_expression", 3, $1, $2, $3); }
	;

logical_and_expression: inclusive_or_expression { $$ = create_tree("logical_and_expression", 1, $1); }
	| logical_and_expression AND inclusive_or_expression { $$ = create_tree("logical_and_expression", 3, $1, $2, $3); }
	;

logical_or_expression: logical_and_expression { $$ = create_tree("logical_or_expression", 1, $1); }
	| logical_or_expression OR logical_and_expression { $$ = create_tree("logical_or_expression", 3, $1, $2, $3); }
	;

assignment_expression: logical_or_expression { $$ = create_tree("assignment_expression", 1, $1); }
	| unary_expression assignment_operator assignment_expression { $$ = create_tree("assignment_expression", 3, $1, $2, $3); }
	;

assignment_operator: ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	| MUL_ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	| DIV_ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	| MOD_ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	| ADD_ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	| SUB_ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	| LEFT_ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	| RIGHT_ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	| AND_ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	| XOR_ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	| OR_ASSIGN { $$ = create_tree("assignment_operator", 1, $1); }
	;

expression: assignment_expression { $$ = create_tree("expression", 1, $1); }
	| expression COMMA assignment_expression { $$ = create_tree("expression", 3, $1, $2, $3); }
	;

declaration: type_specifier SEMI { $$ = create_tree("declaration", 2, $1, $2); }
	| type_specifier init_declarator_list SEMI { $$ = create_tree("declaration", 3, $1, $2, $3); }
	;

init_declarator_list: init_declarator { $$ = create_tree("init_declarator_list", 1, $1); }
	| init_declarator_list COMMA init_declarator { $$ = create_tree("init_declarator_list", 3, $1, $2, $3); }
	;

init_declarator: declarator { $$ = create_tree("init_declarator", 1, $1); }
	| declarator ASSIGN initializer { $$ = create_tree("init_declarator", 3, $1, $2, $3); }
	;

type_specifier: VOID { $$ = create_tree("type_specifier", 1, $1); }
	| CHAR { $$ = create_tree("type_specifier", 1, $1); }
	| INT { $$ = create_tree("type_specifier", 1, $1); }
	| DOUBLE { $$ = create_tree("type_specifier", 1, $1); }
	| BOOL { $$ = create_tree("type_specifier", 1, $1); }
	;

declarator: IDENTIFIER { $$ = create_tree("declarator", 1, $1); }
	| LP declarator RP { $$ = create_tree("declarator", 3, $1, $2, $3); }
	| declarator LB assignment_expression RB { $$ = create_tree("declarator", 4, $1, $2, $3, $4); }
	| declarator LB MUL RB { $$ = create_tree("declarator", 4, $1, $2, $3, $4); }
	| declarator LB RB { $$ = create_tree("declarator", 3, $1, $2, $3); }
	| declarator LP parameter_list RP { $$ = create_tree("declarator", 4, $1, $2, $3, $4); }
	| declarator LP identifier_list RP { $$ = create_tree("declarator", 4, $1, $2, $3, $4); }
	| declarator LP RP { $$ = create_tree("declarator", 3, $1, $2, $3); }
	;

parameter_list: parameter_declaration { $$ = create_tree("parameter_list", 1, $1); }
	| parameter_list COMMA parameter_declaration { $$ = create_tree("parameter_list", 3, $1, $2, $3); }
	;

parameter_declaration: type_specifier declarator { $$ = create_tree("parameter_declaration", 2, $1, $2); }
	| type_specifier abstract_declarator { $$ = create_tree("parameter_declaration", 2, $1, $2); }
	| type_specifier { $$ = create_tree("parameter_declaration", 1, $1); }
	;

identifier_list: IDENTIFIER { $$ = create_tree("identifier_list", 1, $1); }
	| identifier_list COMMA IDENTIFIER { $$ = create_tree("identifier_list", 3, $1, $2, $3); }
	;

abstract_declarator: LP abstract_declarator RP { $$ = create_tree("abstract_declarator", 3, $1, $2, $3); }
	| LB RB { $$ = create_tree("abstract_declarator", 2, $1, $2); }
	| LB assignment_expression RB { $$ = create_tree("abstract_declarator", 3, $1, $2, $3); }
	| abstract_declarator LB RB { $$ = create_tree("abstract_declarator", 3, $1, $2, $3); }
	| abstract_declarator LB assignment_expression RB { $$ = create_tree("abstract_declarator", 4, $1, $2, $3, $4); }
	| LB MUL RB { $$ = create_tree("abstract_declarator", 3, $1, $2, $3); }
	| abstract_declarator LB MUL RB { $$ = create_tree("abstract_declarator", 4, $1, $2, $3, $4); }
	| LP RP { $$ = create_tree("abstract_declarator", 2, $1, $2); }
	| LP parameter_list RP { $$ = create_tree("abstract_declarator", 3, $1, $2, $3); }
	| abstract_declarator LP RP { $$ = create_tree("abstract_declarator", 3, $1, $2, $3); }
	| abstract_declarator LP parameter_list RP { $$ = create_tree("abstract_declarator", 4, $1, $2, $3, $4); }
	;

initializer: assignment_expression { $$ = create_tree("initializer", 1, $1); }
	| LC initializer_list RC { $$ = create_tree("initializer", 3, $1, $2, $3); }
	| LC initializer_list COMMA RC { $$ = create_tree("initializer", 4, $1, $2, $3, $4); }
	;

initializer_list: initializer { $$ = create_tree("initializer_list", 1, $1); }
	| designation initializer { $$ = create_tree("initializer_list", 2, $1, $2); }
	| initializer_list COMMA initializer { $$ = create_tree("initializer_list", 3, $1, $2, $3); }
	| initializer_list COMMA designation initializer { $$ = create_tree("initializer_list", 3, $1, $2, $3); }
	;

designation: designator_list ASSIGN { $$ = create_tree("designation", 2, $1, $2); }
	;

designator_list: designator { $$ = create_tree("designator_list", 1, $1); }
	| designator_list designator { $$ = create_tree("designator_list", 2, $1, $2); }
	;

designator: LB logical_or_expression RB { $$ = create_tree("designator", 3, $1, $2, $3); }
	| DOT IDENTIFIER { $$ = create_tree("designator", 2, $1, $2); }
	;

statement: labeled_statement { $$ = create_tree("statement", 1, $1); }
	| compound_statement { $$ = create_tree("statement", 1, $1); }
	| expression_statement{ $$ = create_tree("statement", 1, $1); }
	| selection_statement { $$ = create_tree("statement", 1, $1); }
	| iteration_statement { $$ = create_tree("statement", 1, $1); }
	| jump_statement { $$ = create_tree("statement", 1, $1); }
	;

labeled_statement: IDENTIFIER COLON statement { $$ = create_tree("labeled_statement", 3, $1, $2, $3); }
	| CASE logical_or_expression COLON statement { $$ = create_tree("labeled_statement", 4, $1, $2, $3, $4); }
	;

compound_statement: LC RC { $$ = create_tree("compound_statement", 2, $1, $2); }
	| LC block_item_list RC { $$ = create_tree("compound_statement", 3, $1, $2, $3); }
	;

block_item_list: block_item { $$ = create_tree("block_item_list", 1, $1); }
	| block_item_list block_item { $$ = create_tree("block_item_list", 2, $1, $2); }
	;

block_item: declaration { $$ = create_tree("block_item", 1, $1); }
	| statement { $$ = create_tree("block_item", 1, $1); }
	;

expression_statement: SEMI { $$ = create_tree("expression_statement", 1, $1); }
	| expression SEMI { $$ = create_tree("expression_statement", 2, $1, $2); }
	;

selection_statement: IF LP expression RP statement %prec LOWER_THAN_ELSE { $$ = create_tree("selection_statement", 5, $1, $2, $3, $4, $5); }
	| IF LP expression RP statement ELSE statement { $$ = create_tree("selection_statement", 7, $1, $2, $3, $4, $5, $6, $7); }
	| SWITCH LP expression RP statement { $$ = create_tree("selection_statement", 5, $1, $2, $3, $4, $5); }
	;

iteration_statement: WHILE LP expression RP statement { $$ = create_tree("iteration_statement", 5, $1, $2, $3, $4, $5); }
	| DO statement WHILE LP expression RP SEMI { $$ = create_tree("iteration_statement", 7, $1, $2, $3, $4, $5, $6, $7); }
	| FOR LP expression_statement expression_statement RP statement { $$ = create_tree("iteration_statement", 6, $1, $2, $3, $4, $5, $6); }
	| FOR LP expression_statement expression_statement expression RP statement { $$ = create_tree("iteration_statement", 7, $1, $2, $3, $4, $5, $6, $7); }
	| FOR LP declaration expression_statement RP statement { $$ = create_tree("iteration_statement", 6, $1, $2, $3, $4, $5, $6); }
	| FOR LP declaration expression_statement expression RP statement { $$ = create_tree("iteration_statement", 7, $1, $2, $3, $4, $5, $6, $7); }
	;

jump_statement: GOTO IDENTIFIER SEMI { $$ = create_tree("jump_statement", 2, $1, $2); }
	| CONTINUE SEMI { $$ = create_tree("jump_statement", 2, $1, $2); }
	| BREAK SEMI { $$ = create_tree("jump_statement", 2, $1, $2); }
	| RETURN SEMI { $$ = create_tree("jump_statement", 2, $1, $2); }
	| RETURN expression SEMI { $$ = create_tree("jump_statement", 3, $1, $2, $3); }
	;

translation_unit: external_declaration { $$ = create_tree("translation_unit", 1, $1); }
	| translation_unit external_declaration { $$ = create_tree("translation_unit", 2, $1, $2); }
	;

external_declaration: function_definition { $$ = create_tree("external_declaration", 1, $1); }
	| declaration { $$ = create_tree("external_declaration", 1, $1); }
	;

function_definition: type_specifier declarator declaration_list compound_statement { $$ = create_tree("function_definition", 4, $1, $2, $3, $4); }
	| type_specifier declarator compound_statement { $$ = create_tree("function_definition", 3, $1, $2, $3); }
	;

declaration_list: declaration { $$ = create_tree("declaration_list", 1, $1); }
	| declaration_list declaration { $$ = create_tree("declaration_list", 2, $1, $2); }
	;

%%

void yyerror(char const *s) {
	fflush(stdout);
	printf("Error type A at Line %d:%d: %s\n", yylineno, column, s);
}

int main(int argc,char* argv[]) {
	yyin = fopen(argv[1],"r");

	// Redirect output to target file.
	char buffer[50] = {0};
	memcpy(buffer, argv[1], strlen(argv[1]) - 4);
	char file[80] = {0};
	strcat(file, buffer);
	strcat(file, ".ir");
	printf("%s\n", file);
	freopen(file, "w", stdout);

	yyparse();

	// If you want to print the syntax tree, remove the comment.
	// eval(root,0);

	Praser praser(root);
	freeGramTree(root);

	fclose(yyin);
	return 0;
}