#include <windows.h>
#include <stdio.h>
#include <conio.h>
#include <locale.h>
#include <ctype.h>
#pragma warning(disable : 4996)

#define BUFFER_SIZE 1024

void displayUsage(const char* programName);
HANDLE createSemaphore();
HANDLE createNamedPipe(const char* pipe_name);
void processClientRequest(HANDLE hNamedPipe);

int main(int argc, char* argv[]) {
    setlocale(LC_ALL, "Russian");

    char pipe_name[80];
    if (argc > 1) {
        strncpy(pipe_name, argv[1], sizeof(pipe_name) - 1);
        pipe_name[sizeof(pipe_name) - 1] = '\0';
    }
    else {
        strcpy(pipe_name, "\\\\.\\pipe\\MyCustomPipe");
    }

    HANDLE semaphore = createSemaphore();
    if (semaphore == NULL) return 1;

    HANDLE hNamedPipe = createNamedPipe(pipe_name);
    if (hNamedPipe == INVALID_HANDLE_VALUE) {
        CloseHandle(semaphore);
        return 0;
    }
    Sleep(5000);

    for (;;) {
        _cprintf("The server is waiting for connection with a client.\n");

        if (!ConnectNamedPipe(hNamedPipe, NULL)) {
            _cprintf("Connect named pipe failed.\n");
            _cprintf("The last error code: %lu.\n", GetLastError());
            CloseHandle(hNamedPipe);
            CloseHandle(semaphore);
            return 0;
        }

        processClientRequest(hNamedPipe);

        DisconnectNamedPipe(hNamedPipe);
        Sleep(5000);
    }

    CloseHandle(hNamedPipe);
    CloseHandle(semaphore);

    return 0;
}

void displayUsage(const char* programName) {
    fprintf(stderr, "Usage: %s [pipe name]\n", programName);
}

HANDLE createSemaphore() {
    HANDLE semaphore = CreateSemaphoreA(NULL, 1, 1, "Global\\MySemaphore");
    if (semaphore == NULL) {
        printf("CreateSemaphore failed with error code %lu\n", GetLastError());
    }
    return semaphore;
}

HANDLE createNamedPipe(const char* pipe_name) {
    HANDLE hNamedPipe = CreateNamedPipeA(
        pipe_name,
        PIPE_ACCESS_DUPLEX,
        PIPE_TYPE_MESSAGE | PIPE_WAIT,
        1,
        BUFFER_SIZE,
        BUFFER_SIZE,
        INFINITE,
        NULL
    );

    if (hNamedPipe == INVALID_HANDLE_VALUE) {
        _cprintf("Create named pipe failed.\n");
        _cprintf("The last error code: %lu.\n", GetLastError());
    }
    return hNamedPipe;
}

void processClientRequest(HANDLE hNamedPipe) {
    char pchMessage[BUFFER_SIZE];
    char fullMessage[BUFFER_SIZE * 10] = { 0 };  
    DWORD dwBytesRead;
    DWORD dwBytesWrite;

    do {
        if (!ReadFile(hNamedPipe, pchMessage, sizeof(pchMessage), &dwBytesRead, NULL)) {
            _cprintf("Data reading from the named pipe failed.\n");
            _cprintf("The last error code: %lu.\n", GetLastError());
            return;
        }
        strncat(fullMessage, pchMessage, dwBytesRead);
    } while (dwBytesRead == BUFFER_SIZE);

    _cprintf("The server received the message from a client: \n\t%s\n", fullMessage);

    for (int i = 0; fullMessage[i] != '\0'; i++) {
        fullMessage[i] = toupper(fullMessage[i]);
    }
    _cprintf("Formatted message: \n\t%s\n", fullMessage);

    // Отправка обратно преобразованного сообщения клиенту
    int nMessageLength = strlen(fullMessage);
    int totalBytesSent = 0;

    while (totalBytesSent < nMessageLength) {
        int chunkSize = (nMessageLength - totalBytesSent > BUFFER_SIZE) ? BUFFER_SIZE : nMessageLength - totalBytesSent;
        if (!WriteFile(hNamedPipe, fullMessage + totalBytesSent, chunkSize, &dwBytesWrite, NULL)) {
            _cprintf("Write file failed.\n");
            _cprintf("The last error code: %lu.\n", GetLastError());
            return;
        }
        totalBytesSent += chunkSize;
    }
}
