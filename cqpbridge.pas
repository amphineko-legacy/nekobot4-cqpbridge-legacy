library cqpbridge;

// Copyright (c) 2016 Naoki Rinmous
// This file or snippet of code was released under MIT license.

// External Libraries

uses bridge, consts, cqp, ctypes, sysutils, windows;

// Local variables

var AppInfo: AnsiString;
var AppSession: int32;
var BridgeState: Boolean = False;
var ConsoleState: Boolean;

// Plugin Initialization

function GetAppInfo(): PAnsiChar; stdcall;
begin
    AppInfo := '9,moe.futa.nekobot4.cqpbridge';
    Exit(PAnsiChar(AppInfo));
end;

function SetAppSession(CurrentSession: int32): int32; stdcall;
begin
    AppSession := CurrentSession;
    Exit(EVENT_IGNORE);
end;

// Basic Events

function OnPluginEnable(): int32; stdcall;
    var ErrorCode: Cint;
    var Error: AnsiString;
begin
    ErrorCode := CreateBridge();
    Error := 'PushSocket bound, Error=' + IntToStr(ErrorCode);
    MessageBoxA(0, PAnsiChar(Error), nil, 0);
    BridgeState := True;
end;

function OnPluginDisable(): int32; stdcall;
begin
    // DestroyBridge();
    BridgeState := False;
end;

function OnHostStart(): int32; stdcall;
    var LastError: AnsiString;
begin
    if AllocConsole() = False then
    begin
        ConsoleState := False;
        LastError := 'Failed to create console, GetLastError=' + IntToStr(GetLastError());
        MessageBox(0, PAnsiChar(LastError), nil, 0);
    end else
        ConsoleState := True;
    InitializeBridge();
    Exit(EVENT_IGNORE);
end;

function OnHostExit(): int32; stdcall;
begin
    if ConsoleState then
        FreeConsole();
    if BridgeState then
        OnPluginDisable();
    Exit(EVENT_IGNORE);
end;

// Messages

function OnGroupMessage(SubType: int32; Timestamp: int32; GroupId: int64; UserId: int64; AnonymousNickPtr: PAnsiChar; MessagePtr: PAnsiChar; font: int32): int32; stdcall;
    var RawAnonymousNick: AnsiString;
    var RawMessage: AnsiString;
    var AnonymousNick: WideString;
    var Message: AnsiString;
    var Response: AnsiString;
begin
    Message := AnsiString(MessagePtr);
    PushGroupMessage(IntToStr(GroupId), IntToStr(UserId), Message);
    WriteLn(Message);
    Exit(EVENT_BLOCK);
end;

// Function Exporting

exports GetAppInfo name 'AppInfo';
exports SetAppSession name 'Initialize';

exports OnPluginEnable name '_eventEnable';
exports OnPluginDisable name '_eventDisable';

exports OnHostStart name '_eventStartup';
exports OnHostExit name '_eventExit';

exports OnGroupMessage name '_eventGroupMsg';

end.
