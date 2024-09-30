#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#endif

int main()
{
    printf("Запуск OS03_05_1 с PID = %d\n", getpid());

    for (int i = 1; i <= 50; ++i)
    {
        printf("%d. PID = %d [OS03_05_1]\n", i, getpid());

#ifdef _WIN32
        Sleep(1000); // Задержка в 1 секунду для Windows
#else
        sleep(1); // Задержка в 1 секунду для Linux
#endif
    }

    printf("OS03_05_1 завершился.\n");
    return 0; // Завершение программы
}