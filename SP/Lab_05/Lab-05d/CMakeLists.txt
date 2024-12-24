cmake_minimum_required(VERSION 3.10)

# Название проекта
project(masha)

# Установите стандарт C
set(CMAKE_C_STANDARD 11)

# Добавляем исходный файл
add_executable(prjct Lab-05d.c)

# Используем компилятор Clang
set(CMAKE_C_COMPILER clang)

