import gameelements

from google.appengine.ext import db
from google.appengine.api import users
from google.appengine.ext import webapp

import logging

from pyamf.remoting.gateway.google import WebAppGateway

COMMANDS = {
    'set_code' : '',
    'set_pip_on_row': ''
}

class GameTable(db.Model):
    player1 = db.UserProperty()
    player2 = db.UserProperty()
    gamestate = db.StringProperty()
    date = db.DateTimeProperty(auto_now_add=True)

class MasterMind(webapp.RequestHandler):
    def get(self):
        self.response.headers['Content-Type'] = 'text/plain'

        game_id = self.request.get('game_id')

        game = gameelements.Game()

        if not users.get_current_user():
            pass
            
        if game_id:
            self.response.out.write(game_id + "\n")
            gameDbEntry = db.get(game_id)
            game.deserialize(gameDbEntry.gamestate)
            self.response.out.write(game.state)

        else:
            gameDbEntry = GameTable(
                player1=users.get_current_user(),
                gamestate=game.serialize())
            game_key = gameDbEntry.put()
            

            self.response.out.write(game_key)

def _getGame(game_id):
    game = gameelements.Game()
    gameDbEntry = db.get(game_id)
    game.deserialize(gameDbEntry.gamestate)
    return (game, gameDbEntry)

def newGame():
    '''Create a new game'''

    # figure out the user here
    user = users.get_current_user()
    logging.info(user)

    game = gameelements.Game()

    gameDbEntry = GameTable(
        player1=user,
        gamestate=game.serialize())
    game_key = gameDbEntry.put()

    return str(game_key)

def getGameState(game_id):
    '''Get the state of a game'''

    logging.info("Got gamestate for %s" % game_id)
    game, gameDbEntry = _getGame(game_id)
    return game.state

def getCurrentRow(game_id):
    game, gameDbEntry = _getGame(game_id)
    return game.get_row()

def setRow(game_id, guess):
    game, gameDbEntry = _getGame(game_id)
    game.set_row(guess)
    logging.info(game.__dict__)
    gameDbEntry.gamestate = game.serialize()
    gameDbEntry.put()

def setPipInRow(game_id, position, color):
    game, gameDbEntry = _getGame(game_id)
    game.set_pip_in_row(position, color)
    gameDbEntry.gamestate = game.serialize()
    gameDbEntry.put()

def getCode(game_id):
    game, gameDbEntry = _getGame(game_id)
    return game.code

def setCode(game_id, code):
    game, gameDbEntry = _getGame(game_id)
    game.set_code(code)
    gameDbEntry.gamestate = game.serialize()
    gameDbEntry.put()

def getLastScore(game_id):
    game, gameDbEntry = _getGame(game_id)
    return game.last_score

def getLastRow(game_id):
    game, gameDbEntry = _getGame(game_id)
    return game.last_row

def getPipsPerRow(game_id):
    game, gameDbEntry = _getGame(game_id)
    return game.pips_per_row

def setPipsPerRow(game_id, pips_per_row):
    game, gameDbEntry = _getGame(game_id)
    game.pips_per_row = pips_per_row
    gameDbEntry.gamestate = game.serialize()
    gameDbEntry.put()
    
def getColorRange(game_id):
    game, gameDbEntry = _getGame(game_id)
    return game.color_range

def setColorRange(game_id, c_range):
    game, gameDbEntry = _getGame(game_id)
    game.color_range = c_range
    gameDbEntry.gamestate = game.serialize()
    gameDbEntry.put()

def getSelectedColor(game_id):
    game, gameDbEntry = _getGame(game_id)
    return game.selected_color

def setSelectedColor(game_id, color):
    game, gameDbEntry = _getGame(game_id)
    game.selected_color = color
    gameDbEntry.gamestate = game.serialize()
    gameDbEntry.put()

def getTotalRows(game_id):
    game, gameDbEntry = _getGame(game_id)
    return game.total_rows

def setTotalRows(game_id, total_rows):
    game, gameDbEntry = _getGame(game_id)
    game.total_rows = total_rows

debug_enabled = True

services = {
    'mastermind.newGame' : newGame,
    'mastermind.getGameState' : getGameState,
    'mastermind.getCurrentRow' : getCurrentRow,
    'mastermind.setRow' : setRow,
    'mastermind.setPipInRow' : setPipInRow,
    'mastermind.getCode' : getCode,
    'mastermind.setCode' : setCode,
    'mastermind.getLastScore' : getLastScore,
    'mastermind.getLastRow' : getLastRow,
    'mastermind.getPipsPerRow' : getPipsPerRow,
    'mastermind.setPipsPerRow' : setPipsPerRow,
    'mastermind.getColorRange' : getColorRange,
    'mastermind.setColorRange' : setColorRange,
    'mastermind.getSelectedColor' : getSelectedColor,
    'mastermind.setSelectedColor' : setSelectedColor,
    'mastermind.getTotalRows' : getTotalRows,
    'mastermind.setTotalRows' : setTotalRows,
}

gateway = WebAppGateway(services, logger=logging, debug=debug_enabled)

application_paths = [('/', gateway), ('/mm', MasterMind)]
app = webapp.WSGIApplication(application_paths, debug=debug_enabled)


