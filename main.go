package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strings"
	"os"
	"os/exec"
	"path/filepath"
)

func main() {
	http.HandleFunc("/api/v1/python", handleExec)
	http.HandleFunc("/api/v1/php", handleExec)
	http.HandleFunc("/api/v1/node", handleExec)
	http.HandleFunc("/api/v1/ruby", handleExec)
	http.HandleFunc("/api/v1/go", handleExec)
	http.HandleFunc("/api/v1/dart", handleExec)
	http.ListenAndServe(":10000", nil)
}

type Editor struct {
	Code string `json:"code"`
	Result string `json:"result"`
}

// *** Python ***
func handleExec(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Headers", "*")
	w.Header().Set("Access-Control-Allow-Methods","POST")
	w.Header().Set("Content-Type", "application/json")

	var result string

	// json
	body := make([]byte, r.ContentLength)
	r.Body.Read(body)
	var editor Editor
	json.Unmarshal(body, &editor)

	// language
	str := string(r.URL.String())
	language := strings.Replace(str, "/api/v1/", "", 1)

	file_name := writeFile(editor.Code, language)
	result = dockerRun(file_name, language)
	editor.Result = result

	exec.Command(
		"rm","/go/src/work/" + file_name,
	).Run()

	editor_json, err := json.Marshal(editor)

	if err != nil {
		fmt.Println(err)
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(editor_json)
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

