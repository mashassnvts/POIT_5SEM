#include  <iostream>;
#include <Windows.h>;

using namespace std;


int main() {

	cout << "OS03_02\n\n";


	LPCWSTR OS03_02_1 = L"D:\\masha\\university\\OS\\Lab_03\\OS03_01\\x64\\Debug\\OS03_02_1.exe";
	LPCWSTR OS03_02_2 = L"D:\\masha\\university\\OS\\Lab_03\\OS03_01\\x64\\Debug\\OS03_02_2.exe";

	STARTUPINFO si1;
	STARTUPINFO si2;

	PROCESS_INFORMATION pi1;
	PROCESS_INFORMATION pi2;

	ZeroMemory(&si1, sizeof(STARTUPINFO));
	ZeroMemory(&si2, sizeof(STARTUPINFO));

	si1.cb = sizeof(STARTUPINFO);
	si1.dwFlags = STARTF_USEFILLATTRIBUTE;
	si1.lpReserved = NULL;

	si2.cb = sizeof(STARTUPINFO);
	si2.dwFlags = STARTF_USEFILLATTRIBUTE;
	si2.lpReserved = NULL;

	if (CreateProcess(
		OS03_02_1, NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si1, &pi1
	))
		cout << "[okok] process OS03_02_01 was created. \n";
	else
		cout << "[okok] process OS03_02_01 was not created. \n";
	
	if (CreateProcess(
		OS03_02_2, NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si2, &pi2
	))
		cout << "[okok] process OS03_02_01 was created. \n";
	else
		cout << "[error] process OS03_02_01 was not created. \n";


	for (short i = 0; i <= 7; ++i) {
		cout << i << ". pid = " << GetCurrentProcessId() << "\n";
		Sleep(1000);
	}

	WaitForSingleObject(pi1.hProcess, INFINITE);
	WaitForSingleObject(pi2.hProcess, INFINITE);

	CloseHandle(pi1.hThread);
	CloseHandle(pi2.hThread);
	CloseHandle(pi1.hProcess);
	CloseHandle(pi2.hProcess);

	return 0;


}

