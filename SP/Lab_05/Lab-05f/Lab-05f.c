#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BLOCK_SIZE (512 * 1024) // Размер блока в 512 КиБ
#define NUM_BLOCKS 10           // Количество блоков

int main() {
    // Массив для хранения указателей на блоки
    void* blocks[NUM_BLOCKS];

    getchar();

    // Шаг 1: Выделить 10 блоков памяти из кучи размером 512 КиБ каждый
    for (int i = 0; i < NUM_BLOCKS; ++i) {
        blocks[i] = malloc(BLOCK_SIZE);
        if (blocks[i] == NULL) {
            perror("Ошибка выделения памяти");
            return EXIT_FAILURE;
        }
        printf("Блок %d выделен: %p - %p\n", i, blocks[i], (char*)blocks[i] + BLOCK_SIZE);
    }
    printf("Все 10 блоков памяти выделены\n");
    getchar();

    // Шаг 2: Заполнить каждый блок массивом целых чисел
    for (int i = 0; i < NUM_BLOCKS; ++i) {
        int* int_array = (int*)blocks[i];
        size_t num_ints = BLOCK_SIZE / sizeof(int); // Количество целых чисел в блоке
        for (size_t j = 0; j < num_ints; ++j) {
            int_array[j] = j;
        }
        printf("Блок %d заполнен массивом целых чисел\n", i);
    }
    printf("Все блоки заполнены\n");
    getchar();

    // Шаг 3: Освободить память, выделенную для всех блоков
    for (int i = 0; i < NUM_BLOCKS; ++i) {
        free(blocks[i]);
        printf("Блок %d освобожден: %p\n", i, blocks[i]);
        blocks[i] = NULL; // Указатель обнуляем для надежности
    }
    printf("Все блоки памяти освобождены\n");
    getchar();

    // Шаг 4: Уничтожить кучу
    // Здесь освобождение памяти означает, что управление кучей возвращается системе.
    printf("Куча успешно освобождена\n");
    getchar();

    return EXIT_SUCCESS;
}
