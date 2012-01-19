import random
import itertools
import re

class Game:
    def __init__(self, code):
        self._code = code

    def check_score(self, guess, code=None):
        if not code:
            code = self._code

        codeCopy = list(code)
        guessCopy = list(guess)

        codePos = 0
        codeVal = 0

        for count, peg in enumerate(code):
            if guessCopy[count] == codeCopy[count]:
                codeCopy[count] = None
                guessCopy[count] = None
                codePos += 1

        for peg in codeCopy:
            if peg and peg in guessCopy:
                codeVal += 1
                pos = guessCopy.index(peg)
                guessCopy[pos] = None

        return (codePos, codeVal)

class AI:
    def __init__(self, game):
        self.game = game
        self.reset()

    def reset(self):
        # create a list of all possible choices
        # ie. (0, 0, 0, 0), (0, 0, 0, 1) ... (9, 9, 9, 9)
        self.choices = []
        x = itertools.product(range(10), repeat=4)
        try:
            while True:
                self.choices.append(x.next())
        except StopIteration:
            pass

    def guess_code(self, displayChoices=True):
        if displayChoices:
            print "There are %d possibilities" % len(self.choices)

        guess = random.choice(self.choices)
        score = self.game.check_score(guess)

        print "My guess: %s" % str(guess)
        print "I scored: %s" % str(score)

        if score == (4, 0):
            return True

        # reduce our choices by only saving things which match the
        # the same score as our guess

        self.choices = [i for i in self.choices \
                            if self.game.check_score(guess, i) == score]

        return False


if __name__ == '__main__':
    print "Choose a code (4 ints): ",
    val = raw_input()

    matchObj = re.match('(\d).*(\d).*(\d).*(\d)', val)

    assert len(matchObj.groups()) == 4

    code = matchObj.groups()

    game = Game((int(code[0]), int(code[1]), int(code[2]), int(code[3])))
    ai = AI(game)

    guess_num = 1

    while True:
        print "\nGuess number %d" % (guess_num)
        if ai.guess_code():
            break
        guess_num += 1


