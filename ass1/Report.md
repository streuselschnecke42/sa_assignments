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
It took quite some time and experimenting but the script [backup.bash](./backup.bash) should be error prune and create the backup in the correct file now. I first created a backup using the script. The script will search for the directory that was entered inside the cwd (current working directory) and take the first one it finds. Since the task didn't specify. Below is the initial version of it, that required sudo access. I have changed that, since (for some reason) now it doesn't need it anymore?\
![](./images/backup_script/create_backup.png)\
Here is the recreation of the creation of the backup using the newer refined version of the script.\
![](./images/backup_script/better_backup.png)\
As visible, execution time has improved aswell. What has changed? I removed the feature that searches the entire root directory for the entered folder preventing possible system crashes due to too intense searches. If the HOME directory is really big, it could lead to system crashes when using `find` like my old version of the backup script was using. Luckily, my HOME directory has almost nothing, so I got lucky when using the script. The old backup script can be seen [here](./old_backup_scripts/second_backup.bash).

After the backup file has been created it prints the elapsed time, a confirmation that it was created and the name of the file.\
I have also done some error testing to see what happens if there are too little or too much arguments, if the directory doesn't exist, and what happens if the backup already exists. All seem to work fine and print a custom error message together with the elapsed time. I was unsure if the elapsed time was needed for error cases aswell, but the task didn't argue against it so I left it in.\
![](./images/backup_script/misuse_backup_script.png)

### Backup file relating to the directory being backed up
**Question 1:** Would it be possible to enhance the naming of the backupfile so it relates to the directory being backed up? How would you then name the backupfile?

Yes, it is possible to do that! I would most likely take argument `$1` and extract the basename of it to it inside the filename. `$1` stands for the input the user gives when using the command to execute the `backup.bash` script. So, `$1` is the name (or path included) of the directory. Some users might enter directories like `./folder` or `path/to/folder`, which would mess up the name if I would only use `$1` inside the name of the backup. Therefore I must use `DIR_NAME=$(basename "$1")`. So, instead of `backup_"$DATUM".tar.gz` it could be for e.g. `backup_"$DIR_NAME"_"$DATUM".tar.gz`.\
Example: I enter `bash backup.bash Desktop/HamsterImages` and today's date is 2026-01-22. So, the corresponding backup file would be `backup_HamsterImages_2026-01-22.tar.gz`.

### Adding Timestamps
**Question 2:** Is it possible to add a timestamp to the backup so you could take several backups without overwriting the existing ones? How would then the filename look like?

Of course, it is possible. You could combine that time with the date that I already use in my script. By changing the systax from `DATUM=$(date +%Y-%m-%d)` to `DATE=$(date -d "today" +"%Y%m%d%H%M%S")`. You could also change the variable for better logic into something like "TIMESTAMP".\
Example: I enter `bash backup.bash Desktop`, today's date is 2026-01-22 and the time at that exact moment is 03:26:59 (Format HOURS:MINUTES:SECONDS). So, the corresponding backup file would be `backup_Desktop_20260122032659.tar.gz`.

## ShellCheck
I first used the web version of it.
Sometimes it was really confusing. I had some odd encounters with this website. It told me for e.g. to add `""` around my variable, but when I did that, it told me to remove them. When I reverted it, it again told me to add the quotation marks. When clicked on "apply" inside the ShellCheck Output instead of fixing it manually and copy-pasting it back in the website, it didn't complain.\
Since, those encounters on the website were quite strange, I decided to just install it locally using `sudo apt install shellcheck` and adding an extention for it to VS Code. I tried to recreate the same issues as mentioned in the last paragraph, and it was much more consistent.

