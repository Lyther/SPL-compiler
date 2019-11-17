# SPL-compiler
 Use Flex and Bison to transfer SPL to syntax tree

Usage:

Makefile:
1. make flex
	Only generate a lexical analyzer, and transfer source code into tokens.
2. make main
	Compile the whole program, generate parser to parse syntax tree.
3. make debug
	Debug mode of usage 2.
4. make clean
	Remove all the files generated by make.

splc:
The result executable file is in ./bin/splc, use one arg to specify 
	target source code, example: ./bin/splc test.spl
Then the syntax tree or tokens would be printed in stdout.

TODO:
1. macro
2. include file
3. else if statment
4. for statment
...