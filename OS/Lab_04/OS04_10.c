#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h> 

// Функция потока
void* OS04_10_T1(void* arg) {
    for (int i = 0; i < 75; i++) {
        printf("%d) child thread pid = %d\n", i + 1, getpid());
        sleep(1); 
    }
    return NULL;
}

int main() {
    pthread_t thread; 

    // Вывод PID главного потока
    printf("main pid = %d\n", getpid());

    // Создание потока
    if (pthread_create(&thread, NULL, OS04_10_T1, NULL) != 0) {
        fprintf(stderr, "Error creating thread\n");
        return 1;
    }

    // Цикл главного потока
    for (int i = 0; i < 100; i++) {
        printf("%d) main thread pid = %d\n", i + 1, getpid());
        sleep(1); 
    }

    // Ожидание завершения потока
    pthread_join(thread, NULL);

    return 0;
}
