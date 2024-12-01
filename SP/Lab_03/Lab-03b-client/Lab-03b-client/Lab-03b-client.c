#include <windows.h>
#include <conio.h>
#include <string.h>
#include <stdio.h>
#include <locale.h>
#pragma warning(disable : 4996)

#pragma comment(lib, "user32.lib")

#define BUFFER_SIZE 1024

void displayUsage(const char* programName);
HANDLE openSemaphore(const char* sem_name);
HANDLE connectToNamedPipe(const char* pipe_name);
void sendMessage(HANDLE hNamedPipe, const char* message);
void receiveMessage(HANDLE hNamedPipe, char* buffer);

int main(int argc, char* argv[]) {
    setlocale(LC_ALL, "Russian");

    char pipe_name[80];
    char sem_name[80];
    char fullMessage[BUFFER_SIZE * 10] = { 0 };

    if (argc < 2) {
        displayUsage(argv[0]);
        return 1;
    }

    strncpy(fullMessage, argv[1], sizeof(fullMessage) - 1);

    if (argc > 2) {
        strncpy(pipe_name, argv[2], sizeof(pipe_name) - 1);
    }
    else {
        strcpy(pipe_name, "\\\\.\\pipe\\MyCustomPipe");
    }

    if (argc > 3) {
        strncpy(sem_name, argv[3], sizeof(sem_name) - 1);
    }
    else {
        strcpy(sem_name, "Global\\MySemaphore");
    }

    HANDLE semaphore = openSemaphore(sem_name);
    if (semaphore == NULL) return 1;

    _cprintf("waiting for the semaphore...\n");
    WaitForSingleObject(semaphore, INFINITE);//освобождение семафора

    HANDLE hNamedPipe = connectToNamedPipe(pipe_name);
    if (hNamedPipe == INVALID_HANDLE_VALUE) {
        CloseHandle(semaphore);
        return 0;
    }
    Sleep(5000);

    sendMessage(hNamedPipe, fullMessage);

    char pchMessage[BUFFER_SIZE];
    memset(fullMessage, 0, sizeof(fullMessage));

    receiveMessage(hNamedPipe, fullMessage);

    _cprintf("The client received the message from a server: \n\t%s\n", fullMessage);
    _cprintf("Press any key to exit.\n");
    _getch();
    Sleep(5000);
    CloseHandle(hNamedPipe);
    ReleaseSemaphore(semaphore, 1, NULL);
    CloseHandle(semaphore);

    return 0;
}

void displayUsage(const char* programName) {
    fprintf(stderr, "Usage: %s <string> [pipe name] [semaphore name]\n", programName);
}

HANDLE openSemaphore(const char* sem_name) {
    HANDLE semaphore = OpenSemaphoreA(SYNCHRONIZE | SEMAPHORE_MODIFY_STATE, FALSE, sem_name);
    if (semaphore == NULL) {
        _cprintf("OpenSemaphore failed: %lu\n", GetLastError());
    }
    return semaphore;
}

HANDLE connectToNamedPipe(const char* pipe_name) {
    HANDLE hNamedPipe = CreateFileA(pipe_name, GENERIC_READ | GENERIC_WRITE,
        FILE_SHARE_READ | FILE_SHARE_WRITE, NULL,
        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hNamedPipe == INVALID_HANDLE_VALUE) {
        _cprintf("Connection with the named pipe failed.\n");
        _cprintf("The last error code: %lu.\n", GetLastError());
    }
    return hNamedPipe;
}

void sendMessage(HANDLE hNamedPipe, const char* message) {
    int nMessageLength = strlen(message);
    int totalBytesSent = 0;
    DWORD dwBytesWrite;

    while (totalBytesSent < nMessageLength) {
        int chunkSize = (nMessageLength - totalBytesSent > BUFFER_SIZE) ? BUFFER_SIZE : nMessageLength - totalBytesSent;
        if (!WriteFile(hNamedPipe, message + totalBytesSent, chunkSize, &dwBytesWrite, NULL)) {
            _cprintf("Write file failed.\n");
            _cprintf("The last error code: %lu.\n", GetLastError());
            return;
        }
        totalBytesSent += chunkSize;
    }
    _cprintf("The client sent the message to a server: \n\t%s\n", message);
}

void receiveMessage(HANDLE hNamedPipe, char* buffer) {
    char pchMessage[BUFFER_SIZE];
    DWORD dwBytesRead;

    do {
        if (!ReadFile(hNamedPipe, pchMessage, sizeof(pchMessage), &dwBytesRead, NULL)) {
            _cprintf("Data reading from the named pipe failed.\n");
            _cprintf("The last error code: %lu.\n", GetLastError());
            return;
        }
        strncat(buffer, pchMessage, dwBytesRead);
    } while (dwBytesRead == BUFFER_SIZE);
}
