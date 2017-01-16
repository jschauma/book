# Principles of System Administration
# https://www.netmeister.org/book/
# https://www.netmeister.org/blog/half-a-book.html
#
# Jan Schaumann - @jschauma
TARGET	=	principles-of-system-administration

TEXDIR	=	./common:

#LATEX	=	env TEXINPUTS=${TEXDIR} latex
LATEX	=	env TEXINPUTS=${TEXDIR} pdflatex
BIBTEX	=	bibtex
DVIPS	=	dvips -o
PS2PDF	=	ps2pdf
PDFTOTEXT=	pdftotext

FIGURES=	common/pics/totally-socks-donkey.pdf			\
		common/pics/pointer.pdf					\
		common/pics/tangent-deck.pdf				\
		01/pics/we-are-happy-to-serve-you-coffee-mug.pdf	\
		01/pics/Ibm704.pdf 					\
		02/pics/unix-plate.pdf					\
		02/pics/unix_history.pdf				\
		02/pics/pipeline.pdf					\
		02/pics/VAX_11-780_intero.pdf				\
		02/pics/Mac-mini-1st-gen.pdf				\
		02/pics/Dellpoweredge2950.pdf				\
		03/pics/pen.pdf						\
		04/pics/box.pdf						\
		04/pics/das.pdf						\
		04/pics/nas.pdf						\
		04/pics/san-nas-das.pdf					\
		04/pics/cloud-storage.pdf				\
		04/pics/open-hard-drive.pdf				\
		04/pics/ssd-minipcie.pdf				\
		04/pics/xraid.pdf					\
		04/pics/netapp.pdf					\
		04/pics/chs.pdf						\
		04/pics/disk-structure-zone-bit-recording.pdf		\
		04/pics/lvm.pdf						\
		04/pics/raid-0.pdf					\
		04/pics/raid-1.pdf					\
		04/pics/raid-5.pdf					\
		04/pics/filesystem-tree-mountpoints.pdf			\
		04/pics/ufs-details.pdf					\
		04/pics/ls-l.pdf					\
		05/pics/many-boxes.pdf					\
		05/pics/opensolaris-install.pdf				\
		05/pics/types-of-software.pdf				\
		05/pics/wireshark-dependencies.pdf 			\
		06/pics/user-mapping.pdf 				\
		06/pics/user-groups.pdf 				\
		06/pics/groups-machines.pdf				\
		07/pics/host-states.pdf					\
		07/pics/change-sets.pdf 				\
		07/pics/host-sets.pdf


.SUFFIXES: .tex .dvi .ps .pdf .txt .fig .eps .png .jpg .gif .inx .srt .dot

all:	pdf

figures: $(FIGURES)

$(TARGET).dvi: */*.tex ${FIGURE}
	rm -f $(TARGET).idx $(TARGET).adx $(TARGET).and $(TARGET).gl*
	$(LATEX) $(TARGET).tex
	makeindex $(TARGET).idx
	makeindex $(TARGET).adx -o $(TARGET).and
	makeglossaries $(TARGET)
	$(LATEX) $(TARGET).tex


.dot.eps:
	# for some reason whitespace is compressed when translating
	# directly to EPS, so do the extra step of converting to png
	# first:
	dot -Tpng <$< > /tmp/t && \
		convert /tmp/t $@

.fig.eps:
	fig2dev -L eps $< > $@

.png.eps:
	convert $< $@

.png.pdf:
	convert $< $@

.jpg.pdf:
	convert $< $@

.gif.pdf:
	convert $< $@

pdf:  $(TARGET).pdf

$(TARGET).pdf: $(FIGURES) */*.tex 
	rm -f $(TARGET).idx $(TARGET).adx $(TARGET).and $(TARGET).gl*
	$(LATEX) $(TARGET).tex
	makeindex $(TARGET).idx
	makeindex $(TARGET).adx -o $(TARGET).and
	makeglossaries $(TARGET)
	$(LATEX) $(TARGET).tex

txt: $(TARGET).dvi $(TARGET).ps $(TARGET).pdf $(TARGET).txt

html:
	latex2html $(LATEX2HTMLOPTS) $(TARGET).tex

.ps.pdf:
	$(PS2PDF) $< $@ 2>/dev/null

.pdf.txt:
	$(PDFTOTEXT) $< $@

clean:
	rm -f *.lol *.alg *.ac* *.gl* *.ist *.out *.aut *.adx *.and *.att *.srt *.idx *.ilg *.ind *.lot **.bbl *.blg *.log *.aux *.dvi *.ps *.pdf *.toc *.bak *.lof ${FIGURES}
	rm -fr */*.aux */*.log
	rm -fr $(TARGET)/
	rm -f */pics/*eps-converted-to.pdf
