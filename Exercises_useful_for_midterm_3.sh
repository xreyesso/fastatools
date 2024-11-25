#2. If the input file contains more than $2*2 lines, show it completely.
#Otherwise, show a warning and the first $2 and the last $2 lines
NLINES=$(grep -c "" $1)
if [[ $NLINES -le $(( $2 * 2 )) ]]
then
	cat $1
else
	echo The file has more than 2*$2 = $(( $2 * 2 )) lines
	head -n $2 $1
	echo ...
	tail -n $2 $1
fi


##script to receive 1 file as argument, and show the first and last 3 lines
head -n 3 $1
echo ...
tail -n 3 $1

##script modified to receive 2 arguments, and show the first and last n lines of the file given
head -n $2 $1
echo ...
tail -n $2 $1

##script modified,if the user does not provide $2,it must default to 3
#1. If user does not provide $2,it must default to 3
if [[ $# -eq 1 ]]
then
    head -n 3 $1
    echo ...
    tail -n 3 $1
elif [[ $# -eq 2 ]]
then
    head -n $2 $1
    echo ...
    tail -n $2 $1
else
    echo The number of arguments passed is not allowed
fi

#script modified. If the input file contains more than $2*2 lines, show it completely.
#Otherwise, show a warning and the first $2 and the last $2 lines
NLINES=$(grep -c ""$1)
if [[ $NLINES -le $(( $2 * 2 )) ]]
then
	cat $1
else
	echo Warning: The file has more than 2*$2 = $(( $2 * 2 )) lines
	head -n $2 $1
	echo ...
	head -n $2 $1
fi

