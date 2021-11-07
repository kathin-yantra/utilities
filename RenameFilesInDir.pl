#!/bin/perl
#########################################################################################################################
# Description: The script extracts files and replaces them with common new filenames
# Dated: 25th Jan 2011
# Input: The file prefix and suffixes needed
# Output: Filenames are modified to include prefix and suffix for all files in the directory
# Author: Praneeth N
# Usage: Provide execute permissions to the script and run file using - <filename> <AbsolutePath> <Prefix> <SuffixOptional>
#########################################################################################################################
# use warnings;
use File::Basename;
use File::Copy;
#########################################################################################################################

$cwd="";

&Main;
sub Main
{
 if ($^O =~ /MSWin32/) { system "cls"; } else { system "clear";}
 
 $abspath=shift(@ARGV);								# Obtain the absolute path
 
 if (!($ARGV[0] or $ARGV[1]))  {  print "\n Script Usage - \n \t eg: $0 <AbsolutePath> <Common-Prefix> <Common-SuffixOptional>\n"; exit 1; }
  
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
 chdir "$abspath";
 @files = <*>;
 #print "\n \t wd is ---- $abspath";

 #print "\n Prefix ---- $ARGV[0] \n \t Suffix - $ARGV[1]";
 $Prefixstr = $ARGV[0];
 $Suffixstr = $ARGV[1];
 
# if ($Suffixstr -ne null) { $Suffixstr = "_$Suffixstr" }
 if ($#ARGV < 1) { print "\n \t Script Usage: $0 <Prefix> <SuffixOptional>\n"; }

 print "\n Prefix ---- $Prefixstr \n \t Suffix - $Suffixstr";
 
 foreach $file (@files) 
 {	
	print " \n --------------------------------------------------------";
	print " \n \t Loading file .... - $file"; 

	if (-e $file) 	
	{	
		$Fname="$Prefixstr"."_$file"."$Suffixstr";
		!system ("$mov $file $Fname") or die "Unable to move $file: $!";
		print "\n After move ---- $Fname";
	}
 }
 	print " \n --------------------------------------------------------";
}
# last
1;