package router

import (
	"code/app/controller"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func NewRouter() *echo.Echo {
	e := echo.New()
	e.Use(middleware.Logger())
	e.Use(middleware.Recover())
	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"http://localhost:8080"},
		AllowHeaders: []string{echo.HeaderOrigin, echo.HeaderContentType, echo.HeaderAccept},
		AllowMethods: []string{echo.GET, echo.POST},
	}))
	e.POST("/api/v1/python", controller.HandleExec)
	e.POST("/api/v1/php", controller.HandleExec)
	e.POST("/api/v1/node", controller.HandleExec)
	e.POST("/api/v1/ruby", controller.HandleExec)
	e.POST("/api/v1/go", controller.HandleExec)
	e.POST("/api/v1/dart", controller.HandleExec)
	return e
}
