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

    # Can assign integers (used for text manipulation, not math?)
    my_int=25
    echo "$my_int"

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

# List all files & folders in directory
    ls .
    # Stuff that starts with "." are hidden but -a shows all files
    ls -a .

# Wait for text input from user and store in variable
    echo -e "\nEnter a fruit"
    read fruit
    echo -e "\n You entered: $fruit"
