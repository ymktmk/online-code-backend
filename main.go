package main

import (
	"fmt"
	// ファイル操作
	"os"
	"os/exec"
	"io"
	"path/filepath"
	"html/template"
	"net/http"
)

func main() {
	http.HandleFunc("/", handleIndex)
	http.HandleFunc("/code/", handleCode)
	// 順番が逆になると404エラー
	http.ListenAndServe(":10000", nil)
}

// index ok
func handleIndex(w http.ResponseWriter, r *http.Request) {

	var result string
	if r.Method == "POST" {
		code := r.FormValue("code")
		result = docker(code)
		// 結果
		fmt.Println(result)
	} else {
		result = ""
	}

	t, err := template.ParseFiles("templates/index.html")
	if err != nil { 
		panic(err.Error())
	}

	

	t.Execute(w,result)
}

func handleCode(w http.ResponseWriter, r *http.Request) {
	code := r.FormValue("code")
	docker(code)
	// Dockerにコードを実行してもらう
	http.Redirect(w,r,"/", 302)
}

// dockerでコードを実行する
func docker(code string) string {

	// 実行元のディレクトリ
	// file_dir := "/Users/yamaokatomoki/history"
	file_dir := "/Users/yamaokatomoki/OnlineCode"
	// ファイル名を決定する
	file_name := "pine.py"
	// ディレクトリとファイル名を結合する
	file_path := filepath.Join(file_dir, file_name)

	// ファイルを書き込み権限つきで開く
	f, err := os.Create(file_path)
	if err != nil {
		fmt.Println("エラーが発生")
		fmt.Println(err)
	}
	// バイナリデータ
	data := []byte(code)
	// 書き込む
	// count, err := 
	f.Write(data)
	// これで表示できる
	// fmt.Println(string(data[:count]))

	// 実行するコマンド 変数のところは{}にする
	// docker_cmd := "docker run -i --rm --name my-running-script -v /Users/yamaokatomoki/history:/usr/src/myapp -w /usr/src/myapp python:3.7 python pine.py"
	cmd := exec.Command(
		"python",
		"pine.py",	
		// "docker",
		// "run",
		// "-i",
		// "--rm",
		// "python",
		// "-v",
		// "/Users/yamaokatomoki/history:/usr/src/myapp",
		// "-w",
		// "/usr/src/myapp",
		// "python:3.7",
		// "python",
		// "pine.py",
	)

	stdin, err := cmd.StdinPipe()

	if err != nil {
		fmt.Println("error1")
		fmt.Println(err)
	}

	io.WriteString(stdin, "hoge foo bar")
	stdin.Close()
	out, err := cmd.CombinedOutput()

	// ここでエラーが発生する
	if err != nil {
		fmt.Println("error2")
		// exit status 1 と表示される
		fmt.Println(err)
	}

	return string(out)
	// fmt.Println(string(out))
	
}