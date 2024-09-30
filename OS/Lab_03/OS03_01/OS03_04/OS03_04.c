#ifdef _WIN32
#include <Windows.h>
#else
// Заголовки для Linux (например, unistd.h для sleep)
#include <unistd.h>
#endif


int main() {
    DWORD pid = GetCurrentProcessId(); 
    printf("masha\n");

    for (short i = 1; i <= 10000; ++i) {
        printf("%d. PID = %d\n", i, pid);
        Sleep(1000); 
    }

    exit(0);
}