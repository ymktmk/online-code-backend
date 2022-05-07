package utils

import (
	"io"
	"log"
	"os/exec"
)

func DockerRun(file_name string, language string) string {
	cmd := exec.Command(
		"docker", "run", "-i", "--rm",
		"--name", language,
		"--volumes-from", "code",
		"-w", "/go/src/work",
		language,
		language, file_name,
	)

	stdin, err := cmd.StdinPipe()
	if err != nil {
		log.Println(err)
	}

	io.WriteString(stdin, "hoge foo bar")
	stdin.Close()

	output, err := cmd.CombinedOutput()
	if err != nil {
		log.Println(err)
	}

	return string(output)
}
