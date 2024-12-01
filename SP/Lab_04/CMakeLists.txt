cmake_minimum_required(VERSION 3.10)

# Название проекта
project(masha)

# Установите стандарт C
set(CMAKE_C_STANDARD 11)

# Добавляем исходный файл
add_executable(laba Lab-04l.c)

add_executable(lab Lab-04bl.c)
# Используем компилятор Clang
set(CMAKE_C_COMPILER clang)

