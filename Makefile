main = allgemeine

exercises-content = $(wildcard exercises/*.tex)
exercisesoutex = $(patsubst exercises%, exercises-out%, $(exercises-content))
exercisesout = $(patsubst %.tex,%.pdf,$(exercisesoutex))

homeworks-content = $(wildcard homeworks/*.tex)
homeworksoutex = $(patsubst homeworks%, homeworks-out%, $(homeworks-content))
homeworksout = $(patsubst %.tex,%.pdf,$(homeworksoutex))

# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: all clean exercises homeworks

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.
all: $(main).pdf exercises homeworks

$(main).tex: exercises.tex homeworks.tex

## EXERCICES

exercises-out/%.tex : exercises/%.tex
	./generate-tex-individuals.sh $< $@ Solutions\ to\ exercises\ sheet

exercises-out/%.pdf : exercises-out/%.tex
	latexmk -pdflua -pdflualatex="lualatex -interaction=nonstopmode" -outdir=exercises-out -use-make $<

exercises.tex: $(exercises-content)
	bash ./generate-tex-chapters.sh exercises Exercise sheet

## HOMEWORKS

homeworks-out/%.tex : homeworks/%.tex
	./generate-tex-individuals.sh $< $@ Solutions\ to\ homeworks\ sheet

homeworks-out/%.pdf : homeworks-out/%.tex
	latexmk -pdflua -pdflualatex="lualatex -interaction=nonstopmode" -outdir=homeworks-out -use-make $<

homeworks.tex: $(homeworks-content)
	bash ./generate-tex-chapters.sh homeworks Homework

$(main).pdf: $(main).tex exercises.tex homeworks.tex
	latexmk -pdflua -pdflualatex="lualatex -interaction=nonstopmode" -use-make $<

exercises: $(exercisesout)

homeworks: $(homeworksout)

#TODO : works even when folder does exist. Actually clean folders
clean:
	latexmk -CA
	latexmk -CA homeworks/
	latexmk -CA homeworks-out/
	latexmk -CA exercises/
	latexmk -CA exercises-out/
