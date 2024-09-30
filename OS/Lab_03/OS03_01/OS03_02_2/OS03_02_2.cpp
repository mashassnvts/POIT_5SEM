#include <iostream>
#include <Windows.h>
using namespace std;

void main()
{
	cout << "OS03_02_2\n\n";

	for (short i = 1; i <= 12; ++i)
	{
		cout << i << ". pid = " << GetCurrentProcessId() << "\n";
		Sleep(1000);
	}
	system("pause");
}