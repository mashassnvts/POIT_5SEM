#include <stdio.h>
#include <windows.h>

int main() {
    SetConsoleOutputCP(1251);
    printf("Lab-02inf запущен\n");
    while (1) {
        Sleep(1000); 
        printf("Hello, my dear friend!\n");
    }
    return 0;
}
