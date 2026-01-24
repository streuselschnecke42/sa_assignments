#!/usr/bin/env bash

# NOT ENOUGH OR TOO MANY ARGUMENTS
if [ "$#" -ne 1 ]; then
    echo "Invalid amount of arguments. Only 1 argument needed (DIR)"
    exit 1
fi

# PATH DOESNT EXIST OR ARGUMENT IS NOT A DIRECTORY
if [ ! -d "$1" ]; then
    echo "Directory not found."
    exit 1
fi

# GET ALL FILES; SUPPRESS CONSOLE ERRORS
# SEARCH $1 FOR ALL OBJECTS OF TYPE FILE
ALL_FILEPATHS=$(find "$1" -type f 2>/dev/null)

COUNTER=0
TOTALSIZE=0
SORTED_FILES=()
ALL_FILES=()
touch largest_files.txt

for FILE_PATH in $ALL_FILEPATHS
do
    FILENAME=$(basename "$FILE_PATH")
    SIZE=$(stat -c%s "$FILE_PATH")
    TYPEDATA=$(file "$FILE_PATH")
    IFS=':' read -ra TDATA <<< "${TYPEDATA}"
    TYPE="${TDATA[1]}"

    ALL_FILES+=("$FILENAME:$SIZE:$TYPE")

    (( COUNTER+=1 ))
    (( TOTALSIZE+=SIZE ))
done

mapfile -t SORTED_FILES < <( 
    printf "%s\n" "${ALL_FILES[@]}" | 
    sort -t: -k2,2nr
)

for I in 0 1 2 3 4
do
    # https://linuxsimply.com/bash-scripting-tutorial/string/split-string/
    # ALSO SEE: AHAHAHAHAA.png
    IFS=':' read -ra DATA <<< "${SORTED_FILES[I]}"
    {
        echo "Filename: ${DATA[0]}";
        echo "Filesize: ${DATA[1]} KB";
        echo "Typedata:${DATA[2]}";
        echo ""
    } >> largest_files.txt
done

{
    echo "Total amount of files: $COUNTER";
    echo "Total size: $TOTALSIZE KB"
} >> largest_files.txt

echo "Data of $1 stored in largest_files.txt"
