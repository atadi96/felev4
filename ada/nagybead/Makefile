full: sort table mainfull.adb
	gnatmake mainfull && ./mainfull

sorttest: sort.ads sort.adb sort_test.adb
	gnatmake sort_test.adb && ./sort_test

sort: sort.ads sort.adb mainsort.adb
	gnatmake mainsort -gnat2012 && ./mainsort

table: tables.ads tables.adb maintable.adb
	gnatmake maintable && ./maintable

clean:
	gnatclean -c ./*
