#ifndef YY_YY_SYNTAX_TAB_H_INCLUDED
#define YY_YY_SYNTAX_TAB_H_INCLUDED

#ifndef YYDEBUG
#define YYDEBUG 1
#endif

#if YYDEBUG
extern int yydebug;
#endif

#ifndef YYTOKENTYPE
#define YYTOKENTYPE
enum yytokentype {
    INT = 258,
    FLOAT = 259,
    CHAR = 260,
    TYPE = 261,
    STRUCT = 262,
    IF = 263,
    ELSE = 264,
    WHILE = 265,
    RETURN = 266,
    DOT = 267,
    SEMI = 268,
    COMMA = 269,
    ASSIGN = 270,
    LT = 271,
    GT = 272,
    LE = 273,
    GE = 274,
    NE = 275,
    EQ = 276,
    PLUS = 277,
    MINUS = 278,
    MUL = 279,
    DIV = 280,
    AND = 281,
    OR = 282,
    NOT = 283,
    LP = 284,
    RP = 285,
    LB = 286,
    RB = 287,
    LC = 288,
    RC = 289,
    ID = 290,
    STRING = 291,
    ERR = 292
};
#endif

#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef int YYSTYPE;
#define YYSTYPE_IS_TRIVIAL 1
#define YYSTYPE_IS_DECLARED 1
#endif

extern YYSTYPE yylval;
int yyparse(void);
#endif