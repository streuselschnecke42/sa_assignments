#!/usr/bin/env bash

# NOT ENOUGH OR TOO MANY ARGUMENTS
if [ "$#" -ne 1 ]; then
    echo "Invalid amount of arguments. Only 1 argument needed (URL)"
    exit 1
fi

# https://www.linuxbash.sh/post/using-wget-and-curl-to-download-files-from-the-internet
# curl -s -o fil "$1" 

#https://www.gnu.org/software/wget/manual/wget.html
wget -qO fil "$1" || { echo "Something went wrong"; exit 1; }

touch fileanalysis.txt

#read fil
F="fil"

TYPE=$(file "$F" | cut -d: -f2-)
# https://itsfoss.gitlab.io/post/how-to-determine-mime-type-of-a-file-in-linux/
MIMETYPE=$(file --mime-type -b "$F")
SIZE=$(stat -c%s "$F")

{
    echo "   ------ FILEANALYSIS ------"
    echo "Entrydate: $(date +%Y-%m-%d)";
    echo "URL: $1"
    echo ""
    echo "Type: $TYPE"
    echo "Mime Type: $MIMETYPE"
    echo "Size: $SIZE Bytes"
} >> fileanalysis.txt

TP=$(file --mime-type -b "$F" | cut -d/ -f2)
mv "$F" "$F.$TP"
F="$F.$TP"

if [[ $MIMETYPE == text/* ]]; then
    # https://www.baeldung.com/linux/bash-count-lines-in-file
    # https://www.geeksforgeeks.org/linux-unix/wc-command-linux-examples/
    LINES=$(wc -l < "$F")
    WORDS=$(wc -w < "$F")
    # https://stackoverflow.com/questions/18043260/how-to-count-all-spaces-in-a-file-in-unix
    SPACES=$(grep -o ' ' "$F" | wc -l)
    # https://www.cyberciti.biz/faq/unix-linux-display-first-line-of-file/
    FIRSTLINE=$(head -1 "$F")
    # https://linuxvox.com/blog/linux-get-last-n-lines-of-file/
    LASTLINE=$(tail -1 "$F")

    {
        echo "Lines: $LINES"
        echo "Words: $WORDS"
        echo "Spaces: $SPACES"
        echo "First Line: $FIRSTLINE"
        echo "Last Line: $LASTLINE"
    } >> fileanalysis.txt

else
    # https://www.geeksforgeeks.org/linux-unix/wc-command-linux-examples/
    LINES=$(wc -c < "$F")
    # https://stackoverflow.com/questions/4411014/how-to-get-only-the-first-ten-bytes-of-a-binary-file
    FIRSTTEN=$(head -c 10 "$F" | xxd -p) # TODO: MENTION THIS CHANGE!!
    LASTTEN=$(tail -c 10 "$F" | xxd -p) # THAT YOU NOW CONVERT THEM TO HEX

    {
        echo "Lines: $LINES"
        echo "First 10: $FIRSTTEN"
        echo "Last 10: $LASTTEN"
        echo ""
        echo ""
    } >> fileanalysis.txt
fi

echo "Results were stored in fileanalysis.txt"
cat fileanalysis.txt

echo ""
echo "Opening local file in firefox..."

firefox "$F" || { echo "Failed to open.. Do you have firefox?"; exit 1; }
