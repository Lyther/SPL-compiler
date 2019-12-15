#ifndef _STMT_H_
#define _STMT_H_

#include<iostream>
#include<string>
#include<vector>
#include<map>
#include "tree.h"
using namespace std;

struct varNode {
	string name;
	string type;
	int num = -1;
	bool useAddress = false;
	string boolString;
};

struct funcNode {
	bool isdefinied = false;
	string name;
	string rtype;
	vector<varNode> paralist;
};

struct arrayNode {
	string name;
	string type;
	int num = -1;
};

class Block {
public:
	funcNode func;
	bool isfunc = false;
	map<string, struct varNode> varMap;
	map<string, struct arrayNode> arrayMap;
	string breakLabelname;
	bool canBreak = false;
};

#endif