#include <iostream>
#include <Windows.h>

using namespace std; 

DWORD OS04_02_T1() {
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();

	for (int i = 1; i <= 50; i++) {
		Sleep(1000);
		cout << i << ") pidT1 = " << pid << ", tidT1 = " << tid << endl;
	}

	return 0;
}

DWORD OS04_02_T2() {
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();

	for (int i = 1; i <= 125; i++) {
		Sleep(1000);
		cout << i << ") pidT2 = " << pid << ", tidT2 = " << tid << endl;
	}

	return 0;
}

void main() {
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();


	DWORD T1_CHILD = NULL;
	DWORD T2_CHILD = NULL;

	HANDLE HCHILDT1 = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)OS04_02_T1, NULL, 0, &T1_CHILD);
	HANDLE HCHILDT2 = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)OS04_02_T2, NULL, 0, &T1_CHILD);

	for (int i = 1; i <= 100; i++) {
		Sleep(1000);
		cout << i << ") pid parent = " << pid << ", tid = " << tid << endl;
	}

	WaitForSingleObject(HCHILDT1, INFINITE);
	WaitForSingleObject(HCHILDT2, INFINITE);

	CloseHandle(HCHILDT1);
	CloseHandle(HCHILDT2);
}