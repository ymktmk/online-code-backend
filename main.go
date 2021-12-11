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
	http.HandleFunc("/api/v1/python", handleExecPython)
	http.ListenAndServe(":10000", nil)
}

type Editor struct {
	Code string `json:code`
	Result string `json:result`
}

func handleExecPython(w http.ResponseWriter, r *http.Request) {

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Set("Access-Control-Allow-Headers", "*")
	w.Header().Set("Access-Control-Allow-Methods","POST")
	w.Header().Set("Content-Type", "application/json")

	var result string

	// リクエストbodyのjsonを構造体に変換
	body := make([]byte, r.ContentLength)
	r.Body.Read(body)
	var editor Editor
	json.Unmarshal(body, &editor)

	file_name := writeFile(editor.Code)
	result = dockerRun(file_name)
	editor.Result = result

	exec.Command(
		"rm","/go/src/work/" + file_name,
	).Run()

	editor_json, err := json.Marshal(editor)

	if err != nil {
		fmt.Println(err)
	}

	fmt.Println(string(editor_json))

	w.Header().Set("Content-Type", "application/json")
	w.Write(editor_json)
}

// dockerで実行して結果を返す
func dockerRun(file_name string) string {

	// コンテナ間マウント
	cmd := exec.Command(
		"docker","run","-i","--rm",
		"--volumes-from","code",
		"-w","/go/src/work",
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

	t := time.Now()
	file_name := t.Format(time.RFC3339) + ".py"

	// コンテナ側に作ってホストと共有
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