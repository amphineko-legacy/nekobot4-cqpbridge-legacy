library cqpbridge;

// Copyright (c) 2016 Naoki Rinmous
// This file or snippet of code was released under MIT license.

// External Libraries

uses consts, cqp, Windows;

// Local variables

var AppInfo: AnsiString;
var AppSession: int32;

// Plugin Initialization

function GetAppInfo(): PAnsiChar; stdcall;
begin
    AppInfo := '9,moe.futa.nekobot4.cqpbridge';
    exit(PAnsiChar(AppInfo));
end;

function SetAppSession(CurrentSession: int32): int32; stdcall;
begin
    AppSession := CurrentSession;
    exit(EVENT_IGNORE);
end;

// Basic Events

function OnHostStart(): int32; stdcall;
begin
    exit(EVENT_IGNORE);
end;

function OnHostExit(): int32; stdcall;
begin
    exit(EVENT_IGNORE);
end;

// Group Message

function OnGroupMessage(subType: int32; timestamp: int32; groupId: int64; userId: int64; anonymousNickPtr: PAnsiChar; messagePtr: PAnsiChar; font: int32): int32; stdcall;
    var anonymousNick: AnsiString;
    var message: AnsiString;
    var response: AnsiString;
begin
    message := StrPas(messagePtr);
    if message = 'Take Control' then
    begin
        response := 'Brain Power!';
        CQ_sendGroupMsg(AppSession, groupId, PAnsiChar(response));
        exit(EVENT_BLOCK);
    end;
    exit(EVENT_IGNORE);
end;

// Function Exporting

exports GetAppInfo name 'AppInfo';
exports SetAppSession name 'Initialize';

exports OnHostStart name '_eventStartup';
exports OnHostExit name '_eventExit';

exports OnGroupMessage name '_eventGroupMsg';

end.
