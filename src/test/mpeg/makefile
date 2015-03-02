CC = gcc

#include for openCV
INC_OPEN_CV = -I/usr/include/opencv
#include for locale stuff
#INC_LOCAL = -Ihdr
INC_LOCAL = -Iinclude
#library for openCV
LIB_OPEN_CV = -lcxcore -lcv -lhighgui -lcvaux -lml

INCLUDE = -L/usr/include $(INC_OPEN_CV) $(INC_LOCAL)
LDFLAGS = -L/usr/lib64 $(LIB_OPEN_CV)

#add input files here
SRC = src/main.c \
	  src/DCT.c \
	  src/IDCT.c \
	  src/Trc.c \
	  src/DownSampling.c \
	  src/Quantification.c \
	  src/UpSampling.c \
	  src/Coding.c \
	  src/IQuantification.c \
	  src/Decoding.c \
	  src/LoadJPEG.c \
	  src/Block.c \
	  src/ZigZag.c \
	  src/Huffmann_encoder.c \
	  src/Huffmann_decoder.c \
	  src/SaveJPEG.c \
	  src/List.c 
		
#replace obj/*.o with src/*.c to get sources
OBJ = $(subst .c,.o, $(subst src/,obj/,$(SRC)))
#replace src/*.o with dep/*.d to get dependencies
DEP = $(subst src/,dep/,$(subst .c,.d,$(SRC)))

BIN = bin/JPEG 

all : $(OBJ)
	$(CC) -g -o $(BIN) $(OBJ) -lm
#	$(CC) -g -o $(BIN) $(OBJ) $(LDFLAGS)

clean :
	rm -rf $(BIN) $(OBJ) $(DEP)
	
#obj/%.o : src/%.c dep/%.d
obj/%.o : src/%.c
	$(CC) -Iinclude -c $< -o $@
#	$(CC) -g $(INCLUDE) -c $< -o $@
	
#automatically created dependencies:
#include $(DEP)

#dep/%.d : src/%.c
#	$(CC) -M $(INCLUDE) $< > $@.$$$$; \
#	sed 's,\($*\)\.o[ :]*,\1.0 $@ : ,g' < $@.$$$$ > $@; \
#	rm -rf $@.$$$$
