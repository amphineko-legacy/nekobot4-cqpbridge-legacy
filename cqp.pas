unit cqp;

interface

uses ctypes;

// Event Return Codes

const EVENT_IGNORE: Cint32 = 0;
const EVENT_BLOCK: Cint32 = 1;

// Log Level Codes

// #define CQLOG_DEBUG 0
const CQLOG_DEBUG: Cint32 = 0;       
// #define CQLOG_INFO 10
const CQLOG_INFO: Cint32 = 10;       
// #define CQLOG_INFOSUCCESS 11
const CQLOG_INFOSUCCESS: Cint32 = 11;
// #define CQLOG_INFORECV 12
const CQLOG_INFORECV: Cint32 = 12;   
// #define CQLOG_INFOSEND 13
const CQLOG_INFOSEND: Cint32 = 13;   
// #define CQLOG_WARNING 20
const CQLOG_WARNING: Cint32 = 20;    
// #define CQLOG_ERROR 30
const CQLOG_ERROR: Cint32 = 30;      
// #define CQLOG_FATAL 40
const CQLOG_FATAL: Cint32 = 40; 

// CQP API

// CQAPI(int32_t) CQ_addLog(int32_t AuthCode, int32_t priority, const char *category, const char *content);
function CQ_addLog(AuthCode: Cint32; priority: Cint32; category: PAnsiChar; content: PAnsiChar): Cint32; stdcall; external 'cqp';

// CQP Wrapped API

procedure SendCQPLog(LogLevel: Cint32; Content: AnsiString);
procedure SetCQPSession(Session: Cint32);

implementation

var CurrentSession: Cint32;
var DefaultCategory: AnsiString = 'CQPBridge';

procedure SendCQPLog(LogLevel: Cint32; Content: AnsiString);
begin
    CQ_addLog(CurrentSession, LogLevel, PAnsiChar(DefaultCategory), PAnsiChar(Content));
end;

procedure SetCQPSession(Session: Cint32);
begin
    CurrentSession := Session;
end;

end.
