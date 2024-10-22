#include <stdio.h>
#include <stdlib.h>
#include <windows.h> 

int main(int argc, char* argv[]) {
    
    SetConsoleOutputCP(1251);

    int iterations = 0;

    if (argc == 2) 
    {
        iterations = atoi(argv[1]);
    }
    else {
        
        char env_var[256];
        DWORD result = GetEnvironmentVariableA("ITER_NUM", env_var, sizeof(env_var));

        if (env_var == NULL) 
        {
            fprintf(stderr, "не указано количество итераций (аргумент или переменная окружения ITER_NUM)\n");
            ExitProcess(1);
        }

        iterations = atoi(env_var); 
    }

    if (iterations <= 0) 
    {
        fprintf(stderr, "укажите количество итераций больше 0\n");
        ExitProcess(1);
    }
    printf("количество итераций: %d\n", iterations);

    DWORD pid = GetCurrentProcessId();
    for (int i = 0; i < iterations; i++) {
  
        printf("%d) pid: %lu\n", i + 1, pid);
        Sleep(500); 
    }

    return 0; 
}
