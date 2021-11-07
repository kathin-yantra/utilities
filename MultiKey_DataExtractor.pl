#!/bin/perl
#########################################################################################################################
# Description: The script extracts single lines of a file which contains the specific field and creates a new file with the date & timestamps
# Completion Date: 24th Jan 2011
# Input: Multiple search keys
# Output: Based on the search keys, the same is printed to files in a results directory
# Author: Praneeth N
# Usage: Provide execute permissions to the script and run file using - <filename> <AbsolutePath> <service_number> <Timestamp> <Duration> <SequenceNum> <AnyValidContents>
#########################################################################################################################
# use warnings;
use File::Basename;
use File::Copy;
#########################################################################################################################

&Main;
sub Main
{
 if ($^O =~ /MSWin32/) { system "cls"; } else { system "clear";}
 
 $abspath=shift(@ARGV);								# Obtain the absolute path
 
 if (!$ARGV[0])  {  print "\n Script Usage - \n \t eg: $0 AbsolutePath key1 key2 key3 key4....\n"; exit 1; }
 
 if ($^O =~ /MSWin32/) 
 { 	
	if (! chdir("$abspath")) { $abspath = `cd`; } 	# Change to user defined or retain current path Windows
	$mov="move";
 }
 else 
 { 
	if (! chdir("$abspath")) { $abspath = `pwd`; }	# Change to user defined or retain current path in UNIX
	$mov="mv -p";
 }
   
 @files = <*>;										# Get list of files in the directory
 # print "\n files are ---- @files";
 
 @Keys = @ARGV;
 print "\n \t keys are - @Keys";
 
 $ResDir = "ResultantDir";							# Create a directory for results
 if (! -d $ResDir) { mkdir "$ResDir" or die "Unable to create $ResDir: $!"; } #else { system("$mov $Searchstr $Searchstr_t()");
 
 foreach $file (@files) 
	{	
		print " \n --------------------------------------------------------";

		if (-e $file)
		{
		open (RdFile, "$file");
		@Fcon = <RdFile>;		# Get content of a file and check if they have the number. In case they do, write them to a file.
		close RdFile;
		
		$Fname = "$file" . "_tmp";
		print " \n \t Loading file .... - $file";
		open( FH, ">>$Fname") or die "$Fname - unable to open: $!";
		
		# Record count in a single file for all keys
		$count=0;
		foreach $key (@Keys)
		{
		for ($i=0;$i<=$#Fcon;$i++)
		{
			if ($Fcon[$i] =~ /$key/)				# Search for keys in file contents, if present, write to new file
			{
				print FH "$Fcon[$i]";
				$count++;
			}
		}
		}
			close FH;		
			print "\n \t Printed $count records to $Fname \n";
		}
	!system("$mov $Fname $ResDir/$Fname") or die "File $Fname move failed: $!";
	}
	print " \n --------------------------------------------------------\n";
}
# last
1;