#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/types.h>
#include <syscall.h>

pthread_mutex_t mx;
const char* thread_names[] = {"main", "A", "B"};

void* threadA(void* arg) {
    pid_t pid = getpid();
    pid_t tid = (pid_t)syscall(SYS_gettid);
    for (int i = 1; i <= 90; i++) {
        if (i == 30) {
            pthread_mutex_lock(&mx);
        }
        if (i == 60) {
            pthread_mutex_unlock(&mx);
        }

        usleep(100000);
        printf("[%s]  %d) pid = %d tid = %u\n", thread_names[1], i, pid, (unsigned int)tid);
        if (i == 60) {
            pthread_mutex_lock(&mx);
            pthread_mutex_unlock(&mx);
        }
    }
    pthread_exit(NULL);
}

void* threadB(void* arg) {
    pid_t pid = getpid();
    pid_t tid = (pid_t)syscall(SYS_gettid);
    for (int i = 1; i <= 90; i++) {
        if (i == 30) {
            pthread_mutex_lock(&mx);
        }
        if (i == 60) {
            pthread_mutex_unlock(&mx);
        }

        usleep(100000);
        printf("[%s] %d) pid = %d tid = %u\n", thread_names[2], i, pid, (unsigned int)tid);
        if (i == 60) {
            pthread_mutex_lock(&mx);
            pthread_mutex_unlock(&mx);
        }
    }
    pthread_exit(NULL);
}

int main() {
    pthread_mutex_init(&mx, NULL);
    pthread_t thread1, thread2;

    pid_t main_pid = getpid();
    pid_t main_tid = (pid_t)syscall(SYS_gettid);
    printf("[%s] 1) pid = %d tid = %u\n", thread_names[0], main_pid, (unsigned int)main_tid);

    pthread_create(&thread1, NULL, threadA, NULL);
    pthread_create(&thread2, NULL, threadB, NULL);

    for (int i = 2; i <= 90; i++) {
        if (i == 30) {
            pthread_mutex_lock(&mx);
        }
        if (i == 60) {
            pthread_mutex_unlock(&mx);
        }

        usleep(100000);
        printf("[%s] %d) pid = %d tid = %u\n", thread_names[0], i, main_pid, (unsigned int)main_tid);
        if (i == 60) {
            pthread_mutex_lock(&mx);
            pthread_mutex_unlock(&mx);
        }
    }

    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);

    pthread_mutex_destroy(&mx);
    return 0;
}
