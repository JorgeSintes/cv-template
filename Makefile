PUBLISH_TARGET = your-host:/path/to/public/files/

OUT_DIR = pdf
CV_SRC = cv.md
LETTER_SRC = letter.md
DOCKER_IMAGE ?= cv-build

CV_PDF = $(OUT_DIR)/cv.pdf
LETTER_PDF = $(OUT_DIR)/cover-letter.pdf

.PHONY: cv letter publish clean new docker-cv docker-letter

cv:
	mkdir -p $(OUT_DIR)
	pandoc $(CV_SRC) -o $(CV_PDF) --pdf-engine=xelatex --template=template_cv.tex

letter:
	mkdir -p $(OUT_DIR)
	pandoc $(LETTER_SRC) -o $(LETTER_PDF) --pdf-engine=xelatex --template=template_letter.tex

both: cv letter

docker-cv:
	docker run --rm --user "$$(id -u):$$(id -g)" -e HOME=/tmp -v "$$(pwd):/work" -w /work cv-build make cv

docker-letter:
	docker run --rm --user "$$(id -u):$$(id -g)" -e HOME=/tmp -v "$$(pwd):/work" -w /work cv-build make letter

docker-both: docker-cv docker-letter

new:
	@if [ -z "$(APP)" ]; then printf "Usage: make new APP=<application-slug>\n"; exit 1; fi
	@if [ -e "applications/$(APP)" ]; then printf "applications/$(APP) already exists\n"; exit 1; fi
	mkdir -p applications/$(APP)/pdf
	cp cv.md applications/$(APP)/cv.md
	cp letter.md applications/$(APP)/letter.md
	cp application.Makefile applications/$(APP)/Makefile

publish: cv
	ssh your-host "mkdir -p /path/to/public/files"
	scp $(CV_PDF) $(PUBLISH_TARGET)

publish_letter: letter
	ssh your-host "mkdir -p /path/to/public/files"
	scp $(LETTER_PDF) $(PUBLISH_TARGET)

clean:
	rm -f $(CV_PDF) $(LETTER_PDF)
