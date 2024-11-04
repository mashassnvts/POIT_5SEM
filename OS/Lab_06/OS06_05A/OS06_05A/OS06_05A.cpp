#include <iostream>
#include <Windows.h>

int main()
{
	int pid = GetCurrentProcessId();
	HANDLE event = OpenEvent(EVENT_ALL_ACCESS, FALSE, L"OS06_05");
	printf("OS06_05A");
	WaitForSingleObject(event, INFINITE);
	SetEvent(event);
	for (int i = 1; i <= 90; i++)
	{
		printf("%d) pid = %d\n", i, pid);
		Sleep(100);
	}

	CloseHandle(event);
	system("pause");
	return 0;
}