package controller

import (
	"code/app/domain"
	"code/app/utils"
	"net/http"
	"strings"
	"time"

	"github.com/labstack/echo"
)

func HandleExec(c echo.Context) (err error) {
	editor := new(domain.Editor)
	if err = c.Bind(editor); err != nil {
		return echo.NewHTTPError(http.StatusBadRequest, err.Error())
	}

	str := string(c.Request().URL.String())
	language := strings.Replace(str, "/api/v1/", "", 1)

	file_name := utils.WriteFile(editor.Code, language)

	for {
		channel := make(chan string)
		go func() {
			result := utils.DockerRun(file_name, language)
			channel <- result
		}()
		select {
			// not time out
			case result := <-channel:
				editor.Result = result
				utils.DeleteFile(file_name)
				return c.JSON(http.StatusOK, editor)
			// time out
			case <-time.After(3 * time.Second):
				utils.DockerKill(language)
				editor.Result = "Error: TimeOut"
				utils.DeleteFile(file_name)
				return c.JSON(http.StatusOK, editor)
		}
	}
}
