#include <iostream>
#include <Windows.h>
#include "TlHelp32.h"
#include <iomanip>
using namespace std;

int main()
{
	DWORD pid = GetCurrentProcessId();
	HANDLE snapshot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);	
	PROCESSENTRY32 peProcessEntry;						
	peProcessEntry.dwSize = sizeof(PROCESSENTRY32);
	wcout << L"current pid: " << pid << endl;

	try
	{
		if (!Process32First(snapshot, &peProcessEntry))
			throw L"process32First";
		do
		{
			if (peProcessEntry.th32ProcessID == pid)
			wcout << "  ! currently running process !\n";
			wcout << L"name\t\t" << peProcessEntry.szExeFile << "\n";
			wcout << L"pid\t\t" << peProcessEntry.th32ProcessID << "\n";
			wcout << L"parent pid\t" << peProcessEntry.th32ParentProcessID << "\n";
			wcout << L"\n";

		} while (Process32Next(snapshot, &peProcessEntry));
	}
	catch (char* errMessage)
	{
		wcout << L"[eror] " << errMessage;
	}

	system("pause");
	return 0;
}