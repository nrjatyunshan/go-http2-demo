package main

import (
	"crypto/tls"
	"log"
	"net/http"
	"time"
)

// 强制使用 http2
func TestTlsHttp2Client() {
	client := &http.Client{Transport: &http.Transport{
		TLSClientConfig:   &tls.Config{InsecureSkipVerify: true},
		ForceAttemptHTTP2: true,
	}}

	for {
		req, err := http.NewRequest("GET", "https://localhost/", nil)
		if err != nil {
			log.Fatalln(err)
		}
		req.Header = http.Header{
			"Test": {time.Now().String()},
		}
		time.Sleep(time.Second * 10)
		_, err = client.Do(req)
		if err != nil {
			log.Fatalln(err)
		}
	}
}
