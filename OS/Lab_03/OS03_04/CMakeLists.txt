cmake_minimum_required(VERSION 3.10)

# Название проекта
project(OS03_04 C)

# Установка стандарта языка C
set(CMAKE_C_STANDARD 99)

# Добавляем исполняемый файл
add_executable(prjct OS03_04/OS03_04.c)

# Используем компилятор Clang
set(CMAKE_C_COMPILER clang)