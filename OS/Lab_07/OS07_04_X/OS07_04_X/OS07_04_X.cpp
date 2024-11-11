#include <iostream>
#include <windows.h>
#include <ctime>

using namespace std;

bool isPrime(int num) {
    if (num <= 1) return false;
    for (int i = 2; i * i <= num; i++) {
        if (num % i == 0) return false;
    }
    return true;
}

int main(int argc, char* argv[]) {
    setlocale(LC_ALL, "rus");
    if (argc != 2) {
        cerr << "дургое количество агрументов должнло быть" << endl;
        return 1;
    }

    int duration = atoi(argv[1]);  
    DWORD startTime = GetTickCount();

    int count = 0;
    for (int num = 2; ; num++) {
        if (isPrime(num)) {
            cout << "число " << ++count << ": " << num << endl;
        }
        if ((GetTickCount() - startTime) / 1000 >= duration * 60) {
            cout << "процесс завершен через " << duration << " минут(ы)." << endl;
            break;
        }
    }

    return 0;
}
