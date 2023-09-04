#how to run												optional					optional
#if you want to compile run : make <all>    or make <compiler>
#if you only run : make
#it will be ok.
#after compiling if you want to remove the files that flex and bison make run : make clean
#with that you will remove the tokens that bison made, and c files that got generated



all: compiler
compiler:
	bison -d bisonFile.y
	flex lexFile.l
	gcc -o run lex.yy.c bisonFile.tab.c -lfl
clean:
	rm run bisonFile.tab.c bisonFile.tab.h lex.yy.c
