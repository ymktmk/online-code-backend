package router

import (
	"github.com/ymktmk/online-code-backend/app/controller"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
)

func NewRouter() *echo.Echo {
	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(middleware.CORS())
	e.POST("/api/v1/python", controller.HandleExec)
	e.POST("/api/v1/php", controller.HandleExec)
	e.POST("/api/v1/node", controller.HandleExec)
	e.POST("/api/v1/ruby", controller.HandleExec)
	e.POST("/api/v1/go", controller.HandleExec)
	e.POST("/api/v1/dart", controller.HandleExec)
	return e
}
