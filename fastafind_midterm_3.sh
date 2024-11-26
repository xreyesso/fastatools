#The script should take two optional arguments
#The folder X where to search the files, default: current folder
#A number of lines N, default: 0

FOLDER=$1
#NLINES=$2
#if [[ ! -d $1 ]]
#then
#	echo The argument given is not a directory
#fi

#TODO: how to check $2 is a number?
#TODO: how to set the default of $1 to current dir or default of $2 to 0?

fasta_files=$(find $1 -type f -name "*.fa" -or -name "*.fasta")
n_files=$(find $1 -type f -name "*.fa" -or -name "*.fasta" | wc -l)
echo "####### REPORT ###############"
echo There are $n_files fa/fasta files in the provided folder


#TODO: determine how many unique fasta IDs there are in the fa/files of our folder
#Step 1: print all/create a file with all the fasta IDs
#Step 2: keep the unique ones -> how??

#TODO: for each file print a header with the file name
#Create fasta_ids file in the given folder, we will store all fasta IDs here for further processing
touch $1/fasta_ids
#chmod +w $1/fasta_ids
find "$1" -type f -name "*.fa" -or -name "*.fasta" | while read i
  do
    filename=$i
    #Append name to fasta_ids
    echo $i >> $1/fasta_ids
    #TODO: how to delete the path and only keep the name??
    echo "######" The file name is $filename "#########"
      if [[ -h $i ]]
        then
			  echo The file is a symbolic link
		  else
			  echo Not a symbolic link #TODO: Are these conditions exclusive??
	    fi
		echo "There are: "
		grep ">" $i | sed 's/>//' | awk '{print $1}' >> $1/fasta_ids
		echo "unique fasta IDs"
		#TODO: how to sum all fasta IDs??? I can put all of them in a file and
		#then count the lines, is this a good solution?

		#Compute total number of sequences per file
		#>at the beginning of a string, use ^
		nseq=$(grep "^>" $i | wc -l)
		echo "The number of sequences is: " $nseq

		#Compute the total number of amino acids or nucleotides of ALL sequences in the file
		#First, remove all gaps in the non-title lines and then remove all the titles
		#TODO: how to deal with files like ._sequences.fasta?? Or hidden files???
		echo "The total sequence length of the file is:"
    sed '/>/! s/-//g; s/ //g' $i | grep -v '>' | tr -d '\n' | wc -m
    # tr -d '\n' removes new lines
  done
#Once the fasta_ids is finished processed, sort, get unique fasta ids and count them
#sort | uniq | wc -l

# remove all gaps in non-title lines:
#sed '/>/! s/-//g' fesor.dbteu.aligned.fa
#Can you print all sequences (omitting titles) in fesor.dbteu.aligned.fa with gaps removed?
#remove all gaps in non-title lines and then then remove all the titles
#sed '/>/! s/-//g' fesor.dbteu.aligned.fa | grep -v '>'
