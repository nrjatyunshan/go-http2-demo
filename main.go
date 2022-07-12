package main

import (
	"crypto/tls"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

// 默认支持 http1 和 http2
func tlsHttp2Server() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "text/plain")
		w.Write([]byte("This is an example server.\n"))
	})
	err := http.ListenAndServeTLS(":443", "server.crt", "server.key", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}

// 强制使用 http2
func tlsHttp2Client() {
	for {
		time.Sleep(time.Second * 10)
		client := &http.Client{Transport: &http.Transport{
			TLSClientConfig:   &tls.Config{InsecureSkipVerify: true},
			ForceAttemptHTTP2: true,
		}}
		resp, err := client.Get("https://localhost/")
		if err != nil {
			log.Fatalln(err)
		}
		log.Println(resp.Proto)
	}
}

func main() {
	sigchan := make(chan os.Signal, 1)
	signal.Notify(sigchan, syscall.SIGINT, syscall.SIGTERM)

	go tlsHttp2Server()
	go tlsHttp2Client()

	sig := <-sigchan
	log.Println(sig)
}
