#! /bin/bash
for f in src/text/*.md
do
    awk -v fname=`basename $f` -f <(sed -e '/[B]EGIN_AWK1/,/[E]ND_AWK1/!d' $0) $f
done

exit

#BEGIN_AWK1
BEGIN       {
                if (fname == "index.md") {
                    exit;
                }
                if (fname == "colophon.md") {
                    exit;
                }
                FS = ": *";
                gsub(".md", ".html", fname);
            }
/^---/      { p=1 };
/^title:/   { 
                if (p == 1) {
                    $1 = "";
                    print "   - [" $2 "]" "(" fname ")";
                } 
            };
/^\.\.\./   {
                p=0;
            }
#END_AWK1