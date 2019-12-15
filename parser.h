#ifndef _PARSER_H_
#define _PARSER_H_
#include "stmt.h"
#include "tree.h"
#include "ir.h"
#include <vector>
#include <set>

using namespace std;

class Praser {
public:
	Praser(gramTree*);
	~Praser();
private:
	map<string, funcNode> funcPool;
	vector<Block> blockStack;
	InnerCode innerCode;

	struct gramTree* root;

	void praserInit();
	void praserGramTree(struct gramTree* node);
	
	struct gramTree* praser_declaration(struct gramTree* node);
	void praser_init_declarator_list(string, struct gramTree*);
	void praser_init_declarator(string, struct gramTree* );

	struct gramTree* praser_function_definition(struct gramTree*);
	void praser_parameter_list(struct gramTree*,string,bool);
	void praser_parameter_declaration(struct gramTree*, string,bool);

	struct gramTree* praser_statement(struct gramTree*);

	void praser_expression_statement(struct gramTree*);
	varNode praser_expression(struct gramTree*);

	void praser_argument_expression_list(struct gramTree*,string);

	void praser_jump_statement(struct gramTree*);
	void praser_compound_statement(struct gramTree*);
	void praser_selection_statement(struct gramTree*);
	void praser_iteration_statement(struct gramTree*);

	varNode praser_assignment_expression(struct gramTree*);
	varNode praser_logical_or_expression(struct gramTree*);
	varNode praser_logical_and_expression(struct gramTree*);
	varNode praser_inclusive_or_expression(struct gramTree*);
	varNode praser_exclusive_or_expression(struct gramTree*);
	varNode praser_and_expression(struct gramTree*);
	varNode praser_equality_expression(struct gramTree*);
	varNode praser_relational_expression(struct gramTree*);
	varNode praser_shift_expression(struct gramTree*);
	varNode praser_additive_expression(struct gramTree*);
	varNode praser_multiplicative_expression(struct gramTree*);
	varNode praser_unary_expression(struct gramTree*);
	varNode praser_postfix_expression(struct gramTree*);
	varNode praser_primary_expression(struct gramTree*);


	string lookupVar(string name);
	bool lookupCurruntVar(string name);
	struct varNode lookupNode(string name);
	string getFuncRType();
	string getArrayType(string);
	struct arrayNode getArrayNode(string);

	int getBreakBlockNumber();

	struct varNode createTempVar(string name, string type);

	void error(int type, int line, string error);

	void print_map();
	void print_code();
};

#endif