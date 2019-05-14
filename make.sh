#! /bin/bash

mkdir -p manuscript >/dev/null

CONTENTS="colophon.md introduction.md chapter1.md chapter2.md"

rm manuscript/Book.txt

for f in $CONTENTS
do
	./bin/preprocess.sh src/text/${f} > manuscript/${f}
	echo ${f} >>manuscript/Book.txt
done

cp -r src/images manuscript/