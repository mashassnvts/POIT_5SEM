#include <stdio.h>
#include <stdlib.h>
#include <windows.h>

void createProcess(const char* exeName) {
    STARTUPINFO si = { sizeof(si) };
    PROCESS_INFORMATION pi;

    char cmdLine[MAX_PATH];
    snprintf(cmdLine, sizeof(cmdLine), "%s", exeName);

    if (!CreateProcessA(NULL, cmdLine, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi)) {
        fprintf(stderr, "CreateProcess failed for %s: %lu\n", exeName, GetLastError());
        return;
    }

    WaitForSingleObject(pi.hProcess, INFINITE);
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
}

int main() {
    const char* currentDir = "D:\\masha\\university\\SP";
    SetCurrentDirectoryA(currentDir);

    const char* exeNames[] = {
        "Lab-02hw-1.exe",
        "Lab-02hw-2.exe",
        "Lab-02hw-3.exe",
        "Lab-02hw-4.exe",
        "Lab-02hw-5.exe"
    };

    for (int i = 0; i < 5; i++) {
        createProcess(exeNames[i]);
    }

    return 0;
}