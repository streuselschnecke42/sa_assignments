#!/usr/bin/env bash

# NOT ENOUGH OR TOO MANY ARGUMENTS
if [ "$#" -ne 1 ]; then
    echo "Invalid amount of arguments. Only 1 argument needed (URL)"
    exit 1
fi

# DOWNLOAD LINK OR ERROR
wget -qO fil "$1" || { echo "Something went wrong"; exit 1; }
F="fil"

# CREATE FILE TO STORE ANALYSIS RESULTS (IF DOESNT EXIST YET)
touch fileanalysis.txt

# GENERAL ANALYSIS PART
TYPE=$(file "$F" | cut -d: -f2-)
MIMETYPE=$(file --mime-type -b "$F")
SIZE=$(stat -c%s "$F" 2>/dev/null)

# STORE RESULTS; CREATE HEAD OF ANALYSIS FILE
{
    echo "   ------ FILEANALYSIS ------"
    echo "Entrydate: $(date +%Y-%m-%d)";
    echo "URL: $1"
    echo ""
    echo "Type: $TYPE"
    echo "Mime Type: $MIMETYPE"
    echo "Size: $SIZE Bytes"
} >> fileanalysis.txt

# RENAME DOWNLOADED FILE TO MATCH APPROPRIATE MIMETYPE
TP=$(file --mime-type -b "$F" | cut -d/ -f2)
mv "$F" "$F.$TP"
F="$F.$TP"

# MIMETYPE SPECIFIC ANALYSIS PART

# ANALYSIS FOR TEXT FILES
if [[ $MIMETYPE == text/* ]]; then
    LINES=$(wc -l < "$F")
    WORDS=$(wc -w < "$F")
    SPACES=$(grep -o ' ' "$F" | wc -l)
    FIRSTLINE=$(head -1 "$F")
    LASTLINE=$(tail -1 "$F")

    # STORE RESULTS IN ANALYSIS FILE
    {
        echo "Lines: $LINES"
        echo "Words: $WORDS"
        echo "Spaces: $SPACES"
        echo "First Line: $FIRSTLINE"
        echo "Last Line: $LASTLINE"
    } >> fileanalysis.txt

# ANALYSIS FOR BINARY FILES
else
    LINES=$(wc -c < "$F")
    FIRSTTEN=$(head -c 10 "$F" | xxd -p)
    LASTTEN=$(tail -c 10 "$F" | xxd -p)

    # STORE RESULTS IN ANALYSIS FILE
    {
        echo "Lines: $LINES"
        echo "First 10: $FIRSTTEN"
        echo "Last 10: $LASTTEN"
        echo ""
        echo ""
    } >> fileanalysis.txt
fi

# CONFIRMATION IN TERMINAL -> ANALYSIS FINISHED
echo "Results were stored in fileanalysis.txt"
# DISPLAY RESULTS
cat fileanalysis.txt

echo ""
echo "Opening local file in firefox..."

# OPEN DOWNLOADED FILE IN BROWSER FIREFOX OR ERROR
firefox "$F" || { echo "Failed to open.. Do you have firefox?"; exit 1; }
