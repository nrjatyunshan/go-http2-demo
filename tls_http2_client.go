package main

import (
	"crypto/tls"
	"log"
	"net/http"
	"time"
)

// 强制使用 http2
func tlsHttp2Client() {
	client := &http.Client{Transport: &http.Transport{
		TLSClientConfig:   &tls.Config{InsecureSkipVerify: true},
		ForceAttemptHTTP2: true,
	}}

	for {
		time.Sleep(time.Second * 10)
		_, err := client.Get("https://localhost/")
		if err != nil {
			log.Fatalln(err)
		}
	}
}
