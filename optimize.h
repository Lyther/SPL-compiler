#ifndef _OPTIMIZE_H_
#define _OPTIMIZE_H_
#include <string>
#include <vector>
#include <map>
using namespace std;

class Optimize {
private:
	vector<string> codelist;
	map<double, string> constant_pool;
	map<string, string> replace_str;

	void establishConstantPool(vector<string>&);
	void reduceTemp(vector<string>&);
public:
	Optimize(vector<string>);
	vector<string> getCodeList();
};

#endif