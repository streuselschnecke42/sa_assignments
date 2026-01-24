# Lab Report for Assignment 1
### Michelle Weber

## Customizing my environment
### Setup
The operating system, that I used for this assignment is Linux Mint. The terminal I use is kitty and the shell is zsh.
![](./images/customize/neofetch.png)
### Customization
[oh-my-zsh](./images/customize/omz.png) does already a lot of customization.
The default prompt in this shell can be changed in the `.zshrc` file. My initial theme was "robbyrussell" as seen in the [.zshrc file snippet](./images/customize/zsh_theme.png) but lets change it to ["Anka says: "](./images/customize/update_PS1.png). To achieve this, the .zshrc file has to be changed like [this](./images/customize/update_PS1_in_file.png). Since I prefer the original, I will now change it back to the initial design.\
![](./images/customize/change_theme_back.png)\
I also already use a customized version of the terminal that makes noises when doing certain things. So, if I for e.g. type `cd` and then press `tab` it makes a water drop noise.\
The [theme of the kitty terminal](./images/customize/kitty_themes.png) can be chosen by using the command `kitty +kitten themes`. There are so many themes to choose from. The one that I chose is called "Box". The font that I use is called "Fira Code".
### Aliases
Just like in the customization part, the aliases have to be set in the `.zshrc` file. I have written them on the bottom of the file. The initial aliases that I created, look like this now:\
![](./images/alias/three_aliases.png)\
(to see the full screen file [click me](./images/alias/alias_edit_zshrc.png))\
In order to make those aliases work, I used `source ~/.zshrc` but restarting also works fine. Without doing any of that the shell doesn't recognize the newly added aliases. I need to make it so the shell reads the file `.zshrc` again.\
The first one just prints a phrase in the terminal. The second one opens this assignment on my local machine in vs code. The third one does not work properly. I have realized that later as this does not open DuckDuckGo search, but rather "https://hamster", which doesnt work. Therefore, I have corrected it.\
![](./images/alias/alias_retry.png)\
Now, it redirects me to an image link of a hamster image that I found online.\
![](./images/alias/demonstrate_aliases.png)\
Why is a link to a hamster useful? It's not particularly about the link. I do personally like hamsters, so this is a funny gimmick but it's also teaching me how links and the firefox command properly work together. I did not know that before and have therefore, documented my mistake here aswell.

## Backup Script
It took quite some time and experimenting but the script [backup.bash](./scripts/backup.bash) should be error prune and create the backup in the correct file now.\
The script will search for the directory that was entered inside the cwd (current working directory) and take the first one it finds. Since the task didn't specify. To search the system for a directory I used:

    find "$HOME" -type d -name "$1" -print -quit 2>/dev/null

which was mentioned in [[1]](#references).

To execute the script, you type:

    bash path/to/backup.bash path/to/desired/directory

After the backup file has been created successfully, it prints the elapsed time, a confirmation that it was created and the name of the file.
Below is a image of the execution of the initial version of it, that required sudo access. I have changed it in the final version, since (for some reason) now `mv` at first needed it and then didn't anymore..\
![](./images/backup_script/create_backup.png)\
Here is the recreation of the creation of the backup using the current (safer) version of the script.\
![](./images/backup_script/better_backup.png)\
As visible, execution time has improved aswell. What has changed? I removed the `find` command that searches the entire HOME directory for the entered folder, preventing possible system crashes due to too intense searches. If the HOME directory is really big, it could lead to system crashes when using `find` like my old version of the backup script was using. Searching less, also needs less time, according to [[3]](#references). My HOME directory has almost nothing, so I got lucky when using the old script. The old backup script can be seen [here](./scripts/old_backup_scripts/second_backup.bash).

For the error handling aspect of the script, I have used Method 1 from [[2]](#references). Below is a snippet of the backup script, where the system will only return true if the input directory (`$1`) exists. Otherwise, it will print the custom error message and ends the program prematurely with exit value 1, which means fail.

    if [ ! -d "$1" ]; then
        echo "Directory not found."
        finish_time "$SECONDS"
        exit 1
    fi

I have done some error testing on the script to see what happens if there are too little or too much arguments, if the directory doesn't exist, and what happens if the backup already exists. All seem to work fine and print a custom error message together with the elapsed time. I was unsure if the elapsed time was needed for error cases aswell, but the task didn't argue against it so I left it in.\
![](./images/backup_script/misuse_backup_script.png)

To also prevent bash output and making sure only my custom error messages appear (and NOTHING else). I have looked at [[4]](#references), which uses:

    2>/dev/null

To show an actual usage of this inside my script, we can look at line 46 of [backup.bash](./scripts/backup.bash):

    mv backup_"$DATUM".tar.gz /tmp 2>/dev/null

There, the backup file gets moved from the current working directory into `/tmp`. To explain `2>/dev/null`, according to [[4]](#references), `2>` is used when you want to redirect errors. Any error output will be redirected to the "null device", which is, as the name implies, basically sends everything into the void that it receives.\
The script also needed the current date in its name. As visible in the above code snippets, im using the variable `$DATE` but never mentioned how it is created. According to [[6]](#references), you can add any date related information using the `date` command combined with other specific arguments to filter what information you want. I have used it like this:

    DATUM=$(date +%Y-%m-%d)

This way, I get the format year-month-date in one argument and store it on `DATUM`.\
To calculate the elapsed time, i have used a custom function. According to [[5]](#references), you calculate the time like this:

    SECONDS=0
    # do some work
    duration=$SECONDS
    echo "$((duration / 60)) minutes and $((duration % 60)) seconds elapsed."

In my script, I have used a similar way. Only that I have split it up, and used a custom function, like [[7]](#references) explained, that I then can call from anywhere inside the script.

    finish_time () {
        DURATION=$1
        MIN=$((DURATION / 60))
        SEC=$((DURATION % 60))
        echo "Execution time: $MIN minutes and $SEC seconds"
    }

    # START TIMER
    SECONDS=0

The function also takes an argument. However, I have not done any error handling for that specific function, since it will only be used inside the script. It must not be used outside the script!

### Questions
#### **Question 1:** Would it be possible to enhance the naming of the backupfile so it relates to the directory being backed up? How would you then name the backupfile?

Yes, it is possible to do that! I would most likely take argument `$1` and extract the basename of it to it inside the filename. `$1` stands for the input the user gives when using the command to execute the `backup.bash` script. So, `$1` is the name (or path included) of the directory. Some users might enter directories like `./folder` or `path/to/folder`, which would mess up the name if I would only use `$1` inside the name of the backup. Therefore I must use

    DIR_NAME=$(basename "$1")
    
inside the script. So, instead of `backup_"$DATUM".tar.gz` it could be for e.g. `backup_"$DIR_NAME"_"$DATUM".tar.gz`.\
Example: In the Home directory, I enter:

    bash Desktop/sa_assignments/ass1/backup.bash Desktop/HamsterImages

and today's date is 2026-01-22. So, the corresponding backup file would be `backup_HamsterImages_2026-01-22.tar.gz`.

#### **Question 2:** Is it possible to add a timestamp to the backup so you could take several backups without overwriting the existing ones? How would then the filename look like?

Of course, it is possible. I could combine that time with the date that I already use in my script. [[6]](#references) already explains this in full detail.\
I can get that full timestamp by changing the systax from 

    DATUM=$(date +%Y-%m-%d)
    
to

    DATE=$(date -d "today" +"%Y%m%d%H%M%S")
    
You could also change the variable for better logic into something like "TIMESTAMP", or change the syntax to have "-" inbetween the numbers. A lot of customization is possible, but I would do it like mentioned above.\
Example: I am currently in the Home directory and I enter:

    bash Desktop/sa_assignments/ass1/backup.bash Desktop
    
Today's date is 2026-01-22 and the time at that exact moment is 03:26:59 (Format HOURS:MINUTES:SECONDS). So, the corresponding backup file would be `backup_Desktop_20260122032659.tar.gz`.

### Sourcecode
[backup.bash](./scripts/backup.bash)

### Important Note (Please read before moving further!)
My filestructure, when creating and running the bachup.bash script was different than when I was doing the tasks below. My original file structure (at the point of creating and running backup.bash) was:

    Desktop/
        sa_assignment/
            README.md
            ass1/
                images/
                backup.bash
                notes.txt
                Report.md

Therefore, the screenshots and mentioned execution syntax when running backup.bash, and when running the other scripts **below**, will **differ**. The new file structure is just like the repository.

## File Size Analyser Script
// TODO

### Questions
#### **Question 1:** Reflect on the final code and consider if this could be implemented as a one line command? Is one line commands good or bad?
// TODO

### Sourcecode
[large_files.bash](./scripts/large_files.bash)


## Text Analyser Script
Task REMOVE LATER
A file size analyser

Do the following and document it in the lab report.
- Write a script large_files.bash <path> 
- takes a directory path as an argument 
- scans it recursively to find all files and their size.
- The script should check if the path exists, otherwise it should produce an error message and exit with an error code.

- The script should write a report on the 5 largest files found (show the largest file first)
- and the
    + total size of these files should be printed
    + together with details on the type of the file.
- The script should also write out the total number of files scanned and
- the total filesize for the target path.
// TODO

### Questions
#### **Question 1:** Reflect on your final code, is it "good and clean" or do you see improvement areas?
// TODO

#### **Question 2:** Do you see any security risks in downloading and analysing a file like this? Consider you are printing out details of the file into the terminal. Could this be used to attach your system? If there is a threat, can you protect your application?
// TODO

### Sourcecode
[analyse.bash](./scripts/analyse.bash)


## Extend Existing Example Script
// TODO

### Questions
#### **Question 1:** Reflect on the cli code and compare it to other programming languages you have learnt. Talk about the similarity/differences and what is good/bad.
// TODO

### Sourcecode
[cli.bash](./scripts/cli.bash)


## How to learn Linux
#### **Question:** Lets say you have a friend that wants to learn Unix and the shell. What would be your suggestion to your friend on the five most important steps to start learning?
//TODO


## ShellCheck
I first used the web version of it.
Sometimes it was really confusing. I had some odd encounters with this website. It told me for e.g. to add `""` around my variable, but when I did that, it told me to remove them. When I reverted it, it again told me to add the quotation marks. When clicked on "apply" inside the ShellCheck Output instead of fixing it manually and copy-pasting it back in the website, it didn't complain.\
Since, those encounters on the website were quite strange, I decided to just install it locally running

    sudo apt install shellcheck

in the terminal and adding an extention for it to VS Code. I tried to recreate the same issues as mentioned in the last paragraph, and it was much more consistent with its' complaints.


## TIL _(Today I Learned...)_
// TODO


# References
Template REMOVE LATER[
    [#] A. A. Author, “Title of page,” Website Name. [Online]. Available: URL. [Accessed: Day-Month-Year].
]


[#] Author (if any), “Title,” Website Name, Month Day, Year. [Online]. Available: URL [Accessed: Day-Month-Year].


[1] Sagar Sharma, "Find a Directory in Linux", "Linux Handbook", Jul 22, 2023. [Online]. Available: https://linuxhandbook.com/find-directory/ [Accessed: 23-Jan-2026]

[2] Lubos Rendek, "Try-Catch in Bash: Bash Script Error Handling", "LinuxConfig", Sep 21, 2025. [Online]. Available: https://linuxconfig.org/bash-script-error-handling-try-catch-in-bash [Accessed: 23-Jan-2026]

[3] Unkown, "Mastering the Linux `find` Command for Directory Search", "LinuxVox.com", Nov 14, 2025. [Online]. Available: https://linuxvox.com/blog/linux-find-directory/ [Accessed: 23-Jan-2026]

[4] Monira Akter Munny, "How to Suppress Output in Bash [3 Cases With Examples]", "LinuxSimply", May 4, 2024. [Online]. Available: https://linuxsimply.com/bash-scripting-tutorial/input-output/output/suppress-output/ [Accessed: 23-Jan-2026]

[5] Rob Bednark and Daniel Kamil Kozar, "How can I calculate time elapsed in a Bash script?", "Stack Overflow", Mar 13, 2024. [Online]. Available: https://stackoverflow.com/questions/8903239/how-can-i-calculate-time-elapsed-in-a-bash-script [Accessed: 23-Jan-2026]

[6] Zach Bobbitt, "Bash: How to Add Timestamp to a Filename", "Collecting Wisdom", Aug 17, 2024. [Online]. Available: https://collectingwisdom.com/bash-add-timestamp-to-filename/ [Accessed: 23-Jan-2026]

[7] Aaron Kili, "How To Write and Use Custom Shell Functions and Libraries", "Tecmint", Feb 7, 2017. [Online]. Available: https://www.tecmint.com/write-custom-shell-functions-and-libraries-in-linux/ [Accessed: 23-Jan-2026]

# Other useful links
## Linux-related
https://itsfoss.com/display-linux-logo-in-ascii/ \
https://stackoverflow.com/questions/6212219/passing-parameters-to-a-bash-function

## IEEE usage
https://www.scribbr.com/ieee/ieee-paper-format/ \
https://docs.google.com/document/d/1j1L96U2NagwWI9MEVDNVKt9pXxRzTH7h3krI3Mb6wZE/edit?tab=t.0
