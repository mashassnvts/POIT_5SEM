cmake_minimum_required(VERSION 3.10)

# Название проекта
project(masha)

# Установите стандарт C
set(CMAKE_C_STANDARD 11)

# Добавляем исходный файл
add_executable(server server.c)

add_executable(client client.c)

