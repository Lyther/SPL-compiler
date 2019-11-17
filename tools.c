#include <ctype.h>
#include "tools.h"

int strcicmp(const char *a, const char *b) {
    for (;; ++a, ++b) {
        int d = tolower((unsigned char) *a) - tolower((unsigned char) *b);
        if (d != 0 || !*a) {
            return d;
        }
    }
}