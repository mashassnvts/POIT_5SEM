#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#include <math.h>

#pragma warning(disable : 4996)

int number_prime(int n) {
    if (n < 2) return 0;
    if (n == 2) return 1;
    if (n % 2 == 0) return 0;

    for (int i = 3; i * i <= n; i += 2) {
        if (n % i == 0) {
            return 0;
        }
    }
    return 1;
}

void output_primes(int start, int end) {
    char buffer[250];
    int index = 0;

    for (int number = start; number <= end; number++) {
        if (number_prime(number)) {

            int bytesWritten = snprintf(buffer + index, sizeof(buffer) - index, "%d ", number);
            if (bytesWritten < 0) {
                fprintf(stderr, "Ошибка форматирования строки.\n");
                return;
            }
            index += bytesWritten;


            if (index >= sizeof(buffer) - 20) {
                DWORD dwBytesWritten;
                WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), buffer, index, &dwBytesWritten, NULL);
                index = 0;
            }
        }
    }

    if (index > 0) {
        buffer[index - 1] = '\0';
        DWORD dwBytesWritten;
        WriteFile(GetStdHandle(STD_OUTPUT_HANDLE), buffer, index - 1, &dwBytesWritten, NULL);
    }
}

HANDLE initialize_mutex(char* mutex_name) {
    HANDLE mutex_handle = OpenMutexA(SYNCHRONIZE, FALSE, mutex_name);
    return mutex_handle;
}

int main(int argc, char* argv[]) {
    SetConsoleCP(65001);
    SetConsoleOutputCP(65001);

    system("chcp 65001");

    if (argc < 3) {
        fprintf(stderr, "Ошибка: недостаточно аргументов.\n");
        return 1;
    }

    int lower_bound = atoi(argv[1]);
    int upper_bound = atoi(argv[2]);

    if (lower_bound > upper_bound) {
        fprintf(stderr, "Неверный диапазон.\n");
        return 1;
    }

    char mutex_name[20];
    if (argc > 3) {
        strncpy(mutex_name, argv[3], sizeof(mutex_name) - 1);
        mutex_name[sizeof(mutex_name) - 1] = '\0';
    }
    else if (!GetEnvironmentVariableA("MUTEX_NAME", mutex_name, sizeof(mutex_name))) {
        fprintf(stderr, "Ошибка получения имени мьютекса.\n");
        return 1;
    }

    HANDLE hMutex = initialize_mutex(mutex_name);
    WaitForSingleObject(hMutex, INFINITE);

    output_primes(lower_bound, upper_bound);

    ReleaseMutex(hMutex);
    CloseHandle(hMutex);

    printf("Press any key to exit...\n");
    getch();

    return 0;
}
