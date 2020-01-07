#include <bits/stdc++.h>

using namespace std;

char buffer[50] = {0}, output[80] = {0};
string command = "python3 generate.py ";

int main(int argc, char *argv[]) {
    ios::sync_with_stdio(false);
    if (argc != 2) {
        cout << "Usage: ./bin/splc <ir_file>" << endl;
    } else {
        memcpy(buffer, argv[1], strlen(argv[1]) - 3);
        strcat(output, buffer);
        strcat(output, ".s");
        cout << "Output to " << output << endl;
    }
    command = command + argv[1] + " " + output;
    system(command.c_str());
    return 0;
}
