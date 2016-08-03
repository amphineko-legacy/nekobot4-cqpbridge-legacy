unit zmq;

// Copyright (c) 2016 Naoki Rinmous
// This file or snippet of code was released under MIT license.

{$MACRO ON}

interface

uses ctypes;

// * ZeroMQ imports

// #define ZMQ_LINGER 17
const ZMQ_LINGER: Cint = 17;

// #define ZMQ_PULL 7
const ZMQ_PULL: Cint = 7;

// #define ZMQ_PUSH 8
const ZMQ_PUSH: Cint = 8;

// int zmq_bind (void *socket, const char *endpoint);
function zmq_bind(Socket: Pointer; Endpoint: PAnsiChar): Cint; cdecl; external 'libzmq';

// int zmq_close (void *s);
function zmq_close(Socket: Pointer): Cint; cdecl; external 'libzmq';

// void *zmq_ctx_new ();
function zmq_ctx_new(): Pointer; cdecl; external 'libzmq';

// int zmq_ctx_term (void *context);
function zmq_ctx_term(Context: Pointer): Cint; cdecl; external 'libzmq';

// int zmq_errno (void);
function zmq_errno(): Cint; cdecl; external 'libzmq';

// int zmq_recv (void *socket, void *buf, size_t len, int flags);
function zmq_recv(Socket: Pointer; Buffer: PAnsiChar; BufferLen: Csize_t; Flags: Cint): Cint; cdecl; external 'libzmq';

// int zmq_send (void *socket, void *buf, size_t len, int flags);
function zmq_send(Socket: Pointer; Buffer: PAnsiChar; Len: Csize_t; Flags: Cint): Cint; cdecl; external 'libzmq';

// int zmq_setsockopt (void *socket, int option_name, const void *option_value, size_t option_len);
function zmq_setsockopt(Socket: Pointer; OptionName: Cint; OptionValue: Pointer; OptionLen: Csize_t): Cint; cdecl; external 'libzmq';

// void *zmq_socket (void *context, int type);
function zmq_socket(Context: Pointer; SocketType: Cint): Pointer; cdecl; external 'libzmq';

implementation

end.
