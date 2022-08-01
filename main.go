package main

import (
	"log"
	"os"
	"os/signal"
	"syscall"
)

func main() {
	sigchan := make(chan os.Signal, 1)
	signal.Notify(sigchan, syscall.SIGINT, syscall.SIGTERM)

	go TestTlsHttp2Server()
	go TestTlsHttp2Client()
	go TestTlsGrpcServer()
	go TestTlsGrpcClient()

	sig := <-sigchan
	log.Println(sig)
}
