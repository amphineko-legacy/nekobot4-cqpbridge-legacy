#include "stdafx.h"
#include "winbase.h"
#include "include/cqp.h"

#include "cqpbridge.h"


int session_code;
char *status_hello;


void create_status_hello() {

	char buffer[MAX_COMPUTERNAME_LENGTH + 1];
	DWORD buffer_size = sizeof(buffer) / sizeof(buffer[0]);
	GetComputerNameA(buffer, &buffer_size);

	size_t result_len = strlen(SYSTEM_HELLO_PRE) + strlen(buffer) + 2;
	status_hello = new char[result_len];
	status_hello[0] = '\0';
	strcat_s(status_hello, result_len, SYSTEM_HELLO_PRE);
	strcat_s(status_hello, result_len, buffer);
	strcat_s(status_hello, result_len, ".");
}


// Returns app identifier required by CQP
CQEVENT(const char*, AppInfo, 0)() {

	return CQAPPINFO;
}


// Saves authentication code required by CQP when calling APIs
CQEVENT(int32_t, Initialize, 4)(int32_t current_code) {

	session_code = current_code;
	return EVENT_IGNORE;
}


// Type=1001 Host start
// This event fires when the plugin has been loaded into CQP
CQEVENT(int32_t, __eventStartup, 0)() {

	create_status_hello();
	return EVENT_IGNORE;
}


// Type=1002 Host exit
// This event fires when the plugin has been unloaded from CQP
// CQP host will exit soon
CQEVENT(int32_t, __eventExit, 0)() {

	return EVENT_IGNORE;
}


// Type=1003 App enabled
// This event fires when the plugin has been enabled
CQEVENT(int32_t, __eventEnable, 0)() {

	return EVENT_IGNORE;
}


// Type=1004 App disabled
// This events fires when the plugin is being disabled
CQEVENT(int32_t, __eventDisable, 0)() {

	return EVENT_IGNORE;
}


// Type=2 Group message
CQEVENT(int32_t, __eventGroupMsg, 36)(int32_t subType, int32_t sendTime, int64_t fromGroup, int64_t fromQQ, const char *fromAnonymous, const char *msg, int32_t font) {
	
	const char match_target[] = "@nekobot-cqpbridge";
	if (strcmp(msg, match_target) == 0) {
		CQ_sendGroupMsg(session_code, fromGroup, status_hello);
	}
	return EVENT_IGNORE;
}

