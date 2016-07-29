unit bridge;

{$MODE DELPHI}

interface

uses classes, cqp, fpjson, jsonparser, zmq;

procedure InitializeBridge(ConfigFilename: AnsiString);
procedure DeinitializeBridge;

procedure EnableBridge;
procedure DisableBridge;

implementation

var ZmqContext: Pointer = nil;
var PushSocket, RecvSocket: Pointer;
var PushSocketEndpoint, RecvSocketEndpoint: AnsiString;

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

    ZmqContext := zmq_ctx_new();
    SendCQPLog(CQLOG_INFO, 'ZeroMQ and sockets are ready');
end;

procedure DeinitializeBridge;
begin
    zmq_ctx_term(ZmqContext);
    SendCQPLog(CQLOG_INFO, 'ZeroMQ and sockets were destroyed');
end;

procedure EnableBridge;
begin
    // TODO: bind push socket
    // TODO: connect recv socket
end;

procedure DisableBridge;
begin
    // TODO: destroy push socket
    // TODO: destroy recv socket
end;

end.
