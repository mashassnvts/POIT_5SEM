#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>

int main() {
    const size_t PAGE_SIZE = sysconf(_SC_PAGESIZE); // Определяем размер страницы
    const size_t NUM_PAGES = 256;                  // Количество страниц
    const size_t REGION_SIZE = NUM_PAGES * PAGE_SIZE; // Общий размер памяти

    printf("Размер страницы: %zu байт\n", PAGE_SIZE);

    // Шаг 1: Резервирование 256 страниц
    void* mem_region = mmap(NULL, REGION_SIZE, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (mem_region == MAP_FAILED) {
        perror("Не удалось зарезервировать память");
        return EXIT_FAILURE;
    }
    printf("Резервирование памяти: %p - %p\n", mem_region, (char*)mem_region + REGION_SIZE);
    getchar(); // Ожидаем ввода пользователя

    // Шаг 2: Выделение физической памяти для второй половины
    void* second_half = (char*)mem_region + (REGION_SIZE / 2);
    if (mprotect(second_half, REGION_SIZE / 2, PROT_READ | PROT_WRITE) == -1) {
        perror("Не удалось изменить права доступа");
        munmap(mem_region, REGION_SIZE);
        return EXIT_FAILURE;
    }
    printf("Выделена физическая память для второй половины: %p - %p\n", second_half, (char*)second_half + REGION_SIZE / 2);
    getchar();

    // Шаг 3: Заполнение второй половины последовательностью целых чисел
    int* int_array = (int*)second_half;
    size_t num_ints = (REGION_SIZE / 2) / sizeof(int);
    for (size_t i = 0; i < num_ints; ++i) {
        int_array[i] = i;
    }
    printf("Вторая половина памяти заполнена последовательностью целых чисел.\n");
    getchar();

    // Шаг 4: Изменение атрибутов на "только для чтения"
    if (mprotect(second_half, REGION_SIZE / 2, PROT_READ) == -1) {
        perror("Не удалось изменить права доступа на только для чтения");
        munmap(mem_region, REGION_SIZE);
        return EXIT_FAILURE;
    }
    printf("Атрибуты второй половины памяти изменены на 'только для чтения'.\n");
    getchar();

    // Шаг 5: Освобождение 128 виртуальных страниц с массивом
    if (munmap(second_half, REGION_SIZE / 2) == -1) {
        perror("Не удалось освободить вторую половину памяти");
        return EXIT_FAILURE;
    }
    printf("Освобождена вторая половина памяти: %p - %p\n", second_half, (char*)second_half + REGION_SIZE / 2);
    getchar();

    // Шаг 6: Освобождение оставшихся страниц виртуальной памяти
    if (munmap(mem_region, REGION_SIZE / 2) == -1) {
        perror("Не удалось освободить первую половину памяти");
        return EXIT_FAILURE;
    }
    printf("Освобождена первая половина памяти: %p - %p\n", mem_region, (char*)mem_region + REGION_SIZE / 2);

    printf("Программа завершена.\n");
    return EXIT_SUCCESS;
}
