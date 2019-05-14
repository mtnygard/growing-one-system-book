#! /bin/bash
bin/show-rev-file-lines.sh doc/adr/$1 HEAD 1 '$' | bin/indent-markdown.sh | bin/quote.sh
