CC = gcc
CFLAGS = -O2 -Wall 
TARGET = sol

all: $(TARGET)

$(TARGET): sol.c
	$(CC) $(CFLAGS) sol.c -o $(TARGET)

test: $(TARGET)
	./$(TARGET) ../input_test

full: $(TARGET)
	./$(TARGET) ../input

clean:
	rm -f $(TARGET)

.PHONY: all test full clean
