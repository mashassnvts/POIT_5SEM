#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_NUMBERS 1024
#define BUFFER_SIZE 4096

char primesGlobal[BUFFER_SIZE] = { 0 };
int primesCount = 0;

pthread_mutex_t cs;  // Мьютекс для синхронизации
__thread char localPrimes[BUFFER_SIZE];  // Локальные данные потока

typedef struct {
    int start;
    int end;
} Range;

int compare(const void* a, const void* b);

void HandleError(const char* message) {
    fprintf(stderr, "%s\n", message);
    exit(1);
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

void* L4Thread(void* lpParam) {
    Range* range = (Range*)lpParam;

    int localCount = 0;
    for (int i = range->start; i <= range->end; i++) {
        if (CheckPrime(i)) {
            localCount += snprintf(localPrimes + localCount, BUFFER_SIZE - localCount, "%d ", i);
        }
    }

    pthread_mutex_lock(&cs);
    printf("Thread %lu processing range %d to %d\n", pthread_self(), range->start, range->end);
    pthread_mutex_unlock(&cs);

    pthread_mutex_lock(&cs);
    printf("Thread %lu found primes: %s\n", pthread_self(), localPrimes);

    if (primesCount + localCount < BUFFER_SIZE) {
        strcat(primesGlobal, localPrimes);
        primesCount += localCount;
    }
    else {
        printf("Global buffer overflow, can't add primes\n");
    }
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

    // Инициализация мьютекса
    if (pthread_mutex_init(&cs, NULL) != 0) {
        HandleError("Mutex initialization failed");
    }

    int range = end - start + 1;
    int step = range / numberOfThreads;

    pthread_t* threads = (pthread_t*)malloc(numberOfThreads * sizeof(pthread_t));
    for (int i = 0; i < numberOfThreads; i++) {
        int localStart = start + i * step;
        int localEnd = (i == numberOfThreads - 1) ? end : localStart + step - 1;

        Range* params = (Range*)malloc(sizeof(Range));
        params->start = localStart;
        params->end = localEnd;

        // Создание потока
        int err = pthread_create(&threads[i], NULL, L4Thread, params);
        if (err != 0) {
            HandleError("pthread_create error");
        }

        printf("Thread %d created to process range %d to %d\n", i + 1, localStart, localEnd);
    }

    // Ожидание завершения всех потоков
    for (int i = 0; i < numberOfThreads; i++) {
        pthread_join(threads[i], NULL);
    }

    free(threads);

    pthread_mutex_destroy(&cs);

    sortprimesGlobal();
    printf("\nSorted primes:\n%s\n", primesGlobal);

    return 0;
}
