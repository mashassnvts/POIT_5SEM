#include <iostream>
#include "Winsock2.h"
#pragma comment(lib, "WS2_32.lib")
#pragma warning(disable : 4996)
using namespace std;


#define INADDR_ANY        (u_long)0x00000000 //����� �����       +++ 
#define INADDR_LOOPBACK    0x7f000001        // ���������� ����� +++
#define INADDR_BROADCAST  (u_long)0xffffffff // �������������    +++  
#define INADDR_NONE        0xffffffff        // ��� ������  
#define ADDR_ANY           INADDR_ANY        // ����� �����       

typedef struct sockaddr_in SOCKADDR_IN;    //                     +++
typedef struct sockaddr_in* PSOCKADDR_IN;
typedef struct sockaddr_in FAR* LPSOCKADDR_IN;

string GetErrorMsgText(int code)
{
	string msgText;
	switch (code)
	{
	case WSAEINTR: msgText = "������ ������� ��������"; break;
	case WSAEACCES:	msgText = "���������� ����������"; break;
	case WSAEFAULT: msgText = "��������� �����"; break;
	case WSAEINVAL:	msgText = "������ � ���������";	break;
	case WSAEMFILE:	msgText = "������� ������� ����� ������"; break;
	case WSAEWOULDBLOCK: msgText = "������ �������� ����������"; break;
	case WSAEINPROGRESS: msgText = "�������� � �������� ��������"; break;
	case WSAEALREADY: msgText = "�������� ��� �����������";	break;
	case WSAENOTSOCK: msgText = "����� ����� �����������"; break;
	case WSAEDESTADDRREQ: msgText = "��������� ����� ������������"; break;
	case WSAEMSGSIZE: msgText = "��������� ������� �������"; break;
	case WSAEPROTOTYPE: msgText = "������������ ��� ��������� ��� ������"; break;
	case WSAENOPROTOOPT: msgText = "������ � ����� ���������"; break;
	case WSAEPROTONOSUPPORT: msgText = "�������� �� ��������������"; break;
	case WSAESOCKTNOSUPPORT: msgText = "��� ������ �� ��������������"; break;
	case WSAEOPNOTSUPP: msgText = "�������� �� ��������������"; break;
	case WSAEPFNOSUPPORT: msgText = "��� ���������� �� ��������������"; break;
	case WSAEAFNOSUPPORT: msgText = "��� ������� �� �������������� ����������"; break;
	case WSAEADDRINUSE: msgText = "����� ��� ������������"; break;
	case WSAEADDRNOTAVAIL: msgText = "����������� ����� �� ����� ���� �����������"; break;
	case WSAENETDOWN: msgText = "���� ���������"; break;
	case WSAENETUNREACH: msgText = "���� �� ���������"; break;
	case WSAENETRESET: msgText = "���� ��������� ����������"; break;
	case WSAECONNABORTED: msgText = "����������� ����� �����"; break;
	case WSAECONNRESET: msgText = "����� �� �������������"; break;
	case WSAENOBUFS: msgText = "�� ������� ������ ��� �������"; break;
	case WSAEISCONN: msgText = "����� ��� ���������"; break;
	case WSAENOTCONN: msgText = "����� �� ���������"; break;
	case WSAESHUTDOWN: msgText = "������ ��������� send: ����� �������� ������"; break;
	case WSAETIMEDOUT: msgText = "���������� ���������� �������� �������"; break;
	case WSAECONNREFUSED: msgText = "���������� ���������"; break;
	case WSAEHOSTDOWN: msgText = "���� � ����������������� ���������"; break;
	case WSAEHOSTUNREACH: msgText = "��� �������� ��� �����"; break;
	case WSAEPROCLIM: msgText = "������� ����� ���������"; break;
	case WSASYSNOTREADY: msgText = "���� �� ��������"; break;
	case WSAVERNOTSUPPORTED: msgText = "������ ������ ����������"; break;
	case WSANOTINITIALISED: msgText = "�� ��������� ������������� WS2_32.dll"; break;
	case WSAEDISCON: msgText = "����������� ����������"; break;
	case WSATYPE_NOT_FOUND: msgText = "����� �� ������"; break;
	case WSAHOST_NOT_FOUND: msgText = "���� �� ������"; break;
	case WSATRY_AGAIN: msgText = "���������������� ���� �� ������"; break;
	case WSANO_RECOVERY: msgText = "�������������� ������"; break;
	case WSANO_DATA: msgText = "��� ������ ������������ ����"; break;
	case WSASYSCALLFAILURE: msgText = "��������� ���������� ���������� ������"; break;
	case 2: msgText = "��������� ����������"; break;
	case ERROR_INVALID_PARAMETER: msgText = "�������� ��������� pimax ����������� ��������  PIPE_UNLMITED_INSTANCES"; break;
	case ERROR_NO_DATA: msgText = "The pipe is being closed"; break;
	case ERROR_PIPE_CONNECTED: msgText = "There is a process on other end of the pipe"; break;
	case ERROR_PIPE_LISTENING: msgText = "Waiting for a process to open the other end of the pipe"; break;
	case ERROR_CALL_NOT_IMPLEMENTED: msgText = "This function is not supported on this system"; break;
	default: msgText = "**ERROR**"; break;
	}
	return msgText;
};
string SetPipeError(string msgText, int code)
{
    return msgText + GetErrorMsgText(code);
}
//4
//int main()
//{
//    setlocale(LC_ALL, "Russian");
//    HANDLE hPipe;
//
//	SECURITY_DESCRIPTOR sd;
//	InitializeSecurityDescriptor(&sd, SECURITY_DESCRIPTOR_REVISION);
//	SetSecurityDescriptorDacl(&sd, TRUE, NULL, FALSE);
//	
//	SECURITY_ATTRIBUTES sa;
//	sa.nLength = sizeof(sa);
//	sa.lpSecurityDescriptor = &sd;
//	sa.bInheritHandle = FALSE;
//
//    try {
//        if ((hPipe = CreateNamedPipeA("\\\\.\\pipe\\Tube",
//            PIPE_ACCESS_DUPLEX,
//            PIPE_TYPE_MESSAGE | PIPE_WAIT,
//            1, NULL, NULL,
//            INFINITE, &sa)) == INVALID_HANDLE_VALUE)
//            throw SetPipeError("create: ", GetLastError());
//
//        cout << "Waitinig for client to connect..." << endl;
//        if (!ConnectNamedPipe(hPipe, NULL))
//            throw SetPipeError("connect: ", GetLastError());
//        cout << "Client connected" << endl;
//
//		char rbuf[50];
//		DWORD rbufl = 0;
//		if (!ReadFile(hPipe, rbuf, sizeof(rbuf) - 1, &rbufl, NULL));
//
//		cout << "Message: " << rbuf << endl;
//
//
//		char wbuf[50] = "hello from server";
//		DWORD wbufl = 0;
//		if (!WriteFile(hPipe, wbuf, sizeof(wbuf) - 1, &wbufl, NULL))
//			throw SetPipeError("write: ", GetLastError());
//		cout << "message sent." << endl;
//
//
//        DisconnectNamedPipe(hPipe);
//        CloseHandle(hPipe);
//    }
//    catch (string errorMsgText) {
//        cout << endl << "Error: " << errorMsgText;
//        DisconnectNamedPipe(hPipe);
//        CloseHandle(hPipe);
//    }
//
//
//    return 0;
//}

//5
int main()
{
	setlocale(LC_ALL, "Russian");
	HANDLE hPipe;

	try {

		SECURITY_DESCRIPTOR sd;
		InitializeSecurityDescriptor(&sd, SECURITY_DESCRIPTOR_REVISION);
		SetSecurityDescriptorDacl(&sd, TRUE, NULL, FALSE);

		SECURITY_ATTRIBUTES sa;
		sa.nLength = sizeof(sa);
		sa.lpSecurityDescriptor = &sd;
		sa.bInheritHandle = FALSE;

		
		if ((hPipe = CreateNamedPipe(L"\\\\.\\pipe\\Tube",
			PIPE_ACCESS_DUPLEX,
			PIPE_TYPE_MESSAGE | PIPE_WAIT,
			1, 512, 512,
			INFINITE, &sa)) == INVALID_HANDLE_VALUE)
			throw SetPipeError("create: ", GetLastError());


		while (true) {
			cout << "Waitinig for client to connect..." << endl;
			if (!ConnectNamedPipe(hPipe, NULL))
				throw SetPipeError("connect: ", GetLastError());
			cout << "Client connected" << endl;


			while (true) {
				char rbuf[50];
				LPDWORD rbufl = 0;
				if (!ReadFile(hPipe, rbuf, sizeof(rbuf), rbufl, NULL))
					throw SetPipeError("connect: ", GetLastError());

				if (strcmp(rbuf, "\0") == 0) {
					DisconnectNamedPipe(hPipe);
					break;
				}

				cout << "Message: " << rbuf << endl;

				DWORD wbufl = 0;
				if (!WriteFile(hPipe, rbuf, sizeof(rbuf)-1, &wbufl, NULL))
					throw SetPipeError("write: ", GetLastError());
				cout << "message sent." << endl;
			}
		}

		CloseHandle(hPipe);
	}
	catch (string errorMsgText) {
		cout << endl << "Error: " << errorMsgText;
		DisconnectNamedPipe(hPipe);
		CloseHandle(hPipe);
	}


	return 0;
}
