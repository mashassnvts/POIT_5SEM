#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

#ifdef _WIN32
#include <windows.h>  
#define getpid() GetCurrentProcessId()
#define sleep(seconds) Sleep((seconds) * 1000)  
#define pid_t int  
#else
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#endif


void cycle(int counter, char* message)
{
    for (int i = 1; i <= counter; ++i)
    {
        printf("%d. pid = %d [%s]\n", i, getpid(), message);
        sleep(2);
    }
}

int main()
{
#ifndef _WIN32
    
    pid_t pid;
    switch (pid = fork())
    {
    case -1:
        perror("[ERROR] Fork() returned -1"); 
        exit(-1);
    case 0:
        cycle(50, "OS03_05_1");  
        exit(0);
    default:
        printf("[INFO] default = %d\n", pid);  
        cycle(100, "OS03_05");
        wait(0);  
    }
#else
    printf("[INFO] Running in single process mode for Windows.\n");
    cycle(100, "OS03_05");
#endif

    return 0;
}
