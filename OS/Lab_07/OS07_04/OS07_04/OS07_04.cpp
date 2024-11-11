#include <Windows.h>
#include <iostream>
#include <ctime>

using namespace std;

int main() {
    setlocale(LC_ALL, "rus");
    DWORD pid = GetCurrentProcessId();
    cout << "pid:  " << pid << '\n';

    LPCWSTR path = L"D:\\masha\\university\\OS\\Lab_07\\OS07_04_X\\x64\\Debug\\OS07_04_X.exe";
    PROCESS_INFORMATION pi1, pi2;
    STARTUPINFO si;
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);

    if (CreateProcess(path, (LPWSTR)L" 1", NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &pi1)) {
        cout << "OS07_04_X №1 - 1 минута\n";
    }
    else {
        cerr << "ошибка OS07_04_X №1\n";
        return 1;
    }

    if (CreateProcess(path, (LPWSTR)L" 2", NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &pi2)) {
        cout << "OS07_04_X №2 - 2 минуты\n";
    }
    else {
        cerr << "ошибка OS07_04_X №2\n";
        CloseHandle(pi1.hProcess);
        CloseHandle(pi1.hThread);
        return 1;
    }

    WaitForSingleObject(pi1.hProcess, INFINITE);
    WaitForSingleObject(pi2.hProcess, INFINITE);

    CloseHandle(pi1.hProcess);
    CloseHandle(pi1.hThread);
    CloseHandle(pi2.hProcess);
    CloseHandle(pi2.hThread);

    cout << "конец\n";
    return 0;
}
