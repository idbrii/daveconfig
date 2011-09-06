%.out: %.cpp
	g++ $< -o $@
	./$@ 1>&2

clean:
	-rm *.out
