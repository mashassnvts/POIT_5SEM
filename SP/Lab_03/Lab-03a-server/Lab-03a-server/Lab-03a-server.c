#include <stdio.h>
#include <windows.h>
#include <conio.h>
#include <stdlib.h>
#include <string.h>

#pragma warning(disable : 4996)

int main(int argc, char* argv[]) {
    SetConsoleCP(65001);         
    SetConsoleOutputCP(65001);     

    if (argc < 4) {
        fprintf(stderr, "Ошибка: недостаточно аргументов передано\n");
        return 1;
    }

    char mutex_name[20];
    if (argc > 4) {
        strncpy(mutex_name, argv[4], sizeof(mutex_name) - 1);
        mutex_name[sizeof(mutex_name) - 1] = '\0';
    } else {
        if (!GetEnvironmentVariableA("MUTEX_NAME", mutex_name, sizeof(mutex_name))) {
            fprintf(stderr, "Ошибка: MUTEX_NAME не установлен\n");
            return 1;
        }
    }

    HANDLE mutex = CreateMutexA(NULL, FALSE, mutex_name);
    if (mutex == NULL) {
        fprintf(stderr, "Ошибка при создании мьютекса: %d\n", GetLastError());
        return 1;
    }

    int numberOfProcess = atoi(argv[1]);
    int lower_bound = atoi(argv[2]);
    int upper_bound = atoi(argv[3]);
    int range = upper_bound - lower_bound + 1;
    int step = range / numberOfProcess;
    int remainder = range % numberOfProcess;

    HANDLE hWritePipe, hReadPipe;
    if (!CreatePipe(&hReadPipe, &hWritePipe, NULL, 0)) {
        fprintf(stderr, "Создать канал не удалось.\n");
        return GetLastError();
    }

    HANDLE lpHandles[10];
    for (int i = 0; i < numberOfProcess; i++) {
        int local_start = lower_bound + i * step;
        int local_end = local_start + step - 1;
        if (i == numberOfProcess - 1) {
            local_end += remainder; 
        }

        char lpszComLine[100];
        HANDLE hInheritWritePipe;
        if (!DuplicateHandle(GetCurrentProcess(), hWritePipe, GetCurrentProcess(), &hInheritWritePipe, 0, TRUE, DUPLICATE_SAME_ACCESS)) {
            fprintf(stderr, "Дублирование дескриптора не удалось.\n");
            return GetLastError();
        }

        STARTUPINFOA si;
        PROCESS_INFORMATION pi;
        ZeroMemory(&si, sizeof(STARTUPINFOA));
        si.cb = sizeof(STARTUPINFOA);
        si.dwFlags = STARTF_USESTDHANDLES;
        si.hStdOutput = hInheritWritePipe;

        sprintf(lpszComLine, "Lab-03a-client.exe %d %d %s", local_start, local_end, mutex_name);
        printf("%s\n", lpszComLine);

        if (!CreateProcessA(NULL, lpszComLine, NULL, NULL, TRUE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &pi)) {
            fprintf(stderr, "Процесс не создан.\n");
            return GetLastError();
        }
        lpHandles[i] = pi.hProcess;

        CloseHandle(pi.hThread);
        CloseHandle(hInheritWritePipe);
    }

    for (int i = 0; i < numberOfProcess; i++) {
        char nData[250];
        DWORD dwBytesRead;
        if (!ReadFile(hReadPipe, nData, sizeof(nData) - 1, &dwBytesRead, NULL)) {
            fprintf(stderr, "Чтение из канала не удалось.\n");
            return GetLastError();
        }
        nData[dwBytesRead] = '\0';
        printf("Данные, считанные из канала: %s\n", nData);
    }

    WaitForMultipleObjects(numberOfProcess, lpHandles, TRUE, INFINITE);

    printf("Все процессы завершены.\n");

    CloseHandle(hWritePipe);
    CloseHandle(hReadPipe);
    CloseHandle(mutex);
    for (int i = 0; i < numberOfProcess; i++) {
        CloseHandle(lpHandles[i]);
    }
    return 0;
}
