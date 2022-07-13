#!/bin/bash

go mod tidy
go build
readelf -w main > /tmp/main.dwarf

Addr(){
	((tmp=`cat /tmp/main.dwarf | grep -A1 $1 | grep DW_AT_low_pc | awk '{print $4}' | head -n 1`))
	echo $[$tmp - 0x400000]
}

echo 0 > /sys/kernel/debug/tracing/events/uprobes/enable
echo > /sys/kernel/debug/tracing/uprobe_events

# net/http.(*http2serverConn).writeHeaders
addr=`Addr "net/http.(\*http2serverConn).writeHeaders$"`
echo 'p:uprobes/http2serverConn_writeHeaders '$PWD'/main:'$addr >> /sys/kernel/debug/tracing/uprobe_events

# net/http.(*http2serverConn).processHeaders
addr=`Addr "net/http.(\*http2serverConn).processHeaders$"`
echo 'p:uprobes/http2serverConn_processHeaders '$PWD'/main:'$addr >> /sys/kernel/debug/tracing/uprobe_events

# net/http.(*http2clientConnReadLoop).handleResponse
addr=`Addr "net/http.(\*http2clientConnReadLoop).handleResponse$"`
echo 'p:uprobes/http2clientConnReadLoop_handleResponse '$PWD'/main:'$addr >> /sys/kernel/debug/tracing/uprobe_events

# net/http.(*http2ClientConn).writeHeaders
addr=`Addr "net/http.(\*http2ClientConn).writeHeaders$"`
echo 'p:uprobes/http2ClientConn_writeHeaders '$PWD'/main:'$addr >> /sys/kernel/debug/tracing/uprobe_events

# net/http.(*http2ClientConn).writeHeader
addr=`Addr "net/http.(\*http2ClientConn).writeHeader$"`
echo 'p:uprobes/http2ClientConn_writeHeader '$PWD'/main:'$addr >> /sys/kernel/debug/tracing/uprobe_events

# google.golang.org/grpc/internal/transport.(*loopyWriter).writeHeader
addr=`Addr "google.golang.org/grpc/internal/transport.(\*loopyWriter).writeHeader$"`
echo 'p:uprobes/loopyWriter_writeHeader '$PWD'/main:'$addr >> /sys/kernel/debug/tracing/uprobe_events

# google.golang.org/grpc/internal/transport.(*http2Client).operateHeaders
addr=`Addr "google.golang.org/grpc/internal/transport.(\*http2Client).operateHeaders$"`
echo 'p:uprobes/http2Client_operateHeaders '$PWD'/main:'$addr >> /sys/kernel/debug/tracing/uprobe_events

# google.golang.org/grpc/internal/transport.(*http2Server).operateHeaders
addr=`Addr "google.golang.org/grpc/internal/transport.(\*http2Server).operateHeaders$"`
echo 'p:uprobes/http2Server_operateHeaders '$PWD'/main:'$addr >> /sys/kernel/debug/tracing/uprobe_events

echo > /sys/kernel/debug/tracing/trace
echo 1 > /sys/kernel/debug/tracing/events/uprobes/enable

echo 'cat /sys/kernel/debug/tracing/trace'