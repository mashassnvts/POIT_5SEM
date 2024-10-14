#define _WINSOCK_DEPRECATED_NO_WARNINGS
#include "Winsock2.h"

#include <algorithm>
#include <iostream>
#include <string>
#pragma comment(lib, "WS2_32.lib")

int countServers = 0;
std::string GetErrorMsgText(int code) // c����������� ����� ������
{
	std::string msgText;
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
	case WSA_INVALID_HANDLE: msgText = "��������� ���������� ������� � �������"; break;
	case WSA_INVALID_PARAMETER: msgText = "���� ��� ����� ���������� � �������"; break;
	case WSA_IO_INCOMPLETE: msgText = "������ �����-������ �� � ���������� ���������"; break;
	case WSA_IO_PENDING: msgText = "�������� ���������� �����"; break;
	case WSA_NOT_ENOUGH_MEMORY: msgText = "�� ���������� ������"; break;
	case WSA_OPERATION_ABORTED: msgText = "�������� ����������"; break;
	case WSASYSCALLFAILURE: msgText = "��������� ���������� ���������� ������"; break;
	default: break;
	}
	return msgText;
};

std::string SetErrorMsgText(std::string msgText, int code)
{
	return msgText + GetErrorMsgText(code);
};

bool GetRequestFromClient(char* name, short port, struct sockaddr* from, int* flen)
{
	char buf[50];
	int length;
	std::cout << "\nWait message..." << std::endl;

	while (true)
	{
		if (length = recvfrom(port, buf, sizeof(buf), NULL, from, flen) == SOCKET_ERROR)//port?
		{
			std::cout << "\nError" << std::endl;
			if (WSAGetLastError() == WSAETIMEDOUT)
				return false;
			else
				throw SetErrorMsgText("Recvfrom: ", WSAGetLastError());
		}
		return strcmp(buf, name) == 0;
	}

}
bool PutAnswerToClient(char* name, short port, struct sockaddr* to, int* lto)
{
	int lenghts = strlen(name);
	return sendto(port, name, lenghts + 1, NULL, to, *lto);
}

void GetServer(char* call, short port, struct sockaddr* from, int* flen)
{
	SOCKET cC;
	SOCKADDR_IN all;

	int timeout = 5000;

	int optval = 1;
	char buf[50];

	try
	{
		if ((cC = socket(AF_INET, SOCK_DGRAM, NULL)) == INVALID_SOCKET)
			throw  SetErrorMsgText("socket:", WSAGetLastError());


		if (setsockopt(cC, SOL_SOCKET, SO_BROADCAST, (char*)&optval, sizeof(int)) == SOCKET_ERROR)
			throw  SetErrorMsgText("setsocketopt:", WSAGetLastError());
		if (setsockopt(cC, SOL_SOCKET, SO_RCVTIMEO, (char*)&timeout, sizeof(int)) == SOCKET_ERROR)
			throw  SetErrorMsgText("setsocketopt:", WSAGetLastError());

		all.sin_family = AF_INET;
		all.sin_port = htons(port);
		all.sin_addr.s_addr = INADDR_BROADCAST;

		if (sendto(cC, call, strlen(call) + 1, NULL, (sockaddr*)&all, sizeof(all)) == SOCKET_ERROR)
			throw SetErrorMsgText("sendto:", WSAGetLastError());

		if (recvfrom(cC, buf, sizeof(buf), NULL, from, flen) == SOCKET_ERROR)
			throw  SetErrorMsgText("recvfrom:", WSAGetLastError());
		if (strcmp(call, buf) == 0)
		{
			countServers++;
			std::cout << "There's a server with the same callsign!" << std::endl;
			std::cout << "Count: " << countServers << std::endl;
			std::cout << "IP: " << inet_ntoa(((SOCKADDR_IN*)from)->sin_addr) << std::endl;
			std::cout << "Port: " << ntohs(((struct sockaddr_in*)from)->sin_port) << std::endl;
		}
	}
	catch (std::string errorMsgText)
	{
		if (WSAGetLastError() == WSAETIMEDOUT)
		{
			std::cout << "Number of servers with the same callsign: " << countServers << std::endl;
			if (closesocket(cC) == SOCKET_ERROR)
				throw SetErrorMsgText("closesocket: ", WSAGetLastError());
		}
		else throw SetErrorMsgText("GetServer:", WSAGetLastError());
	}
}

int main()
{
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);

	SOCKET sS;
	WSADATA wsaData;

	SOCKADDR_IN client;
	int clientSize = sizeof(client);
	char name[] = "Hello";
	char hostname[32];

	try
	{
		if (WSAStartup(MAKEWORD(2, 0), &wsaData) != 0)
			throw  SetErrorMsgText("Startup:", WSAGetLastError());

		std::cout << "Checking for other servers..." << std::endl;
		GetServer(name, 2000, (sockaddr*)&client, &clientSize);

		if ((sS = socket(AF_INET, SOCK_DGRAM, NULL)) == INVALID_SOCKET)
			throw  SetErrorMsgText("socket:", WSAGetLastError());
		SOCKADDR_IN serv;
		serv.sin_family = AF_INET;
		serv.sin_port = htons(2000);
		serv.sin_addr.s_addr =
			inet_addr("127.0.0.1");

		if (bind(sS, (LPSOCKADDR)&serv, sizeof(serv)) == SOCKET_ERROR)
			throw  SetErrorMsgText("bind:", WSAGetLastError());

		SOCKADDR_IN clientB;
		int clientSize = sizeof(clientB);

		if (gethostname(hostname, sizeof(hostname)) == SOCKET_ERROR)
			throw SetErrorMsgText("gethostname:", WSAGetLastError());
		std::cout << "Server name: " << hostname << std::endl;

		while (true)
		{
			if (GetRequestFromClient(name, sS, (SOCKADDR*)&clientB, &clientSize))
			{
				std::cout << std::endl;
				std::cout << "Client socket:" << std::endl;
				std::cout << "IP: " << inet_ntoa(clientB.sin_addr) << std::endl;
				std::cout << "Port: " << htons(clientB.sin_port) << std::endl;
				std::cout << std::endl;

				if (PutAnswerToClient(name, sS, (SOCKADDR*)&clientB, &clientSize))
				{
					std::cout << "Success!" << std::endl;
				}
			}
			else
			{
				std::cout << "Wrong call name!" << std::endl;
			}
		}

		if (closesocket(sS) == SOCKET_ERROR)
			throw  SetErrorMsgText("closesocket:", WSAGetLastError());

		if (WSACleanup() == SOCKET_ERROR)
			throw  SetErrorMsgText("Cleanup:", WSAGetLastError());
	}
	catch (std::string errorMsgText)
	{
		std::cout << std::endl << "WSAGetLastError: " << errorMsgText;
		system("pause");
	}
}