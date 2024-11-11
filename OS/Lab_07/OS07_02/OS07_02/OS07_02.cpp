#include <iostream>
#include <windows.h>

using namespace std;

int main() {
    setlocale(LC_ALL, "rus");

    int iterationCount = 0;
    DWORD startTime = GetTickCount(); 

    while (true) {
        iterationCount++; 

        DWORD currentTime = GetTickCount();
        DWORD elapsedTime = currentTime - startTime;

        if (elapsedTime >= 5000 && elapsedTime < 10000) {
            cout << "итерации за 5 секунд: " << iterationCount << endl;
            Sleep(5000); 
        }

        if (elapsedTime >= 10000 && elapsedTime < 15000) {
            cout << "итерации за 10 секунд: " << iterationCount << endl;
            Sleep(5000);
        }

        if (elapsedTime >= 15000) {
            cout << "всего итераций: " << iterationCount << endl;
            break;
        }
    }

    return 0;
}
