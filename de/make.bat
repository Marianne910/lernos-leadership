@echo off
echo Starting lernOS Guide Generation ...

REM Variables
set filename="lernOS-Leitfaden-schreiben-Guide-de"
set chapters=./src/index.md ./src/1-0-Grundlagen.md ./src/1-1-Grundidee.md ./src/1-2-Lebenszyklus.md ./src/1-3-Inhaltsverzeichnis.md ./src/1-4-Inhalt.md ./src/1-5-Produktionskette.md ./src/2-Lernpfad.md ./src/3-Anhang.md

REM Delete Old Versions
echo Deleting old versions ...
del %filename%.docx %filename%.epub %filename%.mobi %filename%.html %filename%.pdf

REM Create Microsoft Word Version (docx)
echo Creating Word version ...
pandoc metadata.yaml -s --resource-path="./src" %chapters% -o %filename%.docx

REM Create HTML Version (html)
echo Creating HTML version ...
pandoc metadata.yaml -s --resource-path="./src" %chapters% -o %filename%.html

REM Create Web Version (mkdocs)
echo Creating Web Version ...
mkdocs build

REM Create PDF Version (pdf)
echo Creating PDF version ...
pandoc metadata.yaml --from markdown --resource-path="./src" --template lernOS --number-sections -V lang=de-de %chapters% -o %filename%.pdf

REM Create eBook Versions (epub, mobi)
echo Creating eBook versions ...
magick -density 300 %filename%.pdf[0] src/images/ebook-cover.jpg
magick mogrify -size 2500x2500 -resize 2500x2500 src/images/ebook-cover.jpg
magick mogrify -crop 1563x2500+102+0 src/images/ebook-cover.jpg
pandoc metadata.yaml -s --resource-path="./src" --epub-cover-image=src/images/ebook-cover.jpg %chapters% -o %filename%.epub
ebook-convert %filename%.epub %filename%.mobi

echo Done. Check for error messages or warnings above.

pause
