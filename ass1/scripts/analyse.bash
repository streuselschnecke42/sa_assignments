#!/usr/bin/env bash

# NOT ENOUGH OR TOO MANY ARGUMENTS
if [ "$#" -ne 1 ]; then
    echo "Invalid amount of arguments. Only 1 argument needed (URL)"
    exit 1
fi

wget -qO fil "$1" || { echo "Something went wrong"; exit 1; }

touch fileanalysis.txt

F="fil"

TYPE=$(file "$F" | cut -d: -f2-)
# 17 https://itsfoss.gitlab.io/post/how-to-determine-mime-type-of-a-file-in-linux/
MIMETYPE=$(file --mime-type -b "$F")
SIZE=$(stat -c%s "$F" 2>/dev/null)

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
    # 18 https://www.geeksforgeeks.org/linux-unix/wc-command-linux-examples/
    LINES=$(wc -l < "$F")
    WORDS=$(wc -w < "$F")
    # 19 https://stackoverflow.com/questions/18043260/how-to-count-all-spaces-in-a-file-in-unix
    SPACES=$(grep -o ' ' "$F" | wc -l)
    # 20 https://www.cyberciti.biz/faq/unix-linux-display-first-line-of-file/
    FIRSTLINE=$(head -1 "$F")
    # 21 https://linuxvox.com/blog/linux-get-last-n-lines-of-file/
    LASTLINE=$(tail -1 "$F")

    {
        echo "Lines: $LINES"
        echo "Words: $WORDS"
        echo "Spaces: $SPACES"
        echo "First Line: $FIRSTLINE"
        echo "Last Line: $LASTLINE"
    } >> fileanalysis.txt

else
    # 18 https://www.geeksforgeeks.org/linux-unix/wc-command-linux-examples/
    LINES=$(wc -c < "$F")
    # 22 https://stackoverflow.com/questions/4411014/how-to-get-only-the-first-ten-bytes-of-a-binary-file
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
