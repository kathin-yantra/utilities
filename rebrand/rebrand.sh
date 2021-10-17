#!/bin/sh
###############################################################################################################################
# Aim: Modify filenames and file contents based on patterns in a pattern.sed file and a working directory
# Inputs: patterns in sedpattern.txt file placed in the directory of execution; Execute script from the source data directory
# Outputs: Initial filelist, old and new filenames, sedpattern.txt placed in /tmp post script execution
###############################################################################################################################
dirFlag="false";
tempfilelist="tempfl";
filelist="filelist";
sedpattern="pattern.sed";
COMMENT_CHAR=#;
fileExts='\.txt$\|\.sh$\|\.bat$\|\.xfd$\|\.xsd$\|\.tx$\|\.properties$\|\.xml$\|\.cfg$\|\.config$\|\.sql$\|\.jmx$\|\.parameters$\|\.conf$\|\.ini$';
excludeFileExts='3\.3\/printable\|3\.3\/bin\|3\.3\/licenses\|3\.3\/extras\|3\.3\/lib\|3\.3\/docs';
filesmeta="files.properties"

if [ -d "processes" ]; then
    dirFlag="true";
fi

if [ $dirFlag = "true" ]; then
	find . -name "*" -type f >> $tempfilelist;
	grep $fileExts $tempfilelist | grep -v $excludeFileExts | sort -u >> $filelist;
	rm -f $tempfilelist;
else
	printf "\n Ensure right directory";
	exit 0;
fi

# from filelist, get each file, run for sed script in file and on filename

while read line
	do
		first_char=$(echo $line | cut -c1-1);
		if [ "$first_char" = "$COMMENT_CHAR" ]; then
				echo "Ingoring comment line:$line"
				continue
		else
				echo "Processing file:$line"
		fi
		
		origfname=$line;
		if [ -f "$line" ]; then
		 	newfname=$(echo $line | sed -f $sedpattern);
			echo "$origfname=$newfname" >> $filesmeta;
			tmpfname="$newfname"".tmp";
			sed -f $sedpattern $origfname > $tmpfname;
			mv $tmpfname $newfname;
			rm -f $tmpfname;
			if [ -f $newfname ] && [ "$origfname" != "$newfname" ]; then
				rm -rf $origfname;
			else
				printf "\n not removing file: $origfname";
			fi
		fi
		
done < $filelist

if [ -f $filelist ] || [ -f $filesmeta ] || [ -f $sedpattern ]; then
	mv $filelist $filesmeta $sedpattern /tmp;
fi

