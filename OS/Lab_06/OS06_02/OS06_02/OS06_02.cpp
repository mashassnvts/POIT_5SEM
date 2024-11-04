#include <iostream>
#include <windows.h>
#include <stdio.h>

using namespace std;

CRITICAL_SECTION cs;

void WINAPI LoopFunction(const char* displayed_name)
{
    int pid = GetCurrentProcessId();
    int tid = GetCurrentThreadId();

    for (int i = 1; i <= 90; ++i)
    {
        if (i == 30)
            EnterCriticalSection(&cs);

        printf("[%s] итерация %d. pid = %d tid = %u\n", displayed_name, i, pid, tid);

        if (i == 60)
            LeaveCriticalSection(&cs);

        Sleep(100); 
    }
}

int main()
{
    setlocale(LC_ALL, "rus");
    InitializeCriticalSection(&cs);

    const int size = 2;
    DWORD ChildId1, ChildId2;
    HANDLE threads[size];

    threads[0] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)LoopFunction, (LPVOID)"A", 0, &ChildId1);
    threads[1] = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)LoopFunction, (LPVOID)"B", 0, &ChildId2);

    LoopFunction("main");

    WaitForMultipleObjects(size, threads, TRUE, INFINITE);

    for (int i = 0; i < size; ++i)
        CloseHandle(threads[i]);

    DeleteCriticalSection(&cs);
    return 0;
}   