## Quick workaround to deal with the pdf figures
#
# Makefile
#

.SUFFIXES: .tex .dvi .ps .fig .eps .gnu .c
PDF = ps2pdf14 -dPDFSETTINGS=/prepress -dEmbedAllFonts=true \
      -dSubsetFonts=true -dMaxSubsetPct=100

TARGET=report
DOBIB=yes
#DOBIB=no
DOPLOT=no

SPELL := aspell -a
UNAME := $(shell uname)
VIEWER := evince
ifeq ($(UNAME), Darwin)
	#VIEWER := open -a Skim
	VIEWER := open
endif

all: pdf

display: pdf
	$(VIEWER) $(TARGET).pdf

#pdflatex: $(TARGET).tex
#ifeq ($(DOPLOT),yes)
#	cd plots; make
#endif
#	pdflatex $(TARGET)
#	bibtex $(TARGET)
#	pdflatex $(TARGET)
#	pdflatex $(TARGET)
#	pdflatex $(TARGET)
#	cp report.pdf CLA-interim-report.pdf

pdf: $(TARGET)
	dvips -Ppdf -Pcmz -Pamz -t letter -D600 -G0 -o $(TARGET).ps $(TARGET).dvi
	$(PDF) $(TARGET).ps
	cp report.pdf CLA-interim-report.pdf

$(TARGET): $(TARGET).tex
ifeq ($(DOPLOT),yes)
	cd plots; make
endif
	latex $(TARGET)
	latex $(TARGET)
	latex $(TARGET)
ifeq ($(DOBIB),yes)
	bibtex $(TARGET)
	latex $(TARGET)
	latex $(TARGET)
	latex $(TARGET)
endif

clean:
	$(RM) $(TARGET).ps $(TARGET).pdf $(TARGET).log $(TARGET).aux \
	      $(TARGET).dvi $(TARGET).tex.flc CLA-interim-report.pdf
	$(RM) $(TARGET).bbl $(TARGET).blg
	$(RM) *.kill kill*
ifeq ($(DOPLOT),yes)
	cd plots; make clean
endif

purge:  clean
	$(RM) *~

nums:
	gnuplot plotGraph

#spell:
#	cat $(TF) | awk '{ if (index($$0,"%")!=1) print $$0}' |  $(SPELL)
#	#       detex $(TF) |  spell
