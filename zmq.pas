unit zmq;

{$MACRO ON}

interface

uses ctypes;

const ZMQ_PUSH: Cint = 8;

// int zmq_bind (void *socket, const char *endpoint);
function zmq_bind(Socket: Pointer; Endpoint: PAnsiChar): Cint; cdecl; external 'libzmq';

// int zmq_close (void *s);
function zmq_close(Socket: Pointer): Cint; cdecl; external 'libzmq';

// void *zmq_ctx_new ();
function zmq_ctx_new(): Pointer; cdecl; external 'libzmq';

// int zmq_ctx_term (void *context);
function zmq_ctx_term(Context: Pointer): Cint; cdecl; external 'libzmq';

// int zmq_send (void *socket, void *buf, size_t len, int flags);
function zmq_send(Socket: Pointer; Buffer: Pointer; Len: Csize_t; Flags: Cint): Cint; cdecl; external 'libzmq';

// void *zmq_socket (void *context, int type);
function zmq_socket(Context: Pointer; SocketType: Cint): Pointer; cdecl; external 'libzmq';

implementation

end.
