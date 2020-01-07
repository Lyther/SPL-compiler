# SPL-compiler

Current version is a large reconstitution. I rebuild the target program with C++ instead of standard C, and remove some useless files from project.

Already finished part:
* Lexeme analysis
* Parsing tree build
* Syntax analysis
* Intermediate code generation
* Intermediate code optimization
* MIPS machine code generation

Now, the output file is the IR code in test/ folder.

If you want to print parsing tree, remove the comment of `eval()` in `syntax.y` file.

----

## Usage

Simply run `make splc` can build the target program in bin/splc output executable program.

Use `./bin/splc <input .spl file>` to generate IR code for source .sql code.

The output .ir file would have the same name as the .sql code, and in the same folder, as well.

If you've finished the intermediate part, you can then generate MIPS machine code using machine code generator provided in mips/ folder. The usage would be very similar to previous steps, simply run `make splc` and then use `./bin/splc <input .ir file>` would be fine.

## Requirements

To compile splc program, you need:
* Lex or Flex
* Yacc or Bison
* G++ at least support C++ 11 standard
* Python version 3

## Appendix

If you find any bugs or problems in my code, please raise an issue to inform me.