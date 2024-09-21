#include <stdio.h>

int issalpha(const char* s) {
    while (*s != '\0') {
        if (!(((*s >= 'a' && *s <= 'z') || (*s >= 'A' && *s <= 'Z')))) {
            return 0;
        }
        s++;
    }
    return 1;
}

int isdecimal(const char* s) {
    if (*s == '-' || *s == '+') s++;

    if (*s == '\0') return 0;

    while (*s != '\0') {
        if (*s < '0' || *s > '9') {
            return 0;
        }
        s++;
    }
    return 1;
}

int ishex(const char* s) {
    if (*s == '0' && (*(s + 1) == 'x' || *(s + 1) == 'X')) {
        s += 2;
    }
    else {
        return 0;
    }

    if (*s == '\0') return 0;

    while (*s != '\0') {
        if (!(((*s >= '0' && *s <= '9') ||
            (*s >= 'a' && *s <= 'f') ||
            (*s >= 'A' && *s <= 'F')))) {
            return 0;
        }
        s++;
    }
    return 1;
}

int isbinary(const char* s) {
    while (*s != '\0') {
        if (*s != '0' && *s != '1') {
            return 0;
        }
        s++;
    }
    return 1;
}

int isspecial(const char* s) {
    while (*s != '\0') {
        if (!(((*s >= '!' && *s <= '/') || (*s >= ':' && *s <= '@') ||
            (*s >= '[' && *s <= '`') || (*s >= '{' && *s <= '~')))) {
            return 0;
        }
        s++;
    }
    return 1;
}


const char* StrType(const char* s) {
    if (issalpha(s)) return "letter";
    if (isdecimal(s)) return "decimal number";
    if (ishex(s)) return "hexadecimal number";
    if (isbinary(s)) return "binary number";
    if (isspecial(s)) return "special characters";
    return "unknown type";
}

int main() {
    const char* tests[] = {
        "masha",
        "123456",
        "0xABC",
        "1010",
        "57dhdj",
        "12.34",
        "0x1G",
        "",
        "!@#$%^&*",
        NULL
    };

    for (int i = 0; tests[i] != NULL; i++) {
        printf("'%s' is %s\n", tests[i], StrType(tests[i]));
    }

    return 0;
}
