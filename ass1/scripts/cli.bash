#!/usr/bin/env bash
#
# A template for creating command line scripts taking options, commands
# and arguments.
#
# Exit values:
#  0 on success
#  1 on failure
#



# Name of the script
SCRIPT=$( basename "$0" )

# Current version
VERSION="1.0.0"



# LOCAL QUOTES
declare -a QUOTES=(
    # MONDAY
    [1]="Ironie gegen Dumme einzusetzen, ist wie einen Panzer mit nem Stein zu bewerfen. Kann man machen, bringt aber nichts."
    # TUESDAY
    [2]="Ich habe so viel Schlechtes über Alkohol gelesen, dass ich mit dem Lesen aufgehört habe."
    # WEDNESDAY
    [3]="Es ist Mittwoch, meine Kerle."
    # THURSDAY
    [4]="Ich war beim IQ-Test. Zum Glück war er negativ."
    # FRIDAY
    [5]="Eine Palette dieser kleinen Biere hat 24 Flaschen. Und ein Tag 24 Stunden. Zufall"
    # SATURDAY
    [6]="Jeder Mensch hat seinen Glauben - ich glaube, ich trink noch einen."
    # SUNDAY
    [0]="Serviervorschlag für Tiefkühlkost: Auftauen."
)



#
# Message to display for usage and help.
#
function usage
{
    local txt=(
"Utility $SCRIPT for doing stuff."
"Usage: $SCRIPT [options] <command> [arguments]"
""
"Command:"
"  command1             Demo of command."
"  command2 [anything]  Demo of command using arguments."
"  calendar [events]    Print out current calendar with(out) events."
""
"Options:"
"  --help, -h     Print help."
"  --version, -h  Print version."
    )

    printf "%s\\n" "${txt[@]}"
}



#
# Message to display when bad usage.
#
function badUsage
{
    local message="$1"
    local txt=(
"For an overview of the command, execute:"
"$SCRIPT --help"
    )

    [[ -n $message ]] && printf "%s\\n" "$message"

    printf "%s\\n" "${txt[@]}"
}



#
# Message to display for version.
#
function version
{
    local txt=(
"$SCRIPT version $VERSION"
    )

    printf "%s\\n" "${txt[@]}"
}



#
# Function for taking care of specific command. Name the function as the
# command is named.
#
# FUNCTION IS USED BUT SHELLCHECK DOESNT UNDERSTAND UNLESS USED 
# DIRECTLY AND NOT DYNAMICALLY; IGNORING SHELLCHECK FOR THIS SECTION
# shellcheck disable=SC2329
function app-command1
{
    WEEKDAY=$(($(date +%w)))
    echo "${QUOTES[WEEKDAY]}"
}



#
# Function for taking care of specific command. Name the function as the
# command is named.
#
# FUNCTION IS USED BUT SHELLCHECK DOESNT UNDERSTAND UNLESS USED 
# DIRECTLY AND NOT DYNAMICALLY; IGNORING SHELLCHECK FOR THIS SECTION
# shellcheck disable=SC2329
function app-command2
{
    echo "This is output from command2."
    echo "Command 2 takes additional arguments which currently are:"
    echo " Number of arguments = '$#'"
    echo " List of arguments = '$*'"
}



#
# Function for taking care of specific command. Name the function as the
# command is named.
#
# FUNCTION IS USED BUT SHELLCHECK DOESNT UNDERSTAND UNLESS USED 
# DIRECTLY AND NOT DYNAMICALLY; IGNORING SHELLCHECK FOR THIS SECTION
# shellcheck disable=SC2329
function app-calendar
{
    local events="$1"

    echo "This is output from command3, showing the current calender."
    cal -3
    (( $? == 127 )) && echo "Error. You might need to install the ncal package using apt install."

    if [ "$events" = "events" ]; then
        echo
        calendar
        (( $? == 127 )) && echo "Error. You might need to install the calendar package using apt install."
    fi
}



#
# Process options
#
while (( $# ))
do
    case "$1" in

        --help | -h)
            usage
            exit 0
        ;;

        --version | -v)
            version
            exit 0
        ;;

        command1         \
        | command2       \
        | calendar)
            command=$1
            shift
            app-"$command" "$*"
            exit 0
        ;;

        *)
            badUsage "Option/command not recognized."
            exit 1
        ;;

    esac
done

badUsage
exit 1
