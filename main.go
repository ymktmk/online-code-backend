package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

func main() {
	http.HandleFunc("/api/v1/python", handeleExecPython)
	http.ListenAndServe(":10000", nil)
}

type Editor struct {
	Code string `json:code`
	Result string `json:result`
}

func handeleExecPython(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Headers", "*")
	w.Header().Set("Access-Control-Allow-Methods","POST")
	w.Header().Set("Content-Type", "application/json")

	var result string
	var editor Editor
	length := r.ContentLength
	body := make([]byte, length)
	r.Body.Read(body)
	if err := json.Unmarshal([]byte(body), &editor); err != nil {
		fmt.Println("Bad Request")
	}
	file_name := writeFile(editor.Code)
	result = dockerRun(file_name)
	editor.Result = result

	exec.Command(
		"rm", file_name,
	).Run()

	// ここでjsonで返す
	json.NewEncoder(w).Encode(editor)	
}

// dockerで実行して結果を返す
func dockerRun(file_name string) string {

	file_dir, _ := os.Getwd()

	cmd := exec.Command(
		"docker","run","-i","--rm","--name","python-script",
		"-v", file_dir + ":/usr/src/app",
		"-w","/usr/src/app",
		"python:latest",
		"python", file_name,
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

// ファイルにコードを書き込む
func writeFile(code string) string {

	file_dir, _ := os.Getwd()
	t := time.Now()
	file_name := t.Format(time.RFC3339) + ".py"
	file_path := filepath.Join(file_dir, file_name)

	f, err := os.Create(file_path)
	if err != nil {
		fmt.Println(err)
	}

	data := []byte(code)
	f.Write(data)
	// fmt.Println(string(data[:count]))
	return file_name
}