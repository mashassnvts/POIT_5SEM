#include <stdio.h>
#include <time.h>
#include <unistd.h> 

int main() {
    clock_t startTime = clock();
    clock_t lastTime = startTime;
    int iterationCount = 0;
    
    time_t realStartTime = time(NULL);
    
    while (1) {
        iterationCount++;
        
        if ((clock() - lastTime) / CLOCKS_PER_SEC >= 2) {
            lastTime = clock();  
            printf("Количество итераций через 2 секунды процессорного времени: %d\n", iterationCount);
        }

        time_t currentRealTime = time(NULL);
        if (currentRealTime - realStartTime >= 10) {  
            break;
        }
    }

    clock_t endTime = clock();
    double cpuTimeUsed = ((double)(endTime - startTime)) / CLOCKS_PER_SEC;
    printf("Общее процессорное время: %.2f секунд\n", cpuTimeUsed);

    return 0;
}
