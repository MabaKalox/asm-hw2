NASM=arm-linux-gnueabi-as
CC=arm-linux-gnueabi-gcc

%.o: %.s
	$(NASM) $< -o $@

%.o: %.c
	$(CC) -c $< -o $@

hw2: matmul.o hw2.o
	$(CC) $^ -o $@

clean:
	rm -f *.o
	rm -f *.out
	rm -f hw2
