library cqpbridge;

// Copyright (c) 2016 Naoki Rinmous
// This file or snippet of code was released under MIT license.

// External Libraries

uses bridge, cqp, ctypes, sysutils, windows;

// Constants

const AppName: AnsiString = 'moe.futa.nekobot4.cqpbridge';
const MaxDllFilename: DWORD = 512;

// Local variables

var AppInfo: AnsiString;        // Persistent memory for pointer passing

// Plugin Initialization

// CQEVENT(const char*, AppInfo, 0)()
function GetAppInfo(): PAnsiChar; stdcall;
begin
    AppInfo := '9,' + AppName;
    Exit(PAnsiChar(AppInfo));
end;

// CQEVENT(int32_t, Initialize, 4)(int32_t current_code) {
function SetAppSession(CurrentSession: Cint32): Cint32; stdcall;
begin
    SetCQPSession(CurrentSession);
    Exit(EVENT_IGNORE);
end;

// Basic Events

// CQEVENT(int32_t, __eventEnable, 0)()
function OnPluginEnable(): Cint32; stdcall;
begin
    // EnableBridge();
    Exit(EVENT_IGNORE);
end;

// CQEVENT(int32_t, __eventDisable, 0)()
function OnPluginDisable(): Cint32; stdcall;
begin
    // DisableBridge();
    Exit(EVENT_IGNORE);
end;

// CQEVENT(int32_t, __eventStartup, 0)()
function OnHostStart(): Cint32; stdcall;
    var DllPath: AnsiString;
    var PFilename: PAnsiChar;
    var PFilenameSize: DWORD;
begin
    SendCQPLog(CQLOG_INFO, 'This is CQPBridge loading for you');

    PFilenameSize := MaxDllFilename * SizeOf(AnsiChar);
    PFilename := GetMem(PFilenameSize);
    GetModuleFileNameA(0, PFilename, PFilenameSize);
    DllPath := ExtractFilePath(PFilename) + 'cqpbridge.json';

    SendCQPLog(CQLOG_INFO, 'CQPBridge config located at ' + AnsiString(DllPath));
    InitializeBridge(DllPath);
    Exit(EVENT_IGNORE);
end;

// CQEVENT(int32_t, __eventExit, 0)()
function OnHostExit(): Cint32; stdcall;
begin
    SendCQPLog(CQLOG_INFO, 'This is CQPBridge unloading, bye');
    DeinitializeBridge();
    Exit(EVENT_IGNORE);
end;

// Messages

// Function Exporting

exports GetAppInfo name 'AppInfo';
exports SetAppSession name 'Initialize';

exports OnPluginEnable name '_eventEnable';
exports OnPluginDisable name '_eventDisable';

exports OnHostStart name '_eventStartup';
exports OnHostExit name '_eventExit';

end.
