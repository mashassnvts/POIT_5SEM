#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define MAX_NUMBERS 1024
#define BUFFER_SIZE 4096

char primesGlobal[BUFFER_SIZE] = { 0 };
int primesCount = 0;

pthread_mutex_t cs;
pthread_once_t initOnce = PTHREAD_ONCE_INIT;

typedef struct {
    int start;
    int end;
} Range;

int compare(const void* a, const void* b);

void HandleError(const char* message) {
    perror(message);
    exit(1);
}

void InitMutex() {
    if (pthread_mutex_init(&cs, NULL) != 0) {
        HandleError("Failed to initialize mutex");
    }
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

void* L4Thread(void* param) {
    Range* range = (Range*)param;

    char localPrimes[BUFFER_SIZE] = { 0 };
    int localCount = 0;

    // ќбработка диапазона
    for (int i = range->start; i <= range->end; i++) {
        if (CheckPrime(i)) {
            localCount += snprintf(localPrimes + localCount, BUFFER_SIZE - localCount, "%d ", i);
        }
    }
    //мьютекс будет инициализирован только один раз
    pthread_once(&initOnce, InitMutex);

    pthread_mutex_lock(&cs);
    printf("Thread processing range %d to %d\n", range->start, range->end);
    pthread_mutex_unlock(&cs);

    pthread_mutex_lock(&cs);
    printf("Thread found primes: %s\n", localPrimes);

    if (primesCount + localCount < BUFFER_SIZE) {
        strcat(primesGlobal, localPrimes);
        primesCount += localCount;
    }
    else {
        printf("Global buffer overflow, can't add primes\n");
    }
    
    sleep(10);
    pthread_mutex_unlock(&cs);

   
    free(range);
    return NULL;
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

    pthread_t* threads = (pthread_t*)malloc(numberOfThreads * sizeof(pthread_t));

    int range = end - start + 1;
    int step = range / numberOfThreads;

    for (int i = 0; i < numberOfThreads; i++) {
        int localStart = start + i * step;
        int localEnd = (i == numberOfThreads - 1) ? end : localStart + step - 1;

        Range* params = (Range*)malloc(sizeof(Range));
        params->start = localStart;
        params->end = localEnd;

        int ret = pthread_create(&threads[i], NULL, L4Thread, params);
        if (ret != 0) {
            HandleError("pthread_create error");
        }
        printf("Thread %d created to process range %d to %d\n", i + 1, localStart, localEnd);
    }

    for (int i = 0; i < numberOfThreads; i++) {
        pthread_join(threads[i], NULL);
    }

    free(threads);

    sortprimesGlobal();
    printf("\nSorted primes:\n%s\n", primesGlobal);

    // ”ничтожаем мьютекс перед завершением
    pthread_mutex_destroy(&cs);

    return 0;
}
