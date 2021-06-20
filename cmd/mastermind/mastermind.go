package main

import (
	"fmt"

	"github.com/pdevine/mastermind/internal/gameplay"
)

func main() {
	fmt.Printf("Hello world!\n")

	gameplay.Listen()
}

/*
	b := gameplay.NewBoard()
	b.SetRandomSecret()
	b.CheckScore([]int{1, 2, 3, 4})
*/

