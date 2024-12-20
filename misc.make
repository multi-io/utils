#########TeX, dvips
%.dvi: %.tex
	latex "$<" && latex "$<" || ( rm "$@" && false )  # TODO: wie outputfilenamen an latex uebergeben?

%.pdf: %.tex
	pdflatex "$<" && pdflatex "$<" || ( rm "$@" && false )  # TODO: wie outputfilenamen an pdflatex uebergeben?

%.ps: %.dvi
	dvips "$<" -o "$@"

%.eps: %.fig
	fig2dev -L eps "$<" "$@"

%.eps: %.dia
	dia -n -e "$@" -t eps "$<"

%.pdf: %.eps
	epstopdf --outfile="$@" "$<"

%.pdf: %.ps
	ps2pdf "$<"

#########PostScript
%.2.ps: %.ps
	psnup -2 "$<" >"$@"

%.4.ps: %.ps
	psnup -4 "$<" >"$@"


#########

%.ps: %.glabels
	glabels-batch -l -o "$@" "$<"   # DOESNT WORK: glabels ignores "-o" and outputs to output.ps

#########

%.eps: %.gplot
	(echo 'set terminal postscript eps'; cat "$<") | gnuplot >"$@"

%.eps: %.gnuplot
	(echo 'set terminal postscript eps'; cat "$<") | gnuplot >"$@"

#########Markdown
# using the :3.5-ubuntu image because it's multi-arch, i.e. incl. ARM/aarch64
# see https://github.com/pandoc/dockerfiles/issues/134#issuecomment-2427405279
# TODO check back regularly if the untagged image also supports ARM
%.html %.pdf: %.md
	docker run --rm \
		--volume "$$(pwd):/data" \
		--user $$(id -u):$$(id -g) \
		pandoc/latex:3.5-ubuntu "$<" -o "$@"

#########image conversion


%.pnm: %.xpm
	xpmtoppm <"$<" >"$@"

%.pnm_alpha: %.xpm
	xpmtoppm --alphaout=- <"$<" >"$@"

%.pnm: %.gif
	giftopnm <"$<" >"$@"

%.pnm_alpha: %.gif
	giftopnm --alphaout=- <"$<" >"$@"

%.png: %.pnm %.pnm_alpha
	pnmtopng -alpha $*.pnm_alpha <$*.pnm >"$@"

%.png: %.webp
	dwebp "$<" -o "$@"

%.png: %.avif
	avifdec --no-strict "$<" "$@"


# fallback when no .pnm_alpha is available
%.png: %.pnm
	pnmtopng <"$<" >"$@"

%.pnm: %.xwd
	xwdtopnm <"$<" >"$@"

%.ppm: %.xpm
	xpmtoppm <"$<" >"$@"

%.ppm: %.png
	pngtopnm <"$<" >"$@"

%.gif: %.ppm
	ppmtogif <"$<" >"$@"

%.ppm: %.bmp
	bmptoppm <"$<" >"$@"

%.bmp: %.ppm
	ppmtobmp <"$<" >"$@"

%.xpm: %.ppm
	ppmtoxpm <"$<" >"$@"

%.jpg %.png %.gif: %.xcf
	convert -flatten -background transparent "$<" "$@"

# video conversion
%.gif: %.mp4
	ffmpeg -i "$<" "$@"

#########CD writing

%.iso: %
	mkisofs -J "$<" -o "$@"


#########audio

%.wav: %.*
	ffmpeg -i "$<" "$@"

%.mp3: %.wav
	lame -h -b 192 "$<" "$@"

%.ogg: %.wav
	oggenc -b 160 "$<"


#########video
# TODO: anything to mp4 (intelligently, i.e. avoid transcoding unless needed)
%.mp4: %.wmv
	ffmpeg -i "$<" -c:v libx264 -crf 23 -c:a aac -q:a 100 "$@"

%.m4a: %.mp4
	ffmpeg -i "$<" -vn -c:a copy "$@"

#########catch-all last resorts
%.ps: %
	a2ps -o "$@" "$<"
