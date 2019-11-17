#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "parser.h"
#include "statement.h"
#include "symbol.h"
#include "tools.h"

void parser_program(node *root) {
    parser_ext_def_list(root->t1);
}

void parser_ext_def_list(node *root) {
    if (root == NULL || strcicmp(root->type, "Empty") == 0) {
        return;
    } else if (strcicmp(root->t1->type, "ExtDef") == 0) {
        node *ext_def = root->t1;
        parser_ext_def(ext_def);
        parser_ext_def_list(root->t2);
    }
}

void parser_ext_def(node *root) {
    node *specifier = root->t1;
    if (specifier == NULL || root->t2 == NULL) {
        return;
    }
    type *t = parser_specifier(specifier);

    node *second = root->t2;
    if (second == NULL) {
        return;
    }
    if (strcicmp(second->type, "ExtDecList") == 0) {
        node *ext_def_list = second;
        parser_ext_dec_list(ext_def_list, t);
    } else if (strcicmp(second->type, "FunDec") == 0) {
        node *fun_dec = second;
        node *comp_st = root->t3;
        type *fun_t = parser_fun_dec(fun_dec, t);
        if (fun_t != NULL) {
            char *name = fun_t->stmt->name;
            symbol *sym = find_symbol(name);
            if (sym != NULL) {
                parser_error(fun_dec, 4, "function is redefined");
            } else {
                sym = (symbol *) malloc(sizeof(symbol));
                char *buffer = (char *) malloc(sizeof(char) * strlen(name));
                strcpy(buffer, name);
                sym->name = buffer;
                sym->t = t;
                insert_symbol(sym);
                parser_comp_st(comp_st, t);
            }
        }
    } else if (strcicmp(second->type, "SEMI") == 0) {
        return;
    }
}

void parser_comp_st(node *root, type *t) {
    parser_def_list(root->t2, NULL);
    parser_stmt_list(root->t3, t);
}

void parser_stmt_list(node *root, type *t) {
    if (root == NULL) {
        return;
    } else if (root->t1 != NULL) {
        parser_stmt(root->t1, t);
        parser_stmt_list(root->t2, t);
    }
}

void parser_stmt(node *root, type *t) {
    if (root->t1 == NULL) {
        return;
    }
    if (strcicmp(root->t1->type, "Exp") == 0) {
        parser_exp(root->t1);
    } else if (strcicmp(root->t1->type, "CompSt") == 0) {
        parser_comp_st(root->t1, t);
    } else if (strcicmp(root->t1->type, "RETURN") == 0) {
        node *exp = root->t2;
        type *exp_t = parser_exp(exp);
        if (exp_t != NULL && !parser_same(t, exp_t)) {
            parser_error(root->t1, 8, "the function's return value type mismatches the declared type");
        }
    } else if (strcicmp(root->t1->type, "IF") == 0) {
        node *exp = root->t3;
        type *exp_t = parser_exp(exp);
        if (exp_t != NULL) {
            if (!(exp_t->is_val && strcicmp(exp_t->t, "int") == 0)) {
                parser_error(exp, 7, "unmatching operands");
            } else {
                parser_stmt(root->t5, t);
                if (root->t6 != NULL) {
                    parser_stmt(root->t7, t);
                }
            }
        }
    } else if (strcicmp(root->t1->type, "WHILE") == 0) {
        node *exp = root->t3;
        type *exp_t = parser_exp(exp);
        if (exp_t != NULL) {
            if (!(exp_t->is_val && strcicmp(exp_t->t, "int") == 0)) {
                parser_error(exp, 7, "unmatching operands");
            } else {
                parser_stmt(root->t5, t);
            }
        }
    }
}

void parser_ext_dec_list(node *root, type *t) {
    parser_var_dec(root->t1, t);
    if (root->t2 != NULL) {
        parser_ext_dec_list(root->t3, t);
    }
}

type *parser_specifier(node *specifier) {
    type *t = (type *) malloc(sizeof(type));
    node *second = specifier->t1;
    if (strcicmp(second->type, "TYPE") == 0) {
        t->is_val = 1;
        if (second->value != NULL) {
            t->t = second->value;
        }
    } else if (strcicmp(second->type, "StructSpecifier") == 0) {
        node *id = second->t2;
        char *name = id->value;
        symbol *sym = find_symbol(name);
        if (second->t3 != NULL) {
            if (sym != NULL) {
                parser_error(id, 15, "redefine the same structure type");
                return NULL;
            }
            node *def_list = second->t4;
            t = (type *) malloc(sizeof(type));
            t->is_struct = 1;
            t->stmt = parser_def_list(def_list, NULL);

            sym = (symbol *) malloc(sizeof(symbol));
            char *buffer = (char *) malloc(sizeof(char) * strlen(name));
            strcpy(buffer, name);
            sym->name = buffer;
            sym->t = t;
            insert_symbol(sym);
        } else {
            if (sym == NULL) {
                parser_error(id, 16, "struct is used without definition");
                return NULL;
            } else if (sym->t->is_struct == 0) {
                parser_error(id, 17, "is not a struct");
                return NULL;
            }
            t = sym->t;
        }
    }
    return t;
}

type *parser_exp(node *root) {
    type *t = (type *) malloc(sizeof(type));
    if (strcicmp(root->t1->type, "Exp") == 0) {
        if (strcicmp(root->t2->type, "ASSIGN") == 0) {
            node *exp1 = root->t1;
            node *exp2 = root->t3;
            type *exp1_t = parser_exp(exp1);
            type *exp2_t = parser_exp(exp2);
            if (!((strcicmp(exp1->t1->type, "ID") == 0 && exp1->t2 == NULL) ||
                  (strcicmp(exp1->t1->type, "Exp") == 0 && strcicmp(exp1->t2->type, "DOT") == 0) ||
                  (strcicmp(exp1->t1->type, "Exp") == 0 && strcicmp(exp1->t2->type, "LB") == 0))) {
                parser_error(root->t1, 6, "rvalue on the left side of assignment operator");
            } else if (!parser_same(exp1_t, exp2_t)) {
                parser_error(root->t1, 5, "unmatching types on both sides of assignment operator");
            } else {
                t = exp1_t;
            }
        } else if (strcicmp(root->t2->type, "AND") == 0 || strcicmp(root->t2->type, "OR") == 0) {
            node *exp1 = root->t1;
            node *exp2 = root->t3;
            type *exp1_t = parser_exp(exp1);
            type *exp2_t = parser_exp(exp2);
            if (!parser_same(exp1_t, exp2_t) && exp1_t->is_val && strcicmp(exp1_t->t, "int") == 0) {
                parser_error(root->t1, 7, "unmatching operands");
            } else {
                t = exp1_t;
            }
        } else if (strcicmp(root->t1->type, "LT") == 0 ||
                   strcicmp(root->t1->type, "LE") == 0 ||
                   strcicmp(root->t1->type, "GT") == 0 ||
                   strcicmp(root->t1->type, "GE") == 0 ||
                   strcicmp(root->t1->type, "NE") == 0 ||
                   strcicmp(root->t1->type, "EQ") == 0 ||
                   strcicmp(root->t1->type, "PLUS") == 0 ||
                   strcicmp(root->t1->type, "MINUS") == 0 ||
                   strcicmp(root->t1->type, "MUL") == 0 ||
                   strcicmp(root->t1->type, "DIV") == 0) {
            node *exp1 = root->t1;
            node *exp2 = root->t3;
            type *exp1_t = parser_exp(exp1);
            type *exp2_t = parser_exp(exp2);
            if (!parser_same(exp1_t, exp2_t) && exp1_t->is_val &&
                (strcicmp(exp1_t->t, "int") == 0 || strcicmp(exp1_t->t, "float") == 0)) {
                parser_error(root->t1, 7, "unmatching operands");
            } else {
                t = exp1_t;
            }
        } else if (strcicmp(root->t2->type, "LB") == 0) {
            node *exp1 = root->t1;
            node *exp2 = root->t3;
            type *exp1_t = parser_exp(exp1);
            type *exp2_t = parser_exp(exp2);
            if (exp1_t->is_array == 0) {
                parser_error(root->t1, 10, "applying indexing operator on non-array type variables");
            } else if (!(exp2_t->is_val && strcicmp(exp2_t->t, "int") == 0)) {
                parser_error(root->t1, 12, "array indexing with non-integer type expression");
            } else {
                t = exp1_t->arr->base;
            }
        } else if (strcicmp(root->t2->type, "DOT") == 0) {
            node *exp1 = root->t1;
            type *exp1_t = parser_exp(exp1);
            node *exp3 = root->t3;
            if (exp1_t->is_struct == 0) {
                parser_error(root->t1, 13, "acessing member of non-structure variable");
            } else {
                statement *stmt;
                for (stmt = exp1_t->stmt; stmt != NULL; stmt = stmt->next) {
                    if (strcicmp(stmt->name, exp3->value) == 0) {
                        break;
                    }
                }
                if (stmt == NULL) {
                    parser_error(exp3, 14, "accessing an undefined structure member");
                } else {
                    t = stmt->t;
                }
            }
        }
    } else if (strcicmp(root->t1->type, "LP") == 0) {
        t = parser_exp(root->t2);
    } else if (strcicmp(root->t1->type, "MINUS") == 0) {
        type *exp_t = parser_exp(root->t2);
        if (exp_t->is_val == 0) {
            parser_error(root->t1, 7, "unmatching operands");
        } else {
            t = exp_t;
        }
    } else if (strcicmp(root->t1->type, "NOT") == 0) {
        type *exp_t = parser_exp(root->t2);
        if (!(exp_t->is_val && strcicmp(exp_t->t, "int") == 0)) {
            parser_error(root->t1, 7, "unmatching operands");
        } else {
            t->is_val = 1;
            t->t = "int";
        }
    } else if (strcicmp(root->t1->type, "ID") == 0) {
        symbol *sym = find_symbol(root->t1->value);
        if (root->t2 != NULL) {
            if (sym == NULL) {
                parser_error(root->t1, 2, "function invoked without definition");
                return NULL;
            } else if (sym->t->is_fun == 0) {
                parser_error(root->t1, 11, "applying function invocation operator on non-function names");
                return NULL;
            }
            type *fun_t = sym->t;
            if (strcicmp(root->t3->type, "Args") == 0) {
                node *args = root->t3;
                statement *args_t = fun_t->stmt->next;
                if (args_t == NULL) {
                    parser_error(root->t1, 9, "the function's arguments mismatch the declared parameters");
                } else {
                    node *exp = args->t1;
                    while (1) {
                        type *exp_t = parser_exp(exp);
                        if (exp_t != NULL) {
                            if (!parser_same(exp_t, args_t->t)) {
                                parser_error(root->t1, 9, "the function's arguments mismatch the declared parameters");
                                break;
                            } else {
                                args_t = args_t->next;
                                if (args_t == NULL && args->t2 == NULL) {
                                    t = fun_t->stmt->t;
                                    break;
                                } else if (args_t != NULL && args->t2 == NULL) {
                                    parser_error(root->t1, 9,
                                                 "the function's arguments mismatch the declared parameters");
                                    break;
                                } else if (args_t == NULL && args->t2 != NULL) {
                                    parser_error(root->t1, 9,
                                                 "the function's arguments mismatch the declared parameters");
                                    break;
                                }
                                args = args->t3;
                                exp = args->t1;
                            }
                        }
                    }
                }
            } else {
                if (fun_t->stmt->next == NULL) {
                    t = fun_t->stmt->t;
                } else {
                    parser_error(root->t1, 9, "the function's arguments mismatch the declared parameters");
                }
            }
        } else {
            if (sym == NULL) {
                parser_error(root->t1, 1, "variable is used without definition");
            } else {
                t = sym->t;
            }
        }
    } else if (strcicmp(root->t1->type, "int") == 0) {
        t->is_val = 1;
        t->t = "int";
    } else if (strcicmp(root->t1->type, "float") == 0) {
        t->is_val = 1;
        t->t = "float";
    } else if (strcicmp(root->t1->type, "char") == 0) {
        t->is_val = 1;
        t->t = "char";
    }
    return t;
}

type *parser_fun_dec(node *root, type *t) {
    type *lt = (type *) malloc(sizeof(type));
    lt->stmt = (statement *) malloc(sizeof(statement));
    lt->is_fun = 1;
    lt->stmt->name = root->t1->value;
    lt->stmt->t = t;
    statement *stmt = lt->stmt;
    if (strcicmp(root->t3->type, "RP") == 0) {
        stmt->next = NULL;
    } else {
        parser_var_list(root->t3, stmt);
    }
    return lt;
}

statement *parser_def_list(node *root, statement *stmt) {
    if (root == NULL || strcicmp(root->type, "Empty") == 0) {
        return stmt;
    }
    node *def = root->t1;
    if (stmt == NULL) {
        stmt = parser_def(def, stmt);
    } else {
        stmt->next = parser_def(def, stmt);
    }
    parser_def_list(root->t2, stmt);
    return stmt;
}

statement *parser_def(node *root, statement *stmt) {
    node *specifier = root->t1;
    node *dec_list = root->t2;
    type *t = parser_specifier(specifier);
    stmt = parser_dec_list(dec_list, stmt, t);
    return stmt;
}

statement *parser_dec_list(node *root, statement *stmt, type *t) {
    node *dec = root->t1;
    stmt = parser_dec(dec, t);
    if (root->t2 != NULL) {
        stmt = parser_dec_list(root->t3, stmt, t);
    }
    return stmt;
}

statement *parser_dec(node *root, type *t) {
    node *var_dec = root->t1;
    statement *var_dec_stmt = parser_var_dec(var_dec, t);
    if (root->t2 != NULL) {
        node *exp = root->t3;
        type *exp_type = parser_exp(exp);
        if (!parser_same(t, exp_type)) {
            parser_error(var_dec, 5, "unmatching types on both sides of assignment operator");
        }
    }
    return var_dec_stmt;
}

statement *parser_var_dec(node *root, type *t) {
    node *second = root->t1;
    type *lt = t;
    statement *result = (statement *) malloc(sizeof(statement));
    node *next;
    while (strcicmp(second->type, "VarDec") == 0) {
        type *cache = (type *) malloc(sizeof(type));
        cache->arr = (array *) malloc(sizeof(array));
        cache->is_array = 1;
        next = root->t3;
        cache->arr->length = strtol(next->value, NULL, 10);
        cache->arr->base = lt;
        lt = cache;
        second = second->t1;
    }
    result->name = second->value;
    result->t = lt;
    symbol *sym = find_symbol(result->name);
    if (sym != NULL) {
        parser_error(second, 3, "variable is redefined in the same scope");
    }
    sym = (symbol *) malloc(sizeof(symbol));
    char *buffer = (char *) malloc(sizeof(char) * strlen(result->name));
    strcpy(buffer, result->name);
    sym->name = buffer;
    sym->t = result->t;
    insert_symbol(sym);
    return result;
}

statement *parser_var_list(node *root, statement *stmt) {
    node *param_dec = root->t1;
    stmt = parser_param_dec(param_dec, stmt);
    if (root->t2 != NULL) {
        stmt = parser_var_list(root->t3, stmt);
    }
    return stmt;
}

statement *parser_param_dec(node *root, statement *stmt) {
    type *t = parser_specifier(root->t1);
    if (t != NULL) {
        statement *cache = parser_var_dec(root->t2, t);
        stmt->next = cache;
        stmt = cache;
    }
    return stmt;
}

int parser_same(type *t1, type *t2) {
    if (t1 == NULL || t2 == NULL || t1->t == NULL || t2->t == NULL) {
        return 0;
    } else if (t1->is_val && strcicmp(t1->t, t2->t) == 0) {
        return 1;
    } else if (t1->is_array && parser_same(t1->arr->base, t2->arr->base) && t1->arr->length == t2->arr->length) {
        return 1;
    } else if (t1->is_struct || t1->is_fun) {
        statement *stmt1 = t1->stmt;
        statement *stmt2 = t2->stmt;
        for (; stmt1 != NULL && stmt2 != NULL; stmt1 = stmt1->next, stmt2 = stmt2->next) {
            if (!parser_same(stmt1->t, stmt2->t)) {
                return 0;
            }
        }
        return stmt1 != NULL || stmt2 != NULL ? 0 : 1;
    } else {
        return 0;
    }
}

void parser_error(node *root, int type, char *message) {
    printf("Error type %d at Line %d: %s\n", type, root->line, message);
}