package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"os/exec"

	"github.com/pretty66/websocketproxy"
)

func main() {
	go func() {
		cmd := exec.Command("./bin/xray", "-config", "config.json")
		err := cmd.Run()
		if err != nil {
			log.Fatalf("cmd.Run() failed with %s\n", err)
		}
	}()

	wp, err := websocketproxy.NewProxy("ws://127.0.0.1:14753/c077651db84bcea", func(r *http.Request) error {
		// Permission to verify
		//r.Header.Set("Cookie", "----")
		// Source of disguise
		//r.Header.Set("Origin", "http://82.157.123.54:9010")
		return nil
	})
	if err != nil {
		log.Fatal(err)
	}

	http.HandleFunc("/c077651db84bcea", wp.Proxy)

	http.Handle("/", http.FileServer(http.Dir("web/")))

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
		log.Printf("Defaulting to port %s", port)
	}

	log.Printf("Listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

// indexHandler responds to requests with our greeting.
func indexHandler(w http.ResponseWriter, r *http.Request) {
	if r.URL.Path != "/" {
		http.NotFound(w, r)
		return
	}
	fmt.Fprint(w, "Hello, World!")
}
