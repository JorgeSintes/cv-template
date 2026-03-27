PUBLISH_TARGET = your-host:/path/to/public/files

APP_SLUG := $(notdir $(CURDIR))
APP_HASH := $(shell printf '%s' "$(APP_SLUG)" | sha256sum | cut -c1-16)

OUT_DIR = pdf
CV_SRC = cv.md
LETTER_SRC = letter.md
DOCKER_IMAGE ?= cv-build

CV_PDF = $(OUT_DIR)/cv.pdf
LETTER_PDF = $(OUT_DIR)/cover-letter.pdf

.PHONY: cv letter both publish clean hash docker-cv docker-letter docker-both

cv:
	mkdir -p $(OUT_DIR)
	TEXINPUTS=../..: pandoc $(CV_SRC) -o $(CV_PDF) --pdf-engine=xelatex --template=../../template_cv.tex --resource-path=.:../..

letter:
	mkdir -p $(OUT_DIR)
	TEXINPUTS=../..: pandoc $(LETTER_SRC) -o $(LETTER_PDF) --pdf-engine=xelatex --template=../../template_letter.tex --resource-path=.:../..

docker-cv:
	docker run --rm --user "$$(id -u):$$(id -g)" -e HOME=/tmp -v "$$(pwd)/../..:/work" -w /work/applications/$(APP_SLUG) $(DOCKER_IMAGE) make cv

docker-letter:
	docker run --rm --user "$$(id -u):$$(id -g)" -e HOME=/tmp -v "$$(pwd)/../..:/work" -w /work/applications/$(APP_SLUG) $(DOCKER_IMAGE) make letter

both: cv letter

docker-both: docker-cv docker-letter

hash:
	@printf "$(APP_HASH)\n"

publish: cv
	ssh your-host "mkdir -p /path/to/public/files/$(APP_HASH)"
	scp $(CV_PDF) $(PUBLISH_TARGET)/$(APP_HASH)/

publish_letter: letter
	ssh your-host "mkdir -p /path/to/public/files/$(APP_HASH)"
	scp $(LETTER_PDF) $(PUBLISH_TARGET)/$(APP_HASH)/

clean:
	rm -f $(CV_PDF) $(LETTER_PDF)
