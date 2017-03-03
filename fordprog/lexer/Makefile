lexer: lexmain.cpp lex.yy.cc
	g++ -olexer lexmain.cpp lex.yy.cc

lex.yy.cc: lexer.l
	flex lexer.l

clean:
	rm -f lex.yy.cc lexer
	rm -f *.o
