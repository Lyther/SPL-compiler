cmake_minimum_required(VERSION 3.12)
project(SPL-compiler)

set(CMAKE_CXX_STANDARD 14)

add_executable(SPL-compiler AST.c parser.c symbol.c tools.c "tools.h" "symbol.h" "uthash.h" "AST.h" "statement.h" "parser.h")