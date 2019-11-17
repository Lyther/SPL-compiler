#ifndef SYMBOL_H
#define SYMBOL_H

#include "uthash.h"
#include "statement.h"

typedef struct symbol {
    char *name;
    type *t;
    UT_hash_handle hh;
} symbol;

extern symbol *symbols;

void insert_symbol(symbol *sym);

symbol *find_symbol(char *name);

#endif