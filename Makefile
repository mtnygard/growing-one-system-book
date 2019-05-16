# What to compile by default?
SOURCES := $(wildcard src/text/*.md)
TARGETS := $(addprefix public/,$(notdir $(patsubst %.md,%.html,$(SOURCES))))
LPTARGETS := $(addprefix manuscript/,$(notdir $(wildcard src/text/*.md)))

STYLES := src/styles/tufte.css \
	src/styles/pandoc.css \
	src/styles/pandoc-solarized.css \
	src/styles/tufte-extra.css

.PHONY: all
all: prepare $(TARGETS) prepare_leanpub $(LPTARGETS)

# Note: you will need pandoc 2 or greater for this to work

.PHONY: prepare
prepare: 
	@mkdir -p public/styles
	cp -r $(STYLES) public/styles
	cp -r src/et-book public/
	cp -r src/images public/

.PHONY: prepare_leanpub
prepare_leanpub:
	@mkdir -p manuscript
	cp -r src/images manuscript/
	cp src/text/Book.txt manuscript
	
## Generalized rule: how to build a .html file from each .md
public/%.html: src/text/%.md tufte.html5 $(STYLES)
	bin/preprocess.sh $< | pandoc \
		--katex \
		--section-divs \
		--from markdown+tex_math_single_backslash+grid_tables+table_captions \
		--filter pandoc-sidenote \
		--to html5+smart \
		--metadata-file=src/metadata.txt \
		--template=tufte \
		$(foreach style,$(STYLES),--css $(addprefix styles/,$(notdir $(style)))) \
		--output $@	

manuscript/%.md: src/text/%.md 
	bin/preprocess.sh $< > $@

.PHONY: clean
clean:
	-rm -r public manuscript

