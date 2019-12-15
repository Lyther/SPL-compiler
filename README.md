# SPL-compiler

Current version is a large reconstitution. I rebuild the target program with C++ instead of standard C, and remove some useless files from project.

Already finished part:
* Lexeme analysis
* Parsing tree build
* Syntax analysis
* Intermediate code generation
* Intermediate code optimization

Now, the output file is the IR code in test/ folder.

If you want to print parsing tree, remove the comment of `eval()` in `syntax.y` file.

----

## Usage

Simply run `make splc` can build the target program in bin/splc output executable program.

Use `./bin/splc <input .spl file>` to generate IR code for source .sql code.

The output .ir file would have the same name as the .sql code, and in the same folder, as well.

## Requirements

To compile splc program, you need:
* Lex or Flex
* Yacc or Bison
* G++ at least support C++ 11 standard

## Appendix

If you find any bugs or problems in my code, please raise an issue to inform me.