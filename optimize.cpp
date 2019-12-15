#include "optimize.h"
#include <iostream>
#include <string>
#include <regex>
#include <map>
#include <vector>
using namespace std;

Optimize::Optimize(vector<string> codelist) {
	establishConstantPool(codelist);
	reduceTemp(codelist);
	removeUselessVar();
}

void Optimize::establishConstantPool(vector<string>& codelist) {
	for (int i = 0; i < codelist.size(); ++i) {
		string str = codelist[i];
		size_t begin = str.find("#");
		size_t end = str.find("\n");
		if (begin != string::npos) {
			string value = str.substr(begin+1, end-begin-1);
			double constant = atof(value.c_str());
			size_t n_begin = str.find("t");
			size_t n_end = str.find(" ");
			string name = str.substr(n_begin, n_end-n_begin);
			if (this->constant_pool.count(constant)) {
				auto itr = this->constant_pool.find(constant);
				string replace_name = itr->second;
				this->replace_str.insert({name, replace_name});
			} else {
				this->constant_pool.insert({constant, name});
			}
		}
	}
}

void Optimize::reduceTemp(vector<string>& codelist) {
	for (int i = 0; i < codelist.size(); ++i) {
		string str = codelist[i];
		if (str.find("FUNCTION") != string::npos || str.find("CALL") != string::npos) {
			this->codelist.push_back(codelist[i]);
			continue;
		}
		bool assign = (str.find("#") != string::npos);
		bool dup_assign = false;
		regex pattern("t[0-9]+");
		smatch match;
		vector<string> rep;
		string cp = str;
		while (regex_search(cp, match, pattern)) {
			if (assign && this->replace_str.count(match[0])) {
				dup_assign = true;
				break;
			} else if (this->replace_str.count(match[0])) {
				rep.push_back(match[0]);
			}
			cp = match.suffix();
		}
		if (dup_assign)	continue;
		for (string s : rep) {
			regex r(s.c_str());
			auto itr = this->replace_str.find(s);
			str = regex_replace(str, r, itr->second);
		}
		this->codelist.push_back(str);
	}
}

void Optimize::removeUselessVar() {
	map<string, int> time_counter;
	regex pattern("t[0-9]+");
	smatch match;
	for (int i = 0; i < this->codelist.size(); ++i) {
		string str = this->codelist[i];
		string cp = str;
		while (regex_search(cp, match, pattern)) {
			if (time_counter.count(match[0]))	++time_counter[match[0]];
			else	time_counter.insert({match[0], 1});
			cp = match.suffix();
		}
	}
	int i = 0;
	for (vector<string>::iterator it = this->codelist.begin(); it != this->codelist.end(); ++it) {
		string str = this->codelist[i];
		if (regex_search(str, match, pattern)) {
			auto itr = time_counter.find(match[0]);
			if (itr->second == 1)	this->codelist.erase(it);
		}
		++i;
	}
}

vector<string> Optimize::getCodeList() {
	return this->codelist;
}