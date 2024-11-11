#include <stdio.h>
#include <time.h>

int main() {
    time_t currentTime = time(NULL);

    struct tm* localTimeStruct = localtime(&currentTime);

    char timeBuffer[20];
    strftime(timeBuffer, sizeof(timeBuffer), "%d.%m.%Y %H:%M:%S", localTimeStruct);

    printf("Текущая локальная дата и время в формате дд.мм.гггг чч:мин:сек : %s\n", timeBuffer);

    return 0;
}
