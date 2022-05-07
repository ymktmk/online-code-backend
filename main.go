package main

import (
	"github.com/ymktmk/online-code-backend/app/router"

	"golang.org/x/crypto/acme/autocert"
)

func main() {
	e := router.NewRouter()
	e.AutoTLSManager.HostPolicy = autocert.HostWhitelist("api.code-run.ga")
	e.AutoTLSManager.Cache = autocert.DirCache("/var/www/.cache")
	e.Logger.Fatal(e.StartAutoTLS(":443"))
}
