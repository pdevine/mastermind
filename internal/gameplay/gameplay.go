package gameplay

import (
	"os"
	"fmt"
	"net"
	"bufio"
	"strconv"
	"strings"

	"github.com/google/uuid"
	log "github.com/sirupsen/logrus"
	"github.com/pdevine/mastermind/internal/board"
)

var players []*Player
var games map[string]*Game

type Player struct {
	Conn  net.Conn
	Game  *Game
	Color int
}

const (
	GAME_INIT = iota
	GAME_RUNNING
	GAME_OVER
)

type GameState int

type Game struct {
	ID	    string
	Player1     *Player
	Player2     *Player
	Watchers    []*Player
	CodeBreaker *Player
	Board       *board.Board
	State       GameState
}

func NewPlayer(c net.Conn) *Player {
	log.Info("New player connected")

	p := &Player{
		Conn: c,
	}
	return p
}


func Listen() {
	l, err := net.Listen("tcp", "localhost:8080")
        if err != nil {
		log.Errorf("Couldn't listen on localhost:8080: %s", err.Error())
		os.Exit(1)
	}
	defer l.Close()

	games = make(map[string]*Game)

	for {
		c, err := l.Accept()
		if err != nil {
			log.Errorf("Error connecting: %s", err.Error())
			continue
		}

		p := NewPlayer(c)
		players = append(players, p)

		go p.handleConnection()
	}
}


func (p *Player) handleConnection() {
	for {
		buf, err := bufio.NewReader(p.Conn).ReadBytes('\n')
		if err != nil {
			// disconnect
			p.Conn.Close()
			break
		}

		cmd := strings.SplitN(strings.TrimSpace(string(buf)), " ", 2)
		log.Infof("Str = '%s' Cmd = '%+v' Len = %d", string(buf), cmd, len(cmd))
		if len(cmd) > 0 {
			if cmd[0] == "/shout" {
				p.Shout(cmd[1])
			} else if cmd[0] == "/games" {
				p.ListGames()
			} else if cmd[0] == "/new" {
				p.NewGame()
			} else if cmd[0] == "/display" {
				p.DisplayBoard()
			} else if cmd[0] == "/join" {
				p.JoinGame(cmd[1])
			} else if cmd[0] == "/setsecret" {
				p.SetSecret(convertArgs(cmd[1]))
			} else if cmd[0] == "/setcolor" {
				p.SetColor(convertArgs(cmd[1]))
			}
		}

		// commands
		//   * list players	/players
		//   * list games	/games
		//   * watch game	/watch <game #>
		//   * new game		/new
		//   * join game	/join <game #>
		//   * leave game	/leave
		//   * quit		/quit
		//   * display board    /display
		//   * set pip		/setpip <pip #>
		//   * set colour	/setcolor <colour>
		//   * set secret       /setsecret <val> <val> <val> <val>
		//   * shout message	/shout <msg>
		//   * say message	/say <msg>

	}
}

func convertArgs(arg string) []int {
	var vals []int
	for _, v := range strings.Split(arg, " ") {
		iv, err := strconv.Atoi(v)
		if err != nil {
			iv = 0
		}
		vals = append(vals, iv)
	}
	return vals
}

func (p *Player) SetPip(v []int) {
	if len(v) == 0 {
		p.Conn.Write([]byte("No pip specified\n"))
		return
	}
	if v[0] < 0 || v[0] >= board.PipCount {
		p.Conn.Write([]byte("Invalid pip specified\n"))
		return
	}
}

func (p *Player) SetColor(v []int) {
	if len(v) == 0 {
		p.Conn.Write([]byte("No color specified\n"))
		return
	}
	if v[0] < 0 || v[0] >= board.MaxColors {
		p.Conn.Write([]byte("Invalid color specified\n"))
		return
	}

	p.Color = v[0]
}


func (p *Player) ListGames() {
	for _, g := range games {
		p.Conn.Write([]byte(g.ID + "\n"))
	}
}

func (p *Player) Shout(msg string) {
	for _, player := range players {
		player.Conn.Write([]byte(fmt.Sprintf("msg %s", msg)))
	}
}

func (p *Player) NewGame() {
	u, _ := uuid.NewUUID()
	log.Infof("New game %s created", u.String())

	g := &Game{
		ID:      u.String(),
		Player1: p,
		Board:   board.NewBoard(),
	}
	p.Game = g
	games[g.ID] = g

	p.Conn.Write([]byte(fmt.Sprintf("New Game %s started\n", g.ID)))
}

func (p *Player) DisplayBoard() {
	log.Info("Display board")

	if p.Game != nil {
		b, _ := p.Game.Board.GetBoard()
		p.Conn.Write(b)
	} else {
		p.Conn.Write([]byte("Player hasn't joined a game\n"))
	}
}

func (p *Player) JoinGame(u string) {
	log.Infof("uuid = '%s'", u)
	g, ok := games[u]
	if !ok {
		p.Conn.Write([]byte(fmt.Sprintf("Game %s not found\n", u)))
		return
	}

	if g.Player2 != nil {
		p.Conn.Write([]byte(fmt.Sprintf("Game %s is full\n", u)))
		return
	}

	g.Player2 = p
	p.Game = g

	p.Conn.Write([]byte(fmt.Sprintf("Joined game %s\n", u)))
	g.Player1.Conn.Write([]byte("Player joined game\n"))
}

func (p *Player) SetSecret(s []int) {
	if p.Game.State == GAME_RUNNING {
		p.Conn.Write([]byte("Game has already started\n"))
		return
	} else if p.Game.State == GAME_OVER {
		p.Conn.Write([]byte("Game has already finished\n"))
		return
	}

	err := p.Game.Board.SetSecret(s)
	if err != nil {
		p.Conn.Write([]byte("Couldn't set the secret\n"))
		return
	}

	if p.Game.Player1 == nil || p.Game.Player2 == nil {
		p.Conn.Write([]byte("Wait for another player before setting the secret\n"))
		return
	}

	log.Infof("Started game '%s'", p.Game.ID)
	p.Game.State = GAME_RUNNING

	for _, player := range []*Player{p.Game.Player1, p.Game.Player2} {
		player.Conn.Write([]byte("Secret set. Game started\n"))
		if player != p {
			p.Game.CodeBreaker = player
			player.Conn.Write([]byte("Guess the code!\n"))
		}
	}

}

func (p *Player) SetPip(pip, color int) {
	// XXX - need to be able to choose who does code setting / breaking
	if p.Game.Player2 == p && p.Game.State == GAME_INIT {
	}
}
