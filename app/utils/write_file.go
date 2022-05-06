package utils

import (
	"log"
	"os"
	"path/filepath"
)

func WriteFile(code string, language string) string {

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
		log.Println(err)
	}

	data := []byte(code)
	f.Write(data)
	// fmt.Println(string(data[:count]))
	return file_name
}
