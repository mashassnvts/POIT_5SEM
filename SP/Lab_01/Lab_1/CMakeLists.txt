cmake_minimum_required(VERSION 3.10)
# Название проекта
project(Lab_1 C)

# Установка стандарта языка C
set(CMAKE_C_STANDARD 99)

# Добавляем исполняемый файл
add_executable(StrTypeChecker Lab_1/Lab_1.c)

# Используем компилятор Clang
set(CMAKE_C_COMPILER "clang")
set(CMAKE_CXX_COMPILER "clang++")