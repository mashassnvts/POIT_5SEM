#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <conio.h>
#pragma warning(disable : 4996)

CRITICAL_SECTION cs;
DWORD dwTlsIndex;

#define MAX_NUMBERS 1024
#define BUFFER_SIZE 4096

char primesGlobal[BUFFER_SIZE] = { 0 };
int primesCount = 0;

typedef struct {
    int start;
    int end;
} Range;

int compare(const void* a, const void* b);

VOID HandleError(LPCSTR message) {
    fprintf(stderr, "%s\n", message);
    ExitProcess(0);
}

int CheckPrime(int num) {
    if (num < 2) return 0;
    for (int i = 2; i * i <= num; i++) {
        if (num % i == 0) {
            return 0;
        }
    }
    return 1;
}
DWORD WINAPI L4Thread(LPVOID lpParam) {
    Range* range = (Range*)lpParam;

    char* localPrimes = (char*)LocalAlloc(LPTR, BUFFER_SIZE);
    if (localPrimes == NULL) {
        HandleError("LocalAlloc failed");
    }

    if (!TlsSetValue(dwTlsIndex, localPrimes)) {
        HandleError("TlsSetValue error");
    }

    int localCount = 0;
    for (int i = range->start; i <= range->end; i++) {
        if (CheckPrime(i)) {
            localCount += snprintf(localPrimes + localCount, BUFFER_SIZE - localCount, "%d ", i);
        }
    }

    EnterCriticalSection(&cs);
    printf("Thread %lu processing range %d to %d\n", GetCurrentThreadId(), range->start, range->end);
    LeaveCriticalSection(&cs);

    EnterCriticalSection(&cs);
    char* tlsBuffer = (char*)TlsGetValue(dwTlsIndex);
    if (tlsBuffer == NULL) {
        HandleError("TlsGetValue error");
    }
    printf("Thread %lu found primes: %s\n", GetCurrentThreadId(), tlsBuffer);

    if (primesCount + localCount < BUFFER_SIZE) {
        strcat(primesGlobal, tlsBuffer);
        primesCount += localCount;
    }
    else {
        printf("Global buffer overflow, can't add primes\n");
    }
    LeaveCriticalSection(&cs);
    LocalFree(localPrimes);
    free(range);
    system("pause");
    return 0;
}

int compare(const void* a, const void* b) {
    return (*(int*)a - *(int*)b);
}

void sortprimesGlobal() {
    int numbers[MAX_NUMBERS];
    int numCount = 0;

    char* token = strtok(primesGlobal, " ");
    while (token != NULL && numCount < MAX_NUMBERS) {
        numbers[numCount++] = atoi(token);
        token = strtok(NULL, " ");
    }

    qsort(numbers, numCount, sizeof(int), compare);

    primesGlobal[0] = '\0';
    for (int i = 0; i < numCount; i++) {
        char temp[16];
        snprintf(temp, sizeof(temp), "%d ", numbers[i]);
        strcat(primesGlobal, temp);
    }
}

int main(int argc, char* argv[]) {
    if (argc < 4) {
        fprintf(stderr, "Usage: %s <number of threads> <start> <end>\n", argv[0]);
        return 1;
    }

    int numberOfThreads = atoi(argv[1]);
    int start = atoi(argv[2]);
    int end = atoi(argv[3]);

    if (numberOfThreads <= 0 || start > end) {
        fprintf(stderr, "Invalid input parameters.\n");
        return 1;
    }

    InitializeCriticalSection(&cs);

    if ((dwTlsIndex = TlsAlloc()) == TLS_OUT_OF_INDEXES) {
        HandleError("TlsAlloc failed");
    }

    int range = end - start + 1;
    int step = range / numberOfThreads;

    HANDLE* threads = (HANDLE*)malloc(numberOfThreads * sizeof(HANDLE));
    for (int i = 0; i < numberOfThreads; i++) {
        int localStart = start + i * step;
        int localEnd = (i == numberOfThreads - 1) ? end : localStart + step - 1;

        // Выделение памяти для структуры, передаваемой в поток
        Range* params = (Range*)malloc(sizeof(Range));
        params->start = localStart;
        params->end = localEnd;

        threads[i] = CreateThread(
            NULL,
            0,
            L4Thread,
            params,
            0,
            NULL
        );

        if (threads[i] == NULL) {
            HandleError("CreateThread error\n");
        }

        printf("Thread %d created to process range %d to %d\n", i + 1, localStart, localEnd);
    }

    WaitForMultipleObjects(numberOfThreads, threads, TRUE, INFINITE);

    for (int i = 0; i < numberOfThreads; i++) {
        CloseHandle(threads[i]);
    }


    free(threads);
    TlsFree(dwTlsIndex);
    DeleteCriticalSection(&cs);

    sortprimesGlobal();
    printf("\nSorted primes:\n%s\n", primesGlobal);

    return 0;
}
