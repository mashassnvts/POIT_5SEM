#include <Windows.h>
#include <iostream>

using namespace std;

DWORD pid = NULL;
int check;

void EnterCriticalSectionAsm()
{
    _asm
    {
    CriticalSection:
        lock bts check, 0;
        jc CriticalSection
    }
}


void LeaveCriticalSectionAsm()
{
    _asm lock btr check, 0
}

DWORD WINAPI ChildThread()
{
    DWORD tid = GetCurrentThreadId();
    EnterCriticalSectionAsm();
    for (short i = 1; i < 100; i++)
    {
        cout << i << ") pid = " << pid << " tid: " << tid << endl;
        Sleep(40);
    }
    LeaveCriticalSectionAsm();

    return 0;
}


int main()
{
    pid = GetCurrentProcessId();

    DWORD tid = GetCurrentThreadId();
    DWORD ChildId = NULL;

    HANDLE hChild = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)ChildThread, NULL, 0, &ChildId);


    EnterCriticalSectionAsm();

    for (short i = 1; i < 100; i++)
    {
        cout << i << ") pid = " << pid << " tid: " << tid << endl;
        Sleep(40);
    }

    LeaveCriticalSectionAsm();

    WaitForSingleObject(hChild, INFINITE);
    CloseHandle(hChild);
    return 0;

}