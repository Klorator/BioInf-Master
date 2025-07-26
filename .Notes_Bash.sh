# A "shebang" (#!) shows where to find Bash executable. Needed for a script to run.
    # Find path to Bash with the command
    # $ which bash
#!/usr/bin/bash

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
    # cd /c/"Program Files"/"R Projects"/BioInf-Master

# Directory paths
    # ~ refers to home dir
    # . refers to current dir
    # .. refers to parent dir

######################################################################

# Print to terminal
    echo "Hello scripting"

# Print todays date (`date` is a built in constant?)
    echo "Today is " `date`

echo -e "\nenter the path to directory"
read the_path

echo -e "\n you path has the following files and folders: "
ls $the_path
