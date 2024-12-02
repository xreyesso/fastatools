#!/bin/bash

# ALG midterm 3
# The script takes two optional arguments:
# The folder X where to search the files, default: current folder
# A number of lines N, default: 0

# We first check whether the number of arguments is correct. If it is, try to accommodate them in the correct variable
if [[ $# -gt 2 ]] # If more than two arguments are given, exit the program
then
  echo "The number of arguments passed is greater than expected"
  exit 1
fi

if [[ $# -eq 0 ]] # If no arguments are given, use the default values
then
    N=0
    FOLDER=.
fi

if [[ $# -eq 1 ]] # If one argument is given, check first whether it is numeric
then
  if [[ $1 =~ ^-?[0-9]+$ ]] # If argument is numeric, use it as N and set FOLDER to current folder
  then
    N=$1
    FOLDER=.
  else # If the argument is not numeric, use it as FOLDER and set N to 0
    FOLDER=$1
    N=0
  fi
fi

if [[ $# -eq 2 ]] # If two arguments are given, check whether one is numeric and assign it to N
then
  if [[ $1 =~ ^-?[0-9]+$ ]] # Check whether the first argument is a number
  then
    N=$1
    FOLDER=$2
  else
    N=$2
    FOLDER=$1
  fi
fi

# Now, check if all arguments are correct
if [[ -d $FOLDER ]] # With the option -d, we check if the given path exists AND is a directory
then
  if [[ -r $FOLDER ]] # Check if we have permission to read the directory
  then
    if [[ ! -w $FOLDER ]] # Check if we have permission to write in the directory, since this is necessary to compute
    # the number of unique fastaIDs
    then
    	echo "The folder does not have write permission, and this is necessary for further steps"
    	exit 1
    fi
  else
    echo "The folder specified does not have read permission"
    exit 1
  fi
else
  echo "The given path is not a directory or the directory does not exist"
  exit 1
fi

if [[ $N =~ ^[-] ]]
then
  echo "The number of lines provided is not valid"
  exit 1
fi

# Find FA/FASTA files
FASTA_FILES=$(find $FOLDER -type f -name "*.fa" -or -name "*.fasta")
N_FILES=$(echo "$FASTA_FILES" | wc -l)
echo "##################### REPORT #####################"
echo "There are $N_FILES fa/fasta files in the provided folder"

if [[ $N_FILES -eq 0 ]]; then
  echo "No FA/FASTA files to process."
  exit 0
fi

#Determine fasta IDs
touch $FOLDER/fasta_ids
find $FOLDER -type f -name "*.fa" -or -name "*.fasta" | while read FILE
  do
    grep ">" $FILE | sed 's/>//' | awk '{print $1}' >> $FOLDER/fasta_ids
  done

# Print the number of unique fastaIDs
N_UNIQUE_IDS=$(sort $FOLDER/fasta_ids | uniq | wc -l)
echo "There are $N_UNIQUE_IDS unique fasta IDs in the given folder"
echo "-------------- REPORT PER FILE --------------"

# Process FA/FASTA files
#echo "$FASTA_FILES" | while read FILE; do
find $FOLDER -type f -name "*.fa" -or -name "*.fasta" | while read FILE; do
    FILENAME=$(basename "$FILE") # The basename command is used to extract the file name from the path
    echo "######## Processing: $FILENAME ########"

    SYMLINK=$(test -h "$FILE" && echo "Yes" || echo "No") # TODO: Did we cover the 'test' keyword in the course?
    echo "Symbolic link: $SYMLINK" # Smart way to print it

    if [[ ! $FILENAME =~ ^[a-zA-Z] ]]; then
        echo "Error: Invalid filename format. Skipping."
        continue
    fi

    # Sequence Type Detection
    SEQUENCES=$(sed '/>/! s/-//g; s/ //g' $FILE | grep -v '>' | tr -d '\n')
    if echo "$SEQUENCES" | grep -q "[defhiklmpqrsvwxyDEFHIKLMPQRSVWXY]"; then # TODO: Why do we only check uppercase?
      TYPE="AMINO ACID" # Good idea!
    else
      TYPE="NUCLEOTIDE" # Good idea!
    fi
    echo "Type: $TYPE" # TODO: I need to show this in the header, how to do that without duplicating the find... command?

    # Sequence stats
    NSEQ=$(grep -c "^>" "$FILE")
    SEQ_LENGTH=$(echo -n "$SEQUENCES" | wc -m) # echo -n "$SEQUENCES" outputs the sequences without an extra newline
    echo "Number of Sequences: $NSEQ"
    echo "Total Length: $SEQ_LENGTH"

    # File preview
    NLINES=$(wc -l < "$FILE") # Alternative syntax, discouraged in class but suggested by ChatGPT
    echo "The number of lines of the file is: $NLINES"
    if [[ $N -gt 0 ]]; then
      if [[ $NLINES -le $((N * 2)) ]]; then
        echo "File content:"
        cat "$FILE"
      else
        echo "File preview:"
        head -n "$N" "$FILE"
        echo "..."
        tail -n "$N" "$FILE"
      fi
    fi
  done


