#include <iostream>
#include <windows.h>

#define SECOND 10000000  

using namespace std;

int main()
{
    setlocale(LC_ALL, "rus");
    HANDLE htimer = CreateWaitableTimer(NULL, FALSE, NULL);
    if (htimer == NULL) {
        cerr << "таймер не создался" << endl;
        return 1;
    }

    LARGE_INTEGER li;
    li.QuadPart = -3 * SECOND;  

    DWORD start = GetTickCount(); 
    int iterationCount = 0;  

    while (true) {
        if (!SetWaitableTimer(htimer, &li, 0, NULL, NULL, FALSE)) {
            cerr << "ошибка уставноелния таймера" << endl;
            CloseHandle(htimer);
            return 1;
        }
        DWORD elapsed = (GetTickCount() - start) / 1000; 
        cout << iterationCount << ") время: " << elapsed << " сек" << endl;

        if (elapsed >= 15) {
            cout << "15 секунд прошло" << endl;
            cout << "всего итераций: " << iterationCount << endl;
            break;
        }

        WaitForSingleObject(htimer, INFINITE);
        iterationCount++;
    }

    CloseHandle(htimer); 
    return 0;
}
