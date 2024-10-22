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
        printf("�������� ������� ������.pid: %lu\n", pi.dwProcessId);
    }

    _getch();

    if (!TerminateProcess(pi.hProcess, 0)) 
    {
        printf("TerminateProcess �� ������� (%d).\n", GetLastError());
    }
    else {
        printf("�������� ������� ��������.\n");
    }

    printf("������� ����� �������, ����� ��������� ��������� �������� ����� ����������...%d\n", GetProcessId(pi.hProcess));
    _getch();

    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);

    if (GetProcessId(pi.hProcess) == 0) {
        printf("���������� ������, ���������� �������� PID.\n");
    }
    else {
        printf("PID ����� �������� �����������: %lu\n", GetProcessId(pi.hProcess));
    }

    printf("������� ����� ������� ��� ������...\n");
    _getch();
    return 0;
}
