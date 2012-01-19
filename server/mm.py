import webapp2
import gameelements

from google.appengine.ext import db
from google.appengine.api import users

COMMANDS = [
    'set_code' : '',
    'set_pip_on_row': ''
]

class GameTable(db.Model):
    player1 = db.UserProperty()
    player2 = db.UserProperty()
    gamestate = db.StringProperty()
    date = db.DateTimeProperty(auto_now_add=True)

class MasterMind(webapp2.RequestHandler):
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


app = webapp2.WSGIApplication([('/', MasterMind)], debug=True)

