#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <Windows.h>
#else
#include <unistd.h> 
#include <sys/types.h> 
#endif

int main() {
#ifdef _WIN32
    DWORD pid = GetCurrentProcessId(); 
    Sleep(1000); 
#else
    pid_t pid = getpid(); 
#endif
    printf("zadanie\n");

    for (short i = 1; i <= 10000; ++i) {
        printf("%d. PID = %d\n", i, pid);
#ifdef _WIN32
        Sleep(1000);
#else
        sleep(1); 
#endif
    }

    exit(0);
}
