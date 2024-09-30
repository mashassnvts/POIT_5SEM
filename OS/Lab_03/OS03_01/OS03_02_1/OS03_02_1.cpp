#include <iostream>
#include <Windows.h>
using namespace std;

void main()
{
	cout << "OS03_02_1\n\n";
	for (short i = 1; i <= 10; ++i)
	{
		cout << i << ". pid = " << GetCurrentProcessId() << "\n";
		Sleep(1000);
	}
	system("pause");
}