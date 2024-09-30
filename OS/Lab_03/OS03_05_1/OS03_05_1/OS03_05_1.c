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
    printf("������ OS03_05_1 � PID = %d\n", getpid());

    for (int i = 1; i <= 50; ++i)
    {
        printf("%d. PID = %d [OS03_05_1]\n", i, getpid());

#ifdef _WIN32
        Sleep(1000); // �������� � 1 ������� ��� Windows
#else
        sleep(1); // �������� � 1 ������� ��� Linux
#endif
    }

    printf("OS03_05_1 ����������.\n");
    return 0; // ���������� ���������
}