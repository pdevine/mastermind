package board

import (
	"fmt"
	"time"
	"errors"
	"strings"
	"math/rand"
)

const (
	TotalRows = 10
	MaxColors = 8
	PipCount = 4
)

type Board struct {
	secret     []int
	Rows       []Row
	CurrentRow int
}

type Row struct {
	Pips  []int
	Score Score
}

type Score struct {
	Red   int
	White int
}

func NewBoard() *Board {
	b := &Board{}

	for cnt := 0; cnt < TotalRows; cnt++ {
		pips := make([]int, 4)
		r := Row{Pips: pips}
		b.Rows = append(b.Rows, r)
	}

	return b
}

func (b *Board) CheckSecretSet() bool {
	for _, v := range b.secret {
		if v == 0 {
			return false
		}
	}
	return true
}

func (b *Board) SetSecret(secret []int) error {
	if len(secret) != PipCount {
		return errors.New("Secret must be four values")
	}
	for cnt := 0; cnt < PipCount; cnt++ {
		if secret[cnt] < 1 || secret[cnt] > MaxColors {
			return fmt.Errorf("Secret values should be between 1 and %d", MaxColors)
		}
	}
	b.secret = secret
	return nil
}

func (b *Board) CheckScore(guess []int) Score {
	return CheckScore(guess, b.secret)
}

func (b *Board) SetRandomSecret() {
	rand.Seed(time.Now().UnixNano())
	b.secret = make([]int, PipCount)
	for cnt := 0; cnt < PipCount; cnt++ {
		b.secret[cnt] = rand.Intn(MaxColors)
	}
	fmt.Printf("Secret is: %+v\n", b.secret)

}

func CheckScore(guess, secret []int) Score {
	s := Score{}

	guessVals := make([]int, MaxColors)
	secretVals := make([]int, MaxColors)

	for cnt, _ := range guess {
		if guess[cnt] == secret[cnt] {
			s.Red += 1
		} else {
			guessVals[guess[cnt]]++
			secretVals[secret[cnt]]++
		}
	}

	for cnt := 0; cnt < MaxColors; cnt++ {
		s.White += min(guessVals[cnt], secretVals[cnt])
	}

	fmt.Printf("Red = %d White = %d\n", s.Red, s.White)
	return s
}

func (b *Board) GetRow(r int) (string, error) {
	if r < 0 || r >= TotalRows {
		return "", errors.New(fmt.Sprintf("Invalid row '%d'", r))
	}
	row := b.Rows[r]
	return strings.Join(strings.Fields(fmt.Sprint(row.Pips)), ","), nil
}

func (b *Board) GetBoard() ([]byte, error) {
	var br []string

	for cnt, _ := range b.Rows {
		r, _ := b.GetRow(cnt)
		br = append(br, r)
	}

	return []byte(strings.Join(br, "\n") + "\n"), nil
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
