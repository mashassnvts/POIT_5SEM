#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <windows.h>
#include <process.h> // ��� _spawnlp
#else
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#endif

int main() {
#ifdef _WIN32
    SetConsoleOutputCP(CP_UTF8); // ���������� ��������� ������� �� UTF-8
#endif

    // �������� ������� ����������
    char cwd[1024];
    if (getcwd(cwd, sizeof(cwd)) != NULL) {
        printf("������� ����������: %s\n", cwd);
    }
    else {
        perror("getcwd() ������");
        return 1;
    }

    int iterations1 = 10; // ���������� �������� ��� ������� ��������
    const char* env_var = "ITER_NUM=5"; // ���������� ��������� ��� ������� ��������

#ifdef _WIN32
    // ������� ������ �������� ������� � _spawnlp
    printf("����������� ������ �������� ������� � ����������: %d\n", iterations1);
    char arg[10];
    snprintf(arg, sizeof(arg), "%d", iterations1); // ���������� snprintf ��� ������������

    _spawnlp(_P_WAIT, "D:\\masha\\university\\SP\\SP_02\\Lab-02x\\x64\\Debug\\Lab-02x.exe", "Lab-02x.exe", arg, NULL);
    printf("������ �������� ������� ��������.\n");

    // ������� ������ �������� �������
    _putenv(env_var); // ������������� ���������� ���������
    printf("����������� ������ �������� ������� � ���������� ���������: %s\n", env_var);
    _spawnlp(_P_WAIT, "D:\\masha\\university\\SP\\SP_02\\Lab-02x\\x64\\Debug\\Lab-02x.exe", "Lab-02x.exe", NULL);
    printf("������ �������� ������� ��������.\n");
#else
    pid_t pid1, pid2;

    // ������� ������ �������� �������
    pid1 = fork();
    if (pid1 < 0) {
        perror("������ ��� �������� ������� ��������");
        exit(EXIT_FAILURE);
    }
    else if (pid1 == 0) {
        // ��� ��������� �������� 1
        char arg[10];
        snprintf(arg, sizeof(arg), "%d", iterations1); // ���������� snprintf ��� ������������
        printf("����������� ������ �������� ������� � ����������: %d\n", iterations1);

        char* args[] = { "./build/prjct", arg, NULL }; // ���������� ���������� ���� � ������������ �����
        execvp(args[0], args);
        perror("������ ���������� ������� ��������� ��������");
        exit(EXIT_FAILURE);
    }

    // ������� ������ �������� �������
    pid2 = fork();
    if (pid2 < 0) {
        perror("������ ��� �������� ������� ��������");
        exit(EXIT_FAILURE);
    }
    else if (pid2 == 0) {
        // ��� ��������� �������� 2
        putenv((char*)env_var); // ������������� ���������� ���������
        printf("����������� ������ �������� ������� � ���������� ���������: %s\n", env_var);

        char* args[] = { "./build/prjct", NULL }; // ���������� ���������� ���� � ������������ �����
        execvp(args[0], args);
        perror("������ ���������� ������� ��������� ��������");
        exit(EXIT_FAILURE);
    }

    // ������� ���������� ����� �������� ���������
    waitpid(pid1, NULL, 0);
    waitpid(pid2, NULL, 0);
    printf("��� �������� �������� ���������.\n");
#endif

    return 0;
}
