NASM=arm-linux-gnueabi-as
CC=arm-linux-gnueabi-gcc

%.o: %.s
	$(NASM) -g $< -o $@

%.o: %.c
	$(CC) -c -g $< -o $@

hw2: matmul.o hw2.o
	$(CC) $^ -g -o $@

clean:
	rm -f *.o
	rm -f *.out
	rm -f hw2
