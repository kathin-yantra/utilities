#!/bin/bash
# set +xv
#==================================================================================
# Author: Praneeth N
# Dated: 17th June 2011
# Desc: takes input as data file and path of target directory and outputs the numbers
#==================================================================================

FILE="$1";
Path="$2";
TargetFiles="$3";

function FindCount()
{
 printf "\n \t Checking file - $FILE contents";
 cd $Path;
 
 printf "\n \t This might take a while, please wait....\n";
 while read LINE
 do
	svccnt=0;
 	LINE=`echo $LINE | tr -d ' '`;	
	svccnt=`grep "$LINE" $TargetFiles | wc -l`;
	svccnt=`echo "$svccnt" | tr -d ' '`;	
	echo "$LINE - $svccnt" >> datacount.csv;
 done < $FILE
 printf "\n \t The count of the data is present in the file - \'datacount.csv\'";
}

function Usage()
{
   printf "\n Usage: `basename $0` <datafile> <targetDir> <TargetFilesInQuotes>\n\n";
   exit 1;
}

function Main()
{
 printf "\n \t ========== multiple keys count finder ========== \n";
 
 if [ "$Path" == "" ] || [ "$FILE" == "" ]; then
  Usage; 
 fi
 
 if [ "$TargetFiles" == "" ]; then
	TargetFiles="*";
 	printf "\n \t No target specified, checking for all files in the directory\n";
 fi

 icount=0;
 
 if [ -f $FILE ]; then
	printf "\n \t Input data File exists as - $FILE";
  # make sure file exist and readable
  if [ ! -f $FILE ]; then
  	echo "$FILE : does not exists";
  	exit 1;
   elif [ ! -r $FILE ]; then
  	echo "$FILE: can not read";
  	exit 2;
   fi

 	icount=`cat $FILE | wc -l`;
	printf "\n  $icount key/s exists in the data file - $FILE";

   # Call the function to get the count	
   FindCount;
 fi
 printf "\n \n \t ========== End of script ========== \n \n";
 exit 0; 
}

# Call the main function
Main;
