#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
#include <windows.h>
#include <process.h> // Для _spawnlp
#else
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#endif

int main() {
#ifdef _WIN32
    SetConsoleOutputCP(CP_UTF8); // Установите кодировку консоли на UTF-8
#endif

    // Проверка текущей директории
    char cwd[1024];
    if (getcwd(cwd, sizeof(cwd)) != NULL) {
        printf("Текущая директория: %s\n", cwd);
    }
    else {
        perror("getcwd() ошибка");
        return 1;
    }

    int iterations1 = 10; // Количество итераций для первого процесса
    const char* env_var = "ITER_NUM=5"; // Переменная окружения для второго процесса

#ifdef _WIN32
    // Создаем первый дочерний процесс с _spawnlp
    printf("Запускается первый дочерний процесс с аргументом: %d\n", iterations1);
    char arg[10];
    snprintf(arg, sizeof(arg), "%d", iterations1); // Используем snprintf для безопасности

    _spawnlp(_P_WAIT, "D:\\masha\\university\\SP\\SP_02\\Lab-02x\\x64\\Debug\\Lab-02x.exe", "Lab-02x.exe", arg, NULL);
    printf("Первый дочерний процесс завершён.\n");

    // Создаем второй дочерний процесс
    _putenv(env_var); // Устанавливаем переменную окружения
    printf("Запускается второй дочерний процесс с переменной окружения: %s\n", env_var);
    _spawnlp(_P_WAIT, "D:\\masha\\university\\SP\\SP_02\\Lab-02x\\x64\\Debug\\Lab-02x.exe", "Lab-02x.exe", NULL);
    printf("Второй дочерний процесс завершён.\n");
#else
    pid_t pid1, pid2;

    // Создаем первый дочерний процесс
    pid1 = fork();
    if (pid1 < 0) {
        perror("Ошибка при создании первого процесса");
        exit(EXIT_FAILURE);
    }
    else if (pid1 == 0) {
        // Код дочернего процесса 1
        char arg[10];
        snprintf(arg, sizeof(arg), "%d", iterations1); // Используем snprintf для безопасности
        printf("Запускается первый дочерний процесс с аргументом: %d\n", iterations1);

        char* args[] = { "./build/prjct", arg, NULL }; // Используем правильный путь к исполняемому файлу
        execvp(args[0], args);
        perror("Ошибка выполнения первого дочернего процесса");
        exit(EXIT_FAILURE);
    }

    // Создаем второй дочерний процесс
    pid2 = fork();
    if (pid2 < 0) {
        perror("Ошибка при создании второго процесса");
        exit(EXIT_FAILURE);
    }
    else if (pid2 == 0) {
        // Код дочернего процесса 2
        putenv((char*)env_var); // Устанавливаем переменную окружения
        printf("Запускается второй дочерний процесс с переменной окружения: %s\n", env_var);

        char* args[] = { "./build/prjct", NULL }; // Используем правильный путь к исполняемому файлу
        execvp(args[0], args);
        perror("Ошибка выполнения второго дочернего процесса");
        exit(EXIT_FAILURE);
    }

    // Ожидаем завершения обоих дочерних процессов
    waitpid(pid1, NULL, 0);
    waitpid(pid2, NULL, 0);
    printf("Оба дочерних процесса завершены.\n");
#endif

    return 0;
}
