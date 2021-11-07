#!/bin/perl
#########################################################################################################################
# Description: The script extracts single lines of a file which contains the specific field and creates a new file with the date & timestamps
# Complete Date: 24th Jan 2011
# Input: Currently with execute permissions, the script can be run as <filename>.pl <service_number>
# Output: Based on the search key, the same is printed to stdout and a file in the same directory
# Author: Praneeth N
# Usage: Provide execute permissions to the script and run file using - <filename> <AbsolutePath> <service_number>
#########################################################################################################################
# use warnings;
use File::Basename;
use File::Copy;
#########################################################################################################################

&Main;
sub Main
{
 if ($^O =~ /MSWin32/) { system "cls"; } else { system "clear";}
 
 $abspath=shift(@ARGV);							# Obtain the absolute path
 
 if (!$ARGV[0] )  {  print "\n Script Usage - \n \t eg: $0 3065271214 \n"; exit 1; }
 
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
   
 @files = <*>;
 # print "\n files are ---- @files";
 
 $Searchstr=$ARGV[0];
 if (! -d $Searchstr) { mkdir "$Searchstr"; } #else { system("$mov $Searchstr $Searchstr_t()");
  
 foreach $file (@files) 
 {	
	print " \n --------------------------------------------------------";
	print " \n \t Loading file .... - $file"; 

	if (-e $file) 	
	{	
	open (RdFile, "$file");
	@Fcon = <RdFile>;		# Get content of a file and check if they have the number. In case they do, write them to a file.
	close RdFile;
		
	for ($i=0;$i<=$#Fcon;$i++)
	{
		if ($Fcon[$i] =~ /$Searchstr/)
		{
			$Fname = "$Searchstr" . "\-$i";
			print "\n the file name is $Fname \n";
			open( FH, ">>$Fname") or die $!;
			print FH "$Fcon[$i]";
			close FH;
			$count=0;
			$count++;
			print "\n \t Printed $count records to the file - $Fname\n";
			!system ("$mov $Fname $Searchstr/$Fname") or die $!;
		}
	}
	}
	print " \n --------------------------------------------------------\n";
 }
}
# last
1;