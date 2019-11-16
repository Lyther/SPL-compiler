cmake_minimum_required(VERSION 3.12)
project(SPL-compiler)

set(CMAKE_CXX_STANDARD 14)

add_executable(SPL-compiler AST.c "AST.h")