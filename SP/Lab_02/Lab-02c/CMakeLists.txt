cmake_minimum_required(VERSION 3.10)

# Название проекта
project(Lab-02c C)

# Установка стандарта языка C
set(CMAKE_C_STANDARD 99)

# Добавляем исполняемый файл
add_executable(prjct Lab-02c/Lab-02.c)

# Используем компилятор Clang
set(CMAKE_C_COMPILER clang)