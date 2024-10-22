#include <stdio.h>
#include <windows.h>
#include <conio.h> 

int main() {
    SetConsoleOutputCP(1251);
    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    ZeroMemory(&si, sizeof(si));
    ZeroMemory(&pi, sizeof(pi));
    si.cb = sizeof(si);

    if (!CreateProcessA(
        NULL,
        "D:\\masha\\university\\SP\\SP_02\\Lab-02inf\\x64\\Debug\\Lab-02inf.exe",
        NULL, NULL, FALSE, 0, NULL, NULL,
        &si, &pi)) {
        printf("Error creating process Lab-02inf: %d\n", GetLastError());
        return 1;
    }else
    {
        printf("дочерний процесс создан.pid: %lu\n", pi.dwProcessId);
    }

    _getch();

    if (!TerminateProcess(pi.hProcess, 0)) 
    {
        printf("TerminateProcess не удалась (%d).\n", GetLastError());
    }
    else {
        printf("дочерний процесс завершён.\n");
    }

    printf("нажмите любую клавишу, чтобы проверить состояние процесса после завершения...%d\n", GetProcessId(pi.hProcess));
    _getch();

    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);

    if (GetProcessId(pi.hProcess) == 0) {
        printf("дескриптор закрыт, невозможно получить PID.\n");
    }
    else {
        printf("PID после закрытия дескриптора: %lu\n", GetProcessId(pi.hProcess));
    }

    printf("нажмите любую клавишу для выхода...\n");
    _getch();
    return 0;
}
