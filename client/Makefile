
#
# Run "make <class name>.swf to compile
#

BIN_DIR = /Developer/SDKs/flex_sdk_4.6/bin
#BIN_DIR = /home/pdevine/flex/bin
FLAGS = -static-link-runtime-shared-libraries=true -debug=true -use-network=true -compiler.include-libraries=./starling.swc

%.swf: %.as
	$(BIN_DIR)/mxmlc $(FLAGS) $<

MasterMind.swf: MasterMind.as Pip.as GameData.as Game.as Score.as MovingPip.as Vector2D.as LocalPlayer.as
	$(BIN_DIR)/mxmlc $(FLAGS) $<

clean:
	rm -f *.swf
