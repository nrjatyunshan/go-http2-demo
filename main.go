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

	go tlsHttp2Server()
	go tlsHttp2Client()
	go tlsGrpcServer()
	go tlsGrpcClient()

	sig := <-sigchan
	log.Println(sig)
}
