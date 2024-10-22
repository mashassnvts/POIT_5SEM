#include <stdio.h>
#include <windows.h>

int main() {
    SetConsoleOutputCP(1251);

    STARTUPINFOA si1, si2, si3;
    PROCESS_INFORMATION pi1, pi2, pi3;

    boolean proc1 = 0, proc2 = 0, proc3 = 0;

    ZeroMemory(&si1, sizeof(si1));
    ZeroMemory(&si2, sizeof(si2));
    ZeroMemory(&si3, sizeof(si3));

    si1.cb = sizeof(si1);
    si2.cb = sizeof(si2);
    si3.cb = sizeof(si3);

    ZeroMemory(&pi1, sizeof(pi1));
    ZeroMemory(&pi2, sizeof(pi2));
    ZeroMemory(&pi3, sizeof(pi3));

    if (proc1 = CreateProcessA("D:\\masha\\university\\SP\\SP_02\\Lab-02x\\x64\\Debug\\Lab-02x.exe",
        NULL,
        NULL, NULL,FALSE, 
        CREATE_NEW_CONSOLE, 
        NULL, NULL,
        &si1, &pi1)) {
        printf("Первый процесс создан\n");
    }
    else {
        printf("Первый процесс не создан, ошибка: %d\n", GetLastError());
    }

    char* cmdLine2 = _strdup("D:\\masha\\university\\SP\\SP_02\\Lab-02x\\x64\\Debug\\Lab-02x.exe 12");
    if (proc2 = CreateProcessA(NULL,
        cmdLine2,
        NULL, NULL,FALSE, 
        CREATE_NEW_CONSOLE, 
        NULL, NULL,
        &si2, &pi2)) {
        printf("Второй процесс создан\n");
    }
    else {
        printf("Второй процесс не создан, ошибка: %d\n", GetLastError());

    }

    const wchar_t* newIterNum = L"14";
    SetEnvironmentVariableW(L"ITER_NUM", newIterNum);

    if (proc3 = CreateProcessA("D:\\masha\\university\\SP\\SP_02\\Lab-02x\\x64\\Debug\\Lab-02x.exe",
        NULL,
        NULL, NULL, FALSE, 
        CREATE_NEW_CONSOLE, 
        NULL, NULL,
        &si3, &pi3)) {
        printf("Третий процесс создан\n");


    }
    else {
        printf("Тртеий процесс не создан, ошибка: %d\n", GetLastError());
    }

    if (proc1) WaitForSingleObject(pi1.hProcess, INFINITE);
    if (proc2) WaitForSingleObject(pi2.hProcess, INFINITE);
    if (proc3) WaitForSingleObject(pi3.hProcess, INFINITE);

    if (proc1) {
        CloseHandle(pi1.hThread);
        CloseHandle(pi1.hProcess);
    }
    if (proc2) {
        CloseHandle(pi2.hThread);
        CloseHandle(pi2.hProcess);
    }
    if (proc3) {
        CloseHandle(pi3.hThread);
        CloseHandle(pi3.hProcess);
    }

    printf("Все процессы успешны.\n");
    system("pause"); 
    return 0;
}
