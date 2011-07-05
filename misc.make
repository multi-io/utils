#########TeX, dvips
%.dvi: %.tex
	latex $< && latex $< || ( rm $@ && false )  # TODO: wie outputfilenamen an latex uebergeben?

%.pdf: %.tex
	pdflatex $< && pdflatex $< || ( rm $@ && false )  # TODO: wie outputfilenamen an pdflatex uebergeben?

%.ps: %.dvi
	dvips $< -o $@

%.eps: %.fig
	fig2dev -L eps $< $@

%.eps: %.dia
	dia -n -e $@ -t eps $<

%.pdf: %.eps
	epstopdf --outfile=$@ $<

%.ps: %.pdf
	pdf2ps $< $@ 

%.pdf: %.ps
	ps2pdf $<

#########PostScript
%.2.ps: %.ps
	psnup -2 $< >$@

%.4.ps: %.ps
	psnup -4 $< >$@


#########

%.ps: %.glabels
	glabels-batch -l -o $@ $<   # DOESNT WORK: glabels ignores "-o" and outputs to output.ps

#########

%.eps: %.gplot
	(echo 'set terminal postscript eps'; cat $<) | gnuplot >$@

%.eps: %.gnuplot
	(echo 'set terminal postscript eps'; cat $<) | gnuplot >$@

#########image conversion


%.pnm: %.xpm
	xpmtoppm <$< >$@

%.pnm_alpha: %.xpm
	xpmtoppm --alphaout=- <$< >$@

%.pnm: %.gif
	giftopnm <$< >$@

%.pnm_alpha: %.gif
	giftopnm --alphaout=- <$< >$@

%.png: %.pnm %.pnm_alpha
	pnmtopng -alpha $*.pnm_alpha <$*.pnm >$@

# fallback when no .pnm_alpha is available
%.png: %.pnm
	pnmtopng <$< >$@

%.pnm: %.xwd
	xwdtopnm <$< >$@

%.ppm: %.xpm
	xpmtoppm <$< >$@

%.ppm: %.png
	pngtopnm <$< >$@

%.gif: %.ppm
	ppmtogif <$< >$@

%.ppm: %.bmp
	bmptoppm <$< >$@

%.bmp: %.ppm
	ppmtobmp <$< >$@

%.xpm: %.ppm
	ppmtoxpm <$< >$@

%.jpg %.png %.gif: %.xcf
	convert -flatten -background transparent $< $@

#########CD writing

%.iso: %
	mkisofs -J $< -o $@


#########audio

%.wav: %.mp3
	mpg123 -w $@ $<

%.mp3: %.wav
	lame -h -b 192 $< $@

%.ogg: %.wav
	oggenc -b 160 $<

#########some "catch-all" last resorts
%.ps: %
	a2ps -o $@ $<
