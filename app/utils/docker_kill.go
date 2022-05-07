package utils

import "os/exec"

func DockerKill(language string) {
	exec.Command(
		"docker", "rm", "-f", language,
	).Run()
}
