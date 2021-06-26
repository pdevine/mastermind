package gameplay

import (
	"os"
	"fmt"
	"net"
	"bufio"
	"strconv"
	"strings"
	"encoding/json"

	"github.com/google/uuid"
	log "github.com/sirupsen/logrus"
	"github.com/pdevine/mastermind/internal/board"
)

var players []*Player
var games map[string]*Game

type Player struct {
	Conn   net.Conn
	Game   *Game
	Name   string
	Color  int
	PipBuf []int
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

type ReturnData struct {
	Type        int    `json: type`
	Message     string `json: msg`
	PlayerName  string `json: player, omitempty`
	Pip         int    `json: pip, omitempty`
	Color       int    `json: color, omitempty`
	Score       []int  `json: score, omitempty`
	GameID      string `json: game_id, omitempty`
}

const (
	RETURN_MESSAGE = iota
	RETURN_NEWGAME
	RETURN_GAMEOVER
	RETURN_GAMEJOINED
	RETURN_GAMESTARTED
	RETURN_ERROR
	RETURN_SCORE
	RETURN_PIPSET
	RETURN_COLORSET
)

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
			} else if cmd[0] == "/setpip" {
				p.SetPip(convertArgs(cmd[1]))
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

func sendMessage(to, from *Player, msg string) {
	d := ReturnData{
		Type:    RETURN_MESSAGE,
		Message: msg,
	}
	if from != nil {
		d.PlayerName = from.Name
	}
	json.NewEncoder(to.Conn).Encode(d)
}

func (g *Game) sendData(d ReturnData) {
	for _, player := range []*Player{g.Player1, g.Player2} {
		if player != nil {
			json.NewEncoder(player.Conn).Encode(d)
		}
	}
}

func sendError(p *Player, msg string) {
	d := ReturnData{
		Type:    RETURN_ERROR,
		Message: msg,
	}
	json.NewEncoder(p.Conn).Encode(d)
}

func (p *Player) SetPip(v []int) {
	if len(v) == 0 {
		sendError(p, "No pip specified")
		return
	}
	if v[0] < 0 || v[0] >= board.PipCount {
		sendError(p, "Invalid pip specified")
		return
	}
	if p == p.Game.CodeBreaker && p.Game.State == GAME_RUNNING {
		score, err := p.Game.Board.SetPip(v[0], p.Color)
		var d ReturnData
		d = ReturnData{
			Type:    RETURN_PIPSET,
			Message: fmt.Sprintf("Pip %d set to value %d", v[0], p.Color),
			Pip:     v[0],
			Color:   p.Color,
		}
		p.Game.sendData(d)

		if err == nil {
			d = ReturnData{
				Type:    RETURN_SCORE,
				Message: fmt.Sprintf("Score: (%d, %d)", score.Red, score.White),
				Score:   []int{score.Red, score.White},
			}
			p.Game.sendData(d)
			if score.Red == 4 {
				p.Game.State = GAME_OVER
				d = ReturnData{
					Type:    RETURN_GAMEOVER,
					Message: "The code was cracked!",
				}
				p.Game.sendData(d)
			}
		}
	}
}

func (p *Player) SetColor(v []int) {
	if len(v) == 0 {
		sendError(p, "No color specified")
		return
	}
	if v[0] < 0 || v[0] >= board.MaxColors {
		sendError(p, "Invalid color specified")
		return
	}

	p.Color = v[0]
	d := ReturnData{
		Type:    RETURN_COLORSET,
		Message: fmt.Sprintf("Color set to %d", p.Color),
		Color:   p.Color,
	}
	p.Game.sendData(d)
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

	d := ReturnData{
		Type:    RETURN_NEWGAME,
		Message: fmt.Sprintf("New game %s started", u),
		GameID:  u.String(),
	}
	p.Game.sendData(d)
}

func (p *Player) DisplayBoard() {
	log.Info("Display board")

	if p.Game != nil {
		b, _ := p.Game.Board.GetBoard()
		p.Conn.Write(b)
	} else {
		sendError(p, "Player hasn't joined a game")
	}
}

func (p *Player) JoinGame(u string) {
	log.Infof("uuid = '%s'", u)
	g, ok := games[u]
	if !ok {
		sendError(p, fmt.Sprintf("Game %s not found", u))
		return
	}

	if g.Player2 != nil {
		sendError(p, fmt.Sprintf("Game %s is full", u))
		return
	}

	g.Player2 = p
	p.Game = g

	d := ReturnData{
		Type:    RETURN_GAMEJOINED,
		Message: fmt.Sprintf("Player joined game"),
		GameID:  u,
	}
	g.sendData(d)
}

func (p *Player) SetSecret(s []int) {
	if p.Game.State == GAME_RUNNING {
		sendError(p, "Game has already started")
		return
	} else if p.Game.State == GAME_OVER {
		sendError(p, "Game has already finished")
		return
	}

	err := p.Game.Board.SetSecret(s)
	if err != nil {
		sendError(p, "Couldn't set the secret")
		return
	}

	if p.Game.Player1 == nil || p.Game.Player2 == nil {
		sendError(p, "Wait for another player before setting the secret")
		return
	}

	log.Infof("Started game '%s'", p.Game.ID)
	if p.Game.Player1 == p {
		p.Game.CodeBreaker = p.Game.Player2
	} else {
		p.Game.CodeBreaker = p.Game.Player1
	}

	p.Game.State = GAME_RUNNING

	d := ReturnData{
		Type:    RETURN_GAMESTARTED,
		Message: "Secret set. Game started",
	}
	p.Game.sendData(d)
}
