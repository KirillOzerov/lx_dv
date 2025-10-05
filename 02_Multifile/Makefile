GENERATES = prog prog-a prog-so README liboutput-static.a liboutput.so
TRASH = *.o *~ o.* *.out
CFLAGS = -Wall
CFLAGS_SHARED = $(CFLAGS) -fPIC

all:	README prog prog-a prog-so

prog:	const.o fun.o prog.o

prog-a:	prog.o liboutput-static.a
	$(CC) $^ -o $@

prog-so: prog.o liboutput.so
	$(CC) $< -o $@ -L. -loutput

liboutput-static.a: fun.o const.o
	ar rcs $@ $^

liboutput.so: fun_shared.o const_shared.o
	$(CC) -shared -o $@ $^

fun.o:	outlib.h

fun_shared.o: fun.c outlib.h
	$(CC) $(CFLAGS_SHARED) -c $< -o $@

const_shared.o: const.c
	$(CC) $(CFLAGS_SHARED) -c $< -o $@

README:	prog prog-a prog-so
	./prog 2> $@
	./prog-a 2>> $@
	LD_LIBRARY_PATH=`pwd` ./prog-so 2>> $@

test: prog prog-a prog-so
	./prog > prog.out 2>&1
	./prog-a > prog-a.out 2>&1
	LD_LIBRARY_PATH=`pwd` ./prog-so > prog-so.out 2>&1
	cmp prog.out prog-a.out
	cmp prog.out prog-so.out
	./prog param1 > prog-1.out 2>&1
	./prog-a param1 > prog-a-1.out 2>&1
	LD_LIBRARY_PATH=`pwd` ./prog-so param1 > prog-so-1.out 2>&1
	cmp prog-1.out prog-a-1.out
	cmp prog-1.out prog-so-1.out
	./prog param1 param2 param3 > prog-3.out 2>&1
	./prog-a param1 param2 param3 > prog-a-3.out 2>&1
	LD_LIBRARY_PATH=`pwd` ./prog-so param1 param2 param3 > prog-so-3.out 2>&1
	cmp prog-3.out prog-a-3.out
	cmp prog-3.out prog-so-3.out

clean:
	rm -f $(TRASH)

distclean:	clean
	rm -rf $(GENERATES)
