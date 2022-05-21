TARGETS=$(shell sed '/^module [a-z0-9_-]*().*make..\?me.*$$/!d;s/module //;s/().*/.stl/' main.scad)

GENERATED_FILES = 	$(wildcard *.deps) \
					$(wildcard *.stl) \
					$(wildcard *.generated.scad)

.phony: all clean

all: ${TARGETS}

.SECONDARY: $(shell echo "${TARGETS}" | sed 's/\.stl/.generated.scad/g')

include $(wildcard *.deps)

%.generated.scad:
	echo 'use <main.scad>\n$*();' > $@

%.stl: %.generated.scad
	openscad -DFN=64 -m make -o $@ -d $@.deps $<

image:
	openscad -DFN=32 --render --imgsize 1600,1200 --colorscheme Nature -o main.png main.scad

clean:
	rm -rf ${GENERATED_FILES}
