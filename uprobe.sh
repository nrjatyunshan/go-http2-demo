echo 0 > /sys/kernel/debug/tracing/events/uprobes/enable
echo > /sys/kernel/debug/tracing/uprobe_events

# net/http.(*http2serverConn).writeHeaders
echo 'p:uprobes/http2serverConn_writeHeaders '$PWD'/main:0x211420 arg1=%ax arg2=%bx' >> /sys/kernel/debug/tracing/uprobe_events
# net/http.(*http2serverConn).processHeaders
echo 'p:uprobes/http2serverConn_processHeaders '$PWD'/main:0x20e340 arg1=%ax' >> /sys/kernel/debug/tracing/uprobe_events
# net/http.(*http2clientConnReadLoop).handleResponse
echo 'p:uprobes/http2clientConnReadLoop_handleResponse '$PWD'/main:0x21f240 arg1=%ax' >> /sys/kernel/debug/tracing/uprobe_events
# net/http.(*http2ClientConn).writeHeaders
echo 'p:uprobes/http2ClientConn_writeHeaders '$PWD'/main:0x21a800 arg1=%ax' >> /sys/kernel/debug/tracing/uprobe_events
# net/http.(*http2ClientConn).writeHeader
echo 'p:uprobes/http2ClientConn_writeHeader '$PWD'/main:0x21d240 arg1=%ax' >> /sys/kernel/debug/tracing/uprobe_events

echo 1 > /sys/kernel/debug/tracing/events/uprobes/enable
echo 'cat  /sys/kernel/debug/tracing/trace'