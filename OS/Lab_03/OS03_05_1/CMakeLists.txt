cmake_minimum_required(VERSION 3.10)

# Название проекта
project(OS03_05_1 C)

# Установка стандарта языка C
set(CMAKE_C_STANDARD 99)

# Добавляем исполняемый файл
add_executable(prjct OS03_05_1/OS03_05_1.c)

# Используем компилятор Clang
set(CMAKE_C_COMPILER clang)