#include <iostream>
#include <Windows.h>

using namespace std;

int main() {
	DWORD pid = GetCurrentProcessId();
	DWORD tid = GetCurrentThreadId();

	for (int i = 1; i < 20000; i++) {
		Sleep(800);
		cout << i << ") pid = " << pid << ", tid = " << tid << endl;
	}
}
