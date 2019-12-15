#ifndef _OPTIMIZE_H_
#define _OPTIMIZE_H_
#include <string>
#include <vector>
#include <map>
using namespace std;

struct Message {
	int line = -1;
	int num = 0;
};

class Optimize {
private:
	vector<string> codelist;
	map<string, Message> tempMessage;

	void establishMap(vector<string>&);
	void dropTrumpTemp(vector<string>&);

public:
	Optimize(vector<string>);
	vector<string> getCodeList();

};

#endif