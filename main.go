package main

import (
	"github.com/tarantool/go-tarantool"
	"time"
	"log"
)

func main() {
	opts := tarantool.Opts{
		User:    "tarantool",
		Pass:    "tarantool",
		Timeout: time.Second * 6,
	}
	_, err := tarantool.Connect("127.0.0.1:3302", opts)
	if err != nil {
		log.Fatal(err)
	}
}
