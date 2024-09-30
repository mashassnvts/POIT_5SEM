#include <iostream>;
#include <Windows.h>

using namespace std;

void main(){
	for (short i = 1; i <= 1000; ++i) {
		cout << i << ") pid = " << GetCurrentProcessId() << "\n";
		Sleep(1000);
}
}