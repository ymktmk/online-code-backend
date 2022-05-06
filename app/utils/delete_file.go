package utils

import "os/exec"

func DeleteFile(file_name string) {
	exec.Command(
		"rm", "/go/src/work/" + file_name,
	).Run()
}
