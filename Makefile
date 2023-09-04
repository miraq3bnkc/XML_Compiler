all: compiler
compiler:
	bison -d bisonFile.y
	flex lexFile.l
	gcc -o run lex.yy.c bisonFile.tab.c -lfl
clean:
	rm run bisonFile.tab.c bisonFile.tab.h lex.yy.c
