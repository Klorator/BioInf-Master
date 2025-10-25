# A "shebang" (#!) shows where to find Bash executable. Needed for a script to run.
    # Find path to Bash with the command
    # $ which bash
#!/usr/bin/bash

# Cheat sheet: https://devhints.io/bash

# To be able to run a file
    # chmod modifies the permissions of a file for the current user
    # u+x adds execution rights to current user
    # .Notes_Bash.sh path to file to run
# chmod u+x .Notes_Bash.sh

# To run a file, any of:
    # sh .Notes_Bash.sh
    # bash .Notes_Bash.sh
    # ./.Notes_Bash.sh

# Change working directory
    # cd /c/Programming/Projects/BioInf-Master

# Directory paths
    # ~ refers to home dir
    # . refers to current dir
    # .. refers to parent dir
    # Absolute path start with /

# find full absolute path to current dir
pwd

# List all files & folders in directory
    ls .
    # Stuff that starts with "." are hidden but -a shows all files
    ls -a .
    # long format -l, same as ll
    ls -l
    ll
    # list files in other dir
    ll ..
    # * wildcard
    ll .. *.txt
    # -h File size human readable

# Moving around
    # cd [dir] # move into dir
    # cd .. # move up a dir
    # cd ../[dir] # moving around folders is fluid
    # cd - # remembers 1 previous folder

    # mkdir [dir] # create folder
    # rmdir [dir] # can only remove empty folders

# File management, assumes relative path
    # use tab completion, pressing tab more times prints possible options
    # cp [name of original] [name of copy] # copy file
        # -r to copy recursively = all subfolders & files
    # mv [name of original] [name of copy] # move file (changes the files adress on harddrive)
    # ln [file] [path to link] # creates a link to file
    # rsync # copy files to/from remote server, only if on linux server
        # -a copy modification date
        # -P show progress
        # [user@host]:[remote file] [local dir] # download
        # [local file] [user@host]:[remote dir]  # upload
    # scp [local file] [user@host]:[remote dir] # from windows to linux server via ssh
        # -r Recursive, copies all subfolders and files
        # Example executed from powershell:
            # scp raha1670@solander.ibg.uu.se:/home/raha1670/1MB438/phylo_proj/Results/align_seq.cytb.fasta C:\Programming\Projects\
            # Seems like having '-' in folder name causes problems?

    # md5sum [file] # hash fingerprint, for comparing files

    # find [dir] -name [file]
        # -iname # case insensitive
    # grep [regEx] [file] # match text in file
        # -r recursively

    # cat [file name] # print file to terminal
        # > [file name] # write to file
        # >> [file name] # append to file
    # less [file name] # read file content, move up/down with arrows, exit with Q
    # head [options] [file name] # print first 10 rows, -n = n lines
    # tail [options] [file name] # print first 10 rows, -n = n lines
    # wc [file name] # word count, print n newlines/words/bytes
        # -l newlines
        # -w words
        # -m characters
        # -c bytes

    # nano [file name] # open editor, ^ means hold ctrl

    # rm [file name] # remove file, deletes immedietly
        # -r remove recursively, can delete folder and everythin in it!

    # tar -xzvf [file name] # unpack zipped file (my_files.tar.gz)
        # -xzvf = e*X*tract from *Z*ipped file, *V*erbose (print file name), from *f*ile

    # file permission e.g. -rw-rw-r-- where:
        # first symbol = type
            # d Directory (need execute permission to see inside)
            # - regular file
            # 1 symbolic link
            # c Character device file
            # b Block device file
        # Followed by three permissions in order
            # r Read    (first)
            # w Write   (second)
            # x Execute (third)
            # - No permissions (any spot)
        # Permissions are repeated for
            # User
            # Group
            # Other/Everyone else
    # chmod [option] [group][+-=][permissions] [file name] 
        # *CH*ange *MOD*e. Only owner can change permission.
        # [option]
            # -R recursively
        # [group]
            # u User
            # g Group
            # o Other/Everyone else
            # a All three
        # [+-=]
            # + Add
            # - Remove
            # = Wipe and add new

# Info
man ls # documentation
top # view processes running on the computer
# alt + b/f same as ctrl + left/right arrow

# Git
    # git pull # while in repo folder, pull to update

# Broken terminal
    # ctr + C # kills current process (polite)
    # kill [process ID] # get ID using top in new terminal
        # -9 really kill it
    # pkill [process name] # might kill multiple!
    # ~. # break ssh connection

######################################################################
# Programs/functions
# samtools # working with .bam files
# basename & dirname


######################################################################

# Print to terminal
    echo "Hello scripting"
    # -e allows for escape characters, like \n for new line
    echo -e "----------\nHello user\n----------"

# Print todays date (`date` is a built in constant?)
    echo "Today is " `date`

# Assign variable with no spaces! & use them with $ prefix
    my_text="string"
    echo "$my_text"

    # Can assign integers, math operations require $(($var+$var))
    my_int=25
    echo "$my_int"
    echo $my_int squared is $(($my_int*$my_int))

    # Parameter expansion with {} (modifications)
    long_string="This is a long text message."
    echo "${long_string}"
        # Substitution
        echo "${long_string/long/very long}"

        # Print n characters from string
        n_length=7
        echo "${long_string:0:n_length}"

        # Print n characters starting from 5 (not characters 5 to n_length!)
        echo "${long_string:5:n_length}"

        # Skip first n characters
        echo "${long_string: -9}"

        # String length
        echo "${#long_string}"

        # Indirection
        long_string_indirect="long_string"
        echo "${!long_string_indirect}"

        # Default value (no spaces), works with 'var=' (returns null) & 'var=""' (empty)
        echo "${missing:-"DefaultIfMissing"}"
    
# Always use variables inside ""
    name="Rasmus"
    echo "Double quotes: Hello $name"
    echo 'Single quotes: Hello $name'

# Wait for text input from user and store in variable
    echo -e "\nEnter a fruit"
    read fruit
    echo -e "\n You entered: $fruit"

# Write output to file
    echo "Write this to file" > my_file.txt # overwrite
    echo "This also" >> my_file.txt # append

# functions inside lines to eval variables
    # $(basename $file_path .txt)

# For-loop
for var in 1 2 3;
do
    echo $var
done

# if-statement
if [[ "Hello" == "Hello" ]]; then
    echo "Hello"
fi
    # (( compare numbers ))
    # -lt Less than
    # -gt Greater than


# Passing arguments to scripts
    # inside script
        # $0 # name of program
        # $1 # arg1
        # $2 # arg2
        # etc.