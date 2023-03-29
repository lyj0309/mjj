package main

import (
	"fmt"
	"github.com/gorilla/websocket"
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"
	"os"
	"os/exec"
)

var xrayStatus = "ok"


func xray() {
	//./bin/xray -config config.json
	cmd := exec.Command("chmod", "+x", "./bin/x")
	err := cmd.Run()

	cmd = exec.Command("./bin/x", "-config", "config.json")
	err = cmd.Run()
	if err != nil {
		xrayStatus = err.Error()

		fmt.Printf("cmd.Run() failed with %s\n", err)
	}
}

var upgrader = websocket.Upgrader{     CheckOrigin: func(r *http.Request) bool {
            return true
        }} // use default options

func echo(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	
	if err != nil {
		log.Print("upgrade:", err)
		return
	}
	defer c.Close()
	for {
		mt, message, err := c.ReadMessage()
		if err != nil {
			log.Println("read:", err)
			break
		}
		log.Printf("recv: %s", message)
		err = c.WriteMessage(mt, message)
		if err != nil {
			log.Println("write:", err)
			break
		}
	}
}

func main() {
	go xray()
	
	port := "8080"

	http.HandleFunc("/c077651db84bcea/", serveReverseProxy)
	http.HandleFunc("/echo", echo)
	http.Handle("/", http.FileServer(http.Dir("web/")))
	http.HandleFunc("/status", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(xrayStatus))
	})

	if val, ok := os.LookupEnv("PORT"); ok {
		port = val
		log.Printf("Change port to %s", port)
	}


	log.Printf("Listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

func serveReverseProxy(res http.ResponseWriter, req *http.Request) {
	target := "http://127.0.0.1:14753"
	// target := "http://google.com/c077651db84bcea"
	// parse the url
	url, _ := url.Parse(target)

	// create the reverse proxy
	proxy := httputil.NewSingleHostReverseProxy(url)

	// Update the headers to allow for SSL redirection
	req.URL.Host = url.Host
	req.URL.Scheme = url.Scheme
	req.Header.Set("X-Forwarded-Host", req.Header.Get("Host"))
	req.Host = url.Host

	// Note that ServeHttp is non blocking and uses a go routine under the hood
	proxy.ServeHTTP(res, req)
}

// indexHandler responds to requests with our greeting.
func indexHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return
	}
	fmt.Fprint(w, "Hello, World!")
}
