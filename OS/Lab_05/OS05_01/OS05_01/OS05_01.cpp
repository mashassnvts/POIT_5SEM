#include <iostream>
#include <Windows.h>

using namespace std;

void printBinaryMask(DWORD_PTR mask, int numBits) {
    for (int i = numBits - 1; i >= 0; --i) {
        cout << ((mask & (1ull << i)) ? '1' : '0');
    }
    cout << endl;
}

int main() {
    setlocale(LC_ALL, "rus");

    DWORD pid = GetCurrentProcessId();
    cout << "pid: " << pid << endl;

    DWORD tid = GetCurrentThreadId();
    cout << "tid: " << tid << endl;

    int processPriority = GetPriorityClass(GetCurrentProcess());
    cout << "priority of the current process: " << processPriority << endl;

    int threadPriority = GetThreadPriority(GetCurrentThread());
    cout << "priority of the current thread: " << threadPriority << endl;

    DWORD_PTR processAffinityMask, systemAffinityMask;
    GetProcessAffinityMask(GetCurrentProcess(), &processAffinityMask, &systemAffinityMask);

    int numProcessors = 0;
    for (int i = 0; i < sizeof(DWORD_PTR) * 8; i++) {
        if (processAffinityMask & (1ull << i)) {
            numProcessors++;
        }
    }

    cout << "affinity mask of valid threads of the current processor: ";
    printBinaryMask(processAffinityMask, sizeof(DWORD_PTR) * 8);

    cout << "the number of processors available to the current process: " << numProcessors << endl;


    DWORD_PTR threadAffinityMask = SetThreadAffinityMask(GetCurrentThread(), 1ull << 0);
    cout << "the thread assigned by the current thread: ";
    printBinaryMask(threadAffinityMask, sizeof(DWORD_PTR) * 8);

    return 0;
}
