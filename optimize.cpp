#include "optimize.h"
#include <iostream>
#include <string>
#include <set>
using namespace std;

Optimize::Optimize(vector<string> codelist) {
	establishConstantPool(codelist);
	reduceTemp(codelist);
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
		size_t begin = str.find("t");
		size_t end = str.find(" ");
		bool assign = (str.find("#") != string::npos);
		if (begin != string::npos) {
			string name = str.substr(begin, end-begin);
			if (assign && this->replace_str.count(name)) {
			} else if (!assign && this->replace_str.count(name)) {
				auto itr = this->replace_str.find(name);
				string replace_name = itr->second;
				size_t pos = str.find(name);
				str.replace(pos, name.size(), replace_name);
				this->codelist.push_back(str);
			} else {
				this->codelist.push_back(codelist[i]);
			}
		} else {
			this->codelist.push_back(codelist[i]);
		}
	}
}

vector<string> Optimize::getCodeList() {
	return this->codelist;
}