COMPILER=gcc
TARGET=sol.c
ADDITIONAL=fileparse.c
TEST_IP=../test_input
TARG_IP=../input.txt
OUTPUT=sol
FLAGS=

all: build exec_targ

build: $(TARGET) $(ADDITIONAL)
	$(COMPILER) $(TARGET) $(ADDITIONAL) $(FLAGS) -o $(OUTPUT)

exec_test: $(OUTPUT) $(TEST_IP)
	./$(OUTPUT) $(TEST_IP) 

exec_targ: $(OUTPUT) $(TARG_IP)
	./$(OUTPUT) $(TARG_IP)

clean:
	rm -f $(OUTPUT)

.PHONY: all build exec_targ exec_test clean
