unit bridge;

interface

uses ctypes, sysutils, windows, zmq;

procedure InitializeBridge;
procedure UninitializeBridge;

function CreateBridge: Cint;
procedure DestroyBridge;

procedure PushGroupMessage(GroupId: AnsiString; UserId: AnsiString; Content: AnsiString);

implementation

var ZmqContext, PushSocket: Pointer;

procedure InitializeBridge;
begin
    ZmqContext := zmq_ctx_new();
end;

procedure UninitializeBridge;
begin
    zmq_ctx_term(ZmqContext);
end;

function CreateBridge: Cint;
    var Endpoint: AnsiString;
begin
    PushSocket := zmq_socket(ZmqContext, ZMQ_PUSH);
    Endpoint := 'tcp://0.0.0.0:5371';
    zmq_bind(PushSocket, PAnsiChar(Endpoint));
end;

procedure DestroyBridge;
begin
    zmq_close(PushSocket);
end;

procedure PushGroupMessage(GroupId: AnsiString; UserId: AnsiString; Content: AnsiString);
begin
    zmq_send(PushSocket, PAnsiChar(Content), StrLen(PAnsiChar(Content)), 0);
end;

end.
