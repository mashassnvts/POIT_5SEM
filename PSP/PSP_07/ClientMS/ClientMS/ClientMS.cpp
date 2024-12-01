﻿#include <iostream>
#include "Winsock2.h"
#include <string.h>
#include <ws2tcpip.h>
#include <string>
#include <vector>
#define _CRT_SECURE_NO_WARNINGS
#pragma warning(disable : 4996)
#include <tchar.h>
#include <chrono>
using namespace std;
#pragma comment(lib, "WS2_32.lib")

//Задание 7
void SendMessageToServers(char* serverName, char* message) {
    HANDLE cH = CreateFileA(serverName, GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (cH == INVALID_HANDLE_VALUE) {
        cerr << "Failed to create file. Error: " << GetLastError() << endl;
    }
    else
    {
        cout << "File created successfully" << endl;
    }
    
    DWORD bytesSended;
    if (!WriteFile(cH, message, strlen(message), &bytesSended, NULL)) {
        cerr << "Failed to write to Mailslot. Error: " << GetLastError() << endl;
    }
    else {
        cout << "Message sent successfully. Bytes sent: " << bytesSended << endl;
    }

    CloseHandle(cH);
}

int main() {
    /*HANDLE cH = CreateFile(TEXT("\\\\MSI\\mailslot\\Box"), GENERIC_WRITE, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (cH == INVALID_HANDLE_VALUE) {
        cerr << "Failed to create file. Error: " << GetLastError() << endl;
        return 1;
    }
    else {
        cout << "File created successfully" << endl;
    }*/

    //Задание 9
   /* auto start = chrono::high_resolution_clock::now();
    for (int i = 0; i < 1000; ++i) {
        char message[50];
        sprintf(message, "Message %d", i);
        DWORD bytesSended;

        if (!WriteFile(cH, message, strlen(message)+1, &bytesSended, NULL)) {
            cerr << "Error sending message: " << GetLastError() << " - " << message << endl;
            break;
        }
        char m[50];
        sprintf(m, "message %d sent", i);
        cout << m << endl;
        Sleep(5);
    }

    auto end = chrono::high_resolution_clock::now();
    chrono::duration<double> duration = end - start;
    cout << "Time taken to send 1000 messages: " << duration.count() << " seconds" << endl;*/
    
    
    //char message[50] = "Hello";
    /*DWORD bytesSended;
    if (!WriteFile(cH, message, strlen(message) + 1, &bytesSended, NULL)) {
        cerr << "Error sending message: " << GetLastError() << " - " << message << endl;
    }
    CloseHandle(cH);*/

    char nameServer[20] = "\\\\MSI\\mailslot\\Box";
    char message[50] = "Hello from client";
    SendMessageToServers(nameServer, message);

    char nameServer2[40] = "\\\\DESKTOP-0M3BPJP\\mailslot\\Box";
    char message2[50] = "Hello from client";
    SendMessageToServers(nameServer2, message2);
    return 0;
}