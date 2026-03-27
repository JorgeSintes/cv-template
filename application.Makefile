PUBLISH_TARGET = your-host:/path/to/public/files

APP_SLUG := $(notdir $(CURDIR))
APP_HASH := $(shell printf '%s' "$(APP_SLUG)" | sha256sum | cut -c1-16)

OUT_DIR = pdf
CV_SRC = cv.md
LETTER_SRC = letter.md

CV_PDF = $(OUT_DIR)/cv.pdf
LETTER_PDF = $(OUT_DIR)/cover-letter.pdf

.PHONY: cv letter publish clean hash

cv:
	mkdir -p $(OUT_DIR)
	TEXINPUTS=../..: pandoc $(CV_SRC) -o $(CV_PDF) --pdf-engine=xelatex --template=../../template_cv.tex --resource-path=.:../..

letter:
	mkdir -p $(OUT_DIR)
	TEXINPUTS=../..: pandoc $(LETTER_SRC) -o $(LETTER_PDF) --pdf-engine=xelatex --template=../../template_letter.tex --resource-path=.:../..

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
