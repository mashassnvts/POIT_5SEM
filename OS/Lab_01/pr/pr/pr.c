#include <stdio.h>
#include <ctype.h>

int StrType(const char* s) {
    // Проверка на пустую строку
    if (s == NULL || *s == '\0') {
        return 0; // Ошибка
    }

    // Проверка на шестнадцатеричное число
    if (s[0] == '0' && s[1] == 'x') {
        for (int i = 2; s[i] != '\0'; i++) {
            if (!isxdigit(s[i])) {
                return 0; // Ошибка
            }
        }
        return 3; // Шестнадцатеричное число
    }

    // Проверка на двоичное число
    if (s[0] == '0' && s[1] == 'b') {
        for (int i = 2; s[i] != '\0'; i++) {
            if (s[i] != '0' && s[i] != '1') {
                return 0; // Ошибка
            }
        }
        return 4; // Двоичное число
    }

    // Проверка на десятичное число
    int is_digit = 1;
    for (int i = 0; s[i] != '\0'; i++) {
        if (!isdigit(s[i])) {
            is_digit = 0;
            break;
        }
    }
    if (is_digit) {
        return 2; // Десятичное число
    }

    // Проверка на строку букв
    int is_alpha = 1;
    for (int i = 0; s[i] != '\0'; i++) {
        if (!isalpha(s[i])) {
            is_alpha = 0;
            break;
        }
    }
    if (is_alpha) {
        return 1; // Строка букв
    }

    return 0; // Ошибка
}


void TestStrType() {
    // Тесты для традиционного варианта
    assert(StrType("12345") == 2);        // Десятичное число
    assert(StrType("0x1F4") == 3);        // Шестнадцатеричное число
    assert(StrType("0b1011") == 4);       // Двоичное число
    assert(StrType("Hello") == 1);        // Строка букв
    assert(StrType("") == 0);             // Пустая строка
    assert(StrType("12abc") == 0);        // Ошибка

}

int main() {
    TestStrType();
    printf("All tests passed.\n");
    return 0;
}