
#
# Run "make <class name>.swf to compile
#

BIN_DIR = /Developer/SDKs/flex_sdk_4.1/bin
FLAGS = -static-link-runtime-shared-libraries=true -debug=true -use-network=false

%.swf: %.as
	$(BIN_DIR)/mxmlc $(FLAGS) $<

MasterMind.swf: MasterMind.as Pip.as Score.as Reset.as Toggle.as Human.as AI.as RowBox.as
	$(BIN_DIR)/mxmlc $(FLAGS) $<

clean:
	rm -f *.swf
