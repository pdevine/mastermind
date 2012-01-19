import json

ERROR_GAME_STARTED = 'The game has already started'
ERROR_GAME_NOT_STARTED = 'The game has not started yet'
ERROR_GAME_OVER = 'The game is over'
ERROR_INCOMPLETE_GUESS = 'Not all values for the guess have been specified'
ERROR_INCOMPLETE_CODE = 'Not all values for the code have been specified'
ERROR_INVALID_COLOR = 'The value "%s" is not recognized'
ERROR_INVALID_POSITION = 'Invalid position %d.  Must be between 0 and %d'
ERROR_WRONG_ELEMENT_COUNT = '%d elements were specified.  %d expected'
ERROR_INVALID_VALUE = 'The value "%s" must be of type "%s"'

GAME_INITIALIZED = 'initialized'
GAME_STARTED = 'started'
GAME_OVER = 'game over'

class GameError(Exception):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)

class Score:
    def __init__(self):
        self.correct_positions = 0
        self.correct_colors = 0
        self.score_generated = False

    def score_guess(self, code, guess):
        code_c = list(code)
        guess_c = list(guess)

        if None in code:
            raise GameError(ERROR_INCOMPLETE_CODE)
        if None in guess:
            raise GameError(ERROR_INCOMPLETE_GUESS)

        for count in range(len(code_c)):
            if code_c[count] == guess_c[count]:
                code_c[count] = None
                guess_c[count] = None
                self.correct_positions += 1

        for code_count in range(len(code_c)):
            code_pip = code_c[code_count]
            if code_pip:
                for guess_count in range(len(guess_c)):
                    guess_pip = guess_c[guess_count]
                    if code_pip == guess_pip:
                        self.correct_colors += 1

        self.score_generated = True

    def __repr__(self):
        return "(%d, %d)" % (self.correct_positions, self.correct_colors)

class Game(object):
    def __init__(self):
        self._game_state = GAME_INITIALIZED

        self.rows = []
        self.scores = []

        self._total_rows = 10
        self._pips_per_row = 5
        self._color_range = range(1, 8+1)

        self._selected_color = 0;

        self._current_row = list([None]) * self.pips_per_row
        self._code = list([None]) * self.pips_per_row

    def get_state(self):
        return self._game_state

    state = property(get_state)

    def get_row(self):
        return self._current_row

    def set_row(self, guess):
        if self._game_state == GAME_OVER:
            raise GameError(ERROR_GAME_OVER)

        if self._game_state != GAME_STARTED:
            raise GameError(ERROR_GAME_NOT_STARTED)

        if None in guess:
            raise GameError(ERROR_INCOMPLETE_GUESS)

        if len(guess) != self.pips_per_row:
            raise GameError(ERROR_WRONG_ELEMENT_COUNT % 
                            (len(guess), self.pips_per_row))

        for color in guess:
            if color not in self.color_range:
                raise GameError(ERROR_INVALID_COLOR % color)

        score = Score()
        score.score_guess(self.code, guess)

        self.rows.append(list(guess))
        self.scores.append(score)

        self._current_row = list([None]) * self.pips_per_row

        # check if player won

        if score.correct_positions == self.pips_per_row:
            self._game_state = GAME_OVER

        # check if player lost

        if len(self.rows) >= self.total_rows:
            self._game_state = GAME_OVER

    row = property(get_row, set_row)


    def set_pip_in_row(self, position, color):
        if self._game_state == GAME_OVER:
            raise GameError(ERROR_GAME_OVER)

        if self._game_state != GAME_STARTED:
            raise GameError(ERROR_GAME_NOT_STARTED)

        if type(position) is not int:
            raise GameError(ERROR_INVALID_TYPE % (pips_per_row, str(int)))

        if position < 0 or position >= self.pips_per_row:
            raise GameError(ERROR_INVALID_POSITION %
                            (position, self.pips_per_row-1))

        if color not in self.color_range:
            raise GameError(ERROR_INVALID_COLOR % color)

        self._current_row[position] = color

        if None not in self._current_row:
            self.row = list(self._current_row)

    def score_row(self):
        new_score = Score()

        new.score_guess(self.code, self.current_row)

    def get_code(self):
        return self._code

    def set_code(self, code):
        if self._game_state == GAME_OVER:
            raise GameError(ERROR_GAME_OVER)

        if self._game_state != GAME_INITIALIZED:
            raise GameError(ERROR_GAME_STARTED)

        if len(code) != self.pips_per_row:
            raise GameError(ERROR_WRONG_ELEMENT_COUNT % 
                            (len(code), self.pips_per_row))

        if None in code:
            raise GameError(ERROR_INCOMPLETE_CODE)

        for color in code:
            if color not in self.color_range:
                raise GameError(ERROR_INVALID_COLOR % color)

        self._game_state = GAME_STARTED
        self._code = code

    code = property(get_code, set_code)


    def get_last_score(self):
        return self.scores[-1]

    last_score = property(get_last_score)


    def get_last_row(self):
        return self.rows[-1]

    last_row = property(get_last_row)


    def get_pips_per_row(self):
        return self._pips_per_row

    def set_pips_per_row(self, pips_per_row):
        if self._game_state == GAME_OVER:
            raise GameError(ERROR_GAME_OVER)

        if self._game_state != GAME_INITIALIZED:
            raise GameError(ERROR_GAME_STARTED)
        if type(pips_per_row) is not int:
            raise GameError(ERROR_INVALID_TYPE % (pips_per_row, str(int)))

        self._pips_per_row = pips_per_row

    pips_per_row = property(get_pips_per_row, set_pips_per_row)


    def get_color_range(self):
        return self._color_range

    def set_color_range(self, range):
        if self._game_state == GAME_OVER:
            raise GameError(ERROR_GAME_OVER)

        if self._game_state != GAME_INITIALIZED:
            raise GameError(ERROR_GAME_STARTED)

        self._color_range = list(range)

    color_range = property(get_color_range, set_color_range)


    def get_selected_color(self):
        return self._selected_color

    def set_selected_color(self, color):
        if self._game_state == GAME_OVER:
            raise GameError(ERROR_GAME_OVER)

        self._selected_color = color

    selected_color = property(get_selected_color, set_selected_color)


    def get_total_rows(self):
        return self._total_rows

    def set_total_rows(self, total_rows):
        if self._game_state == GAME_OVER:
            raise GameError(ERROR_GAME_OVER)

        if self._game_state != GAME_INITIALIZED:
            raise GameError(ERROR_GAME_STARTED)

        self._total_rows = total_rows

    total_rows = property(get_total_rows, set_total_rows)

    def serialize(self):
        return json.dumps(self.__dict__)

    def deserialize(self, data):
        # XXX - may want to protect the game here from improper deserialization
        self.__dict__ = json.loads(data)

