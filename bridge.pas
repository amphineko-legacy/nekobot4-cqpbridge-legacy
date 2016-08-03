unit bridge;

{$MODE DELPHI}

interface

uses classes, cqp, ctypes, fpjson, jsonparser, sysutils, windows, zmq;

const MAX_BUFFER_LENGTH: Csize_t = 1024;

procedure InitializeBridge(ConfigFilename: AnsiString);
procedure DeinitializeBridge;

procedure EnableBridge;
procedure DisableBridge;

procedure PushGroupMessage(GroupId: AnsiString; UserId: AnsiString; Message: AnsiString; AnonymousNick: AnsiString);

implementation

var ZmqContext: Pointer = nil;
var PushSocket, RecvSocket: Pointer;
var PushSocketEndpoint, RecvSocketEndpoint: AnsiString;
var RecvThreadHandle: Handle;
// var PushSocketState, RecvSocketState: Boolean;

function LoadFileToStr(const FileName: AnsiString): AnsiString;
    var FileStream : TFileStream;
begin
    FileStream := TFileStream.Create(FileName, fmOpenRead);
    try
        if FileStream.Size > 0 then begin
            SetLength(Result, FileStream.Size);
            FileStream.Read(Pointer(Result)^, FileStream.Size);
        end;
    finally
        FileStream.Free;
    end;
end;

procedure InitializeBridge(ConfigFilename: AnsiString);
    var Config: TJSONObject;
begin
    Config := TJSONObject(GetJSON(LoadFileToStr(ConfigFilename)));
    PushSocketEndpoint := Config.Get('PushSocketEndpoint');
    SendCQPLog(CQLOG_INFO, 'PushSocketEndpoint = ' + PushSocketEndpoint);
    RecvSocketEndpoint := Config.Get('RecvSocketEndpoint');
    SendCQPLog(CQLOG_INFO, 'RecvSocketEndpoint = ' + RecvSocketEndpoint);

    SendCQPLog(CQLOG_INFO, 'Socket configuration loaded');
end;

procedure DeinitializeBridge;
begin

end;

function BindSocket(Socket: Pointer; Endpoint: AnsiString): Boolean;
    // var Linger: Cint;
begin
    // Linger := 0;
    if zmq_bind(Socket, PAnsiChar(Endpoint)) = 0 then begin
        // zmq_setsockopt(Socket, ZMQ_LINGER, @Linger, SizeOf(Linger));
        Result := True
    end else begin
        SendCQPLog(CQLOG_INFO, 'Socket binding failed, Error=' + IntToStr(zmq_errno()));
        Result := False;
    end;
end;

procedure ProcessCommand(RawString: AnsiString);
    var Command: TJSONObject;
begin
    try
        Command := TJSONObject(GetJSON(RawString));
        try
            if 'sendGroupMessage' = Command.Strings['command'] then
                SendGroupMessage(Command.Strings['group'], Command.Strings['content']);
        finally
            Command.Free();
        end;
    except
        on E: Exception do
            SendCQPLog(CQLOG_ERROR, '[' + E.ClassName + '] ' + E.Message);
    end;
end;

procedure RecvSocketThread(ReservedParameter: Pointer);
    var Buffer: PAnsiChar;
begin
    Buffer := GetMem(SizeOf(AnsiChar) * (MAX_BUFFER_LENGTH + 1));

    while true do
        if zmq_recv(RecvSocket, Buffer, MAX_BUFFER_LENGTH, 0) = -1 then
            SendCQPLog(CQLOG_ERROR, 'zmq_recv on RecvSocket failed, Error=' + IntToStr(zmq_errno()))
        else
            ProcessCommand(AnsiString(Buffer));
end;

procedure EnableBridge;
    var ThreadId: DWORD;
begin
    ZmqContext := zmq_ctx_new();
    SendCQPLog(CQLOG_INFO, 'ZeroMQ context ready');

    SendCQPLog(CQLOG_INFO, 'Binding PushSocket');
    PushSocket := zmq_socket(ZmqContext, ZMQ_PUSH);
    {PushSocketState := }BindSocket(PushSocket, PushSocketEndpoint);

    SendCQPLog(CQLOG_INFO, 'Binding RecvSocket');
    RecvSocket := zmq_socket(ZmqContext, ZMQ_PULL);
    {RecvSocketState := }BindSocket(RecvSocket, RecvSocketEndpoint);

    ThreadId := 0;
    RecvThreadHandle := CreateThread(nil, 0, @RecvSocketThread, nil, 0, ThreadId);
    SendCQPLog(CQLOG_INFO, 'RecvSocket thread created, ID=' + IntToStr(ThreadId));

    SendCQPLog(CQLOG_INFO, 'Sockets ready');
end;

procedure DisableBridge;
begin
    // if PushSocketState then
    //     zmq_close(PushSocket);
    // if RecvSocketState then
    //     zmq_close(RecvSocket);

    TerminateThread(RecvThreadHandle, 0);
    CloseHandle(RecvThreadHandle);
    SendCQPLog(CQLOG_INFO, 'RecvSocket thread closed');

    zmq_ctx_term(ZmqContext);
    SendCQPLog(CQLOG_INFO, 'ZeroMQ and sockets were destroyed');
end;

procedure PushString(Body: AnsiString);
begin
    zmq_send(PushSocket, PAnsiChar(Body), StrLen(PAnsiChar(Body)), 0);
end;

procedure PushGroupMessage(GroupId: AnsiString; UserId: AnsiString; Message: AnsiString; AnonymousNick: AnsiString);
    var Packet: TJSONObject;
begin
    Packet := TJSONObject.Create([]);
    try
        Packet.Strings['type'] := 'group';
        Packet.Strings['group'] := GroupId;
        Packet.Strings['user'] := UserId;
        Packet.Strings['content'] := Message;
        Packet.Strings['anonymous'] := AnonymousNick;
        PushString(Packet.AsJSON);
    finally
        Packet.Free();
    end;
end;

end.
