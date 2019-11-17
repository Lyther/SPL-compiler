#include <stdlib.h>
#include <string.h>
#include "symbol.h"

symbol *symbols = NULL;

void insert_symbol(symbol *sym) {
    HASH_ADD_STR(symbols, name, sym);
}

symbol *find_symbol(char *name) {
    symbol *sym;
    HASH_FIND_STR(symbols, name, sym);
    return sym;
}