package main

import "code/app/router"

func main() {
	e := router.NewRouter()
	e.Logger.Fatal(e.Start(":8080"))
}
