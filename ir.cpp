#include "ir.h"
#include "optimize.h"
#include "extension.h"
#include <fstream>

InnerCode::InnerCode() {
}

void InnerCode::addCode(string str) {
	codeList.push_back(str);
}

void InnerCode::printCode() {
	Optimize optimize(codeList);
	codeList = optimize.getCodeList();
	for (string s : codeList) {
		cout << s << endl;
	}
}

string InnerCode::createCodeforVar(string tempname, string op, varNode node1, varNode node2) {
	string result = tempname + " := ";
	if (node1.useAddress) {
		result += "*" + node1.name;
	} else {
		if (node1.num < 0) {
			result += node1.name;
		} else result += "v" + inttostr(node1.num);
	}
	result += " " + op + " ";
	if (node2.useAddress) {
		result += "*" + node2.name;
	} else {
		if (node2.num < 0) {
			result += node2.name;
		} else result += "v" + inttostr(node2.num);
	}
	return result;
}

string InnerCode::createCodeforAssign(varNode node1, varNode node2) {
	string result;
	if (node1.useAddress) {
		result = "*" + node1.name + " := ";
	} else {
		result = "v" + inttostr(node1.num);
		result += " := ";
	}
	if (node2.useAddress) {
		result += "*" + node2.name;
	} else {
		if (node2.num < 0) {
			result += node2.name;
		} else result += "v" + inttostr(node2.num);
	}
	return result;
}

string InnerCode::createCodeforParameter(varNode node) {
	string result = "PARAM ";
	result += "v" + inttostr(node.num);
	return result;
}

string InnerCode::createCodeforReturn(varNode node) {
	string result = "RETURN ";
	if (node.useAddress) {
		result += "*" + node.name;
	} else {
		if (node.num < 0) {
			result += node.name;
		} else result += "v" + inttostr(node.num);
	}
	
	return result;
}

string InnerCode::createCodeforArgument(varNode node, string funcName) {
	string result = "";
	if (funcName == "WRITE") {
		result = funcName + " ";
	} else {
		result = "ARG ";
	}
	if (node.useAddress) {
		result += "*" + node.name;
	} else {
		if (node.num < 0) {
			result += node.name;
		}
		else result += "v" + inttostr(node.num);
	}
	return result;
}

string InnerCode::getNodeName(varNode node) {
	if (node.useAddress) {
		return "*" + node.name;
	}
	else {
		if (node.num < 0) {
			return node.name;
		}
		else return ("v" + inttostr(node.num));
	}

}

string InnerCode::getarrayNodeName(arrayNode node) {
	return ("array" + inttostr(node.num));
}

string InnerCode::getLabelName() {
	return "label" + inttostr(labelNum++);
}