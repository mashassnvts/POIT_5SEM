#include <iostream>
#include <ctime>

using namespace std;

int main() {
    setlocale(LC_ALL, "rus");
    time_t currentTime = time(nullptr);


    tm localTimeStruct;
    localtime_s(&localTimeStruct, &currentTime); 

    char timeBuffer[20];
    strftime(timeBuffer, sizeof(timeBuffer), "%d.%m.%Y %H:%M:%S", &localTimeStruct);

    cout << "текущая локальная дата и время в формате дд.мм.ггг чч:мин:сек : " << timeBuffer << endl;

    return 0;
}
