unit cqp;

interface

// CQAPI(int32_t) CQ_sendGroupMsg(int32_t AuthCode, int64_t groupid, const char *msg);
function CQ_sendGroupMsg(AuthCode: int32; groupid: int64; msg: PAnsiChar): int32; stdcall; external 'CQP';

implementation

end.
