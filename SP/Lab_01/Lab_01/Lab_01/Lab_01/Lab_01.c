#include <stdio.h>


int issalpha(const char s[]) {
    int i = 0;
    while (s[i] != '\0') {
        if (!((s[i] >= 'a' && s[i] <= 'z') || (s[i] >= 'A' && s[i] <= 'Z'))) {
            return 0;
        }
        i++;
    }
    return 1;
}


int isdecimal(const char s[]) {
    int i = 0;
    if (s[i] == '-' || s[i] == '+') i++;
    if (s[i] == '\0') return 0;

    while (s[i] != '\0') {
        if (s[i] < '0' || s[i] > '9') {
            return 0;
        }
        i++;
    }
    return 1;
}


int ishex(const char s[]) {
    int i = 0;
    if (s[i] == '0' && (s[i + 1] == 'x' || s[i + 1] == 'X')) {
        i += 2;
    }
    else {
        return 0;
    }

    if (s[i] == '\0') return 0;

    while (s[i] != '\0') {
        if (!((s[i] >= '0' && s[i] <= '9') ||
            (s[i] >= 'a' && s[i] <= 'f') ||
            (s[i] >= 'A' && s[i] <= 'F'))) {
            return 0;
        }
        i++;
    }
    return 1;
}


int isbinary(const char s[]) {
    int i = 0;
    while (s[i] != '\0') {
        if (s[i] != '0' && s[i] != '1') {
            return 0;
        }
        i++;
    }
    return 1;
}


int isspecial(const char s[]) {
    int i = 0;
    while (s[i] != '\0') {
        if (!((s[i] >= '!' && s[i] <= '/') || (s[i] >= ':' && s[i] <= '@') ||
            (s[i] >= '[' && s[i] <= '`') || (s[i] >= '{' && s[i] <= '~'))) {
            return 0;
        }
        i++;
    }
    return 1;
}



const char* StrType(const char s[]) {
    if (s == NULL || s[0] == '\0') return "empty or NULL";
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
