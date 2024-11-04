#include <iostream>
#include <Windows.h>

int main()
{
	int pid = GetCurrentProcessId();
	HANDLE mutex = OpenMutex(SYNCHRONIZE, FALSE, L"OS06_03");
	printf("OS06_03A");
	for (int i = 1; i <= 90; ++i)
	{
		if (i == 30)
			WaitForSingleObject(mutex, INFINITE);

		else if (i == 60)
			ReleaseMutex(mutex);
		
		printf(" %d)pid = %d\n", i, pid);
		Sleep(100);
	}

	CloseHandle(mutex);

	system("pause");
	return 0;
}