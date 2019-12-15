#ifndef _INNERCODE_H_
#define _INNERCODE_H_

#include <iostream>
#include "tree.h"
#include "stmt.h"
#include "optimize.h"
#include<string>
extern struct gramTree* root;

using namespace std;

class InnerCode {
private:
	vector<string> codeList;

public:
	int tempNum = 1;
	int varNum = 1;
	int labelNum = 1;
	int arrayNum = 0;

	InnerCode();
	void addCode(string);
	void printCode();
	string createCodeforVar(string tempname, string op, varNode node1, varNode node2);
	string createCodeforAssign(varNode node1,varNode node2);
	string createCodeforParameter(varNode node);
	string createCodeforReturn(varNode node);
	string createCodeforArgument(varNode node, string funcName);

	string getNodeName(varNode node);
	string getarrayNodeName(arrayNode node);
	string getLabelName();
};

#endif // !_INNERCODE_H_
