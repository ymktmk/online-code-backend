package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"
	"github.com/gorilla/mux"
	"github.com/rs/cors"
)

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/api/v1/python", handleExec).Methods("POST")
	r.HandleFunc("/api/v1/php", handleExec).Methods("POST")
	r.HandleFunc("/api/v1/node", handleExec).Methods("POST")
	r.HandleFunc("/api/v1/ruby", handleExec).Methods("POST")
	r.HandleFunc("/api/v1/go", handleExec).Methods("POST")
	r.HandleFunc("/api/v1/dart", handleExec).Methods("POST")
	c := cors.AllowAll().Handler(r)
	http.ListenAndServe(":10000", c)
}

type Editor struct {
	Code string `json:"code"`
	Result string `json:"result"`
}

// *** Python ***
func handleExec(w http.ResponseWriter, r *http.Request) {

	// json
	body := make([]byte, r.ContentLength)
	r.Body.Read(body)
	var editor Editor
	json.Unmarshal(body, &editor)

	// language
	str := string(r.URL.String())
	language := strings.Replace(str, "/api/v1/", "", 1)

	// write
	file_name := writeFile(editor.Code, language)

	for {

        channel := make(chan string)

        go func() {
            result := dockerRun(file_name, language)
            channel <- result
        }()
        
		select {
			// not time out
			case result := <-channel:
				editor.Result = result
				deleteFile(file_name)
				response, err := json.Marshal(editor)
			
				if err != nil {
					fmt.Println(err)
				}
			
				w.Header().Set("Content-Type", "application/json")
				w.Write(response)
				return
			// time out
			case <-time.After(3 * time.Second):
				dockerKill(language)
				editor.Result = "Error: TimeOut"
				deleteFile(file_name)
				response, err := json.Marshal(editor)

				if err != nil {
					fmt.Println(err)
				}

				w.Header().Set("Content-Type", "application/json")
				w.Write(response)
                return
		}
    }

}

func writeFile(code string, language string) string {
	
	var file_name string

	switch language {
		case "python":
			file_name = "main.py"
		case "php":
			file_name = "main.php"
		case "node":
			file_name = "main.js"
		case "ruby":
			file_name = "main.rb"
		case "go":
			file_name = "main.go"
		case "dart":
			file_name = "main.dart"
	}
	
	file_path := filepath.Join("go/src/work", file_name)

	f, err := os.Create(file_path)

	if err != nil {
		fmt.Println(err)
	}

	data := []byte(code)
	f.Write(data)
	// fmt.Println(string(data[:count]))
	return file_name
}

func dockerRun(file_name string, language string) string {

	cmd := exec.Command(
		"docker","run","-i","--rm",
		"--name",language,
		"--volumes-from","code",
		"-w","/go/src/work",
		language,
		language, file_name,
	)

	stdin, err := cmd.StdinPipe()

	if err != nil {
		fmt.Println(err)
	}

	io.WriteString(stdin, "hoge foo bar")
	stdin.Close()
	out, err := cmd.CombinedOutput()

	if err != nil {
		fmt.Println(err)
	}

	return string(out)
}

func dockerKill(language string) {
	exec.Command(
        "docker","rm","-f",language,
    ).Run()
}

func deleteFile(file_name string) {
	exec.Command(
		"rm","/go/src/work/" + file_name,
	).Run()
}
