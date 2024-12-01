#include <stdio.h>
#include <unistd.h>

int global_var = 0;  
int initialized_var = 42;  

int main() {
    static int static_var = 0; 
    int local_var = 0;         

    printf("Программа OS08_03 запущена (PID: %d)\n", getpid());
    printf("Адрес main: %p\n", main);
    printf("Адрес global_var: %p\n", &global_var);
    printf("Адрес initialized_var: %p\n", &initialized_var);
    printf("Адрес static_var: %p\n", &static_var);
    printf("Адрес local_var: %p\n", &local_var);

    for (long long i = 0; i < 1e10; ++i) {
        if (i % 1000000000 == 0) {
            printf("Итерация: %lld\n", i);
            sleep(1);
        }
    }

    return 0;
}
