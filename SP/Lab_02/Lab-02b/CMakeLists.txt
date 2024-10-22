cmake_minimum_required(VERSION 3.10)

# Название проекта
project(Lab-02b C)

# Установка стандарта языка C
set(CMAKE_C_STANDARD 99)

# Добавляем исполняемый файл
add_executable(prjct Lab-02b/Lab-02b.c)

# Используем компилятор Clang
set(CMAKE_C_COMPILER clang)