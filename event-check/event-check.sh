#!/bin/bash
# set -x;
# =================================================================================
# Input: log file and testname
# Usage: ./event-check.sh <logFile> <EventName>
# output: stats on STD with logfiles compressed and archived in current directory
# =================================================================================
currentTS=`date +%d%b%Y-%H-%M-%S`;
defaultlogfile="/var/opt/SIU_90FP2VZW/log/SPC_RCS_ACS_SS.log";
logfile="$1";
testname="$2";
infocount=0;
setdebug="cd /opt/SIU_90FP2VZW/bin;./siucontrol -n SPC_RCS_ACS_SS -c setloglevel 8";
tempsummarylog="tempsummarylog";
GREPBIN=`which grep`;
#GREPBIN="${GREPBIN}"; #"-E";
# =================================================================================
function display()
{ 
 clear;
 printf "\n =======================================" >> $tempsummarylog;
 printf "\n ====== Collector test Summary log =====" >> $tempsummarylog;
 printf "\n =======================================" >> $tempsummarylog;
}
# =================================================================================
function makeLogs()
{
 summarylog="summary-${testname}-${currentTS}.log";
 dbcorrelationlog="dbcorelcalls-${testname}-${currentTS}.log";
 dblog="dbcalls-${testname}-${currentTS}.log";
 dbstrucqslog="dbstructuredQueries-${testname}-${currentTS}.log";
 rcfilename="rc-${testname}-${currentTS}.log";
 rceesused="rclist-${testname}-${currentTS}.log";
 duprceeslog="rc_reuselist-${testname}-${currentTS}.log";
 infolog="infolog-${testname}-${currentTS}.log";
 tarfile="EventCheck-${testname}-${currentTS}.tar.gz";
}
# =================================================================================
function summary()
{
 display;
 printf "\n $testname@" >> $tempsummarylog;
 printf "$currentTS" >> $tempsummarylog;
 printf "\n ====== DB ======" >> $tempsummarylog; 
 printf "\n 1. Total database queries          : $dbcalls" >> $tempsummarylog;
 printf "\n 2. Total Lookup queries            : $dblookup" >> $tempsummarylog;
 printf "\n 3. DB search queries null output   : $dblookupnull" >> $tempsummarylog;
 printf "\n 4. upd/ins/del queries             : $dbdml" >> $tempsummarylog;
 printf "\n 5. Unstructured queries            : $dbunstrucqs" >> $tempsummarylog;
 printf "\n 6. Structured queries              : $dbstrucqs" >> $tempsummarylog;
 printf "\n 7. Reused/duplicate DB queries     : check $dbstrucqslog OR" >> $tempsummarylog;
 printf "\n                                      $dbcorrelationlog files" >> $tempsummarylog;
 printf "\n 8. DB logs all                     : $dblog" >> $tempsummarylog;
 printf "\n 9. Structured queries log          : $dbstrucqslog" >> $tempsummarylog;
 printf "\n\n ====== Rulechains ======" >> $tempsummarylog;
 printf "\n a. Total Rulechains used           : $totalrcees" >> $tempsummarylog;
 printf "\n b. Reused/duplicate Rulechains     : $reusedrcees" >> $tempsummarylog;
 printf "\n c. Rulechains log                  : $rcfilename" >> $tempsummarylog;
 printf "\n d. Reused/duplicate Rulechains log : $duprceeslog" >> $tempsummarylog;
 printf "\n\n ====== INFO log ======" >> $tempsummarylog;
 printf "\n e. INFO Log count                  : $infocount" >> $tempsummarylog;
 printf "\n f. Info logs are present in file   : $infolog" >> $tempsummarylog;
 printf "\n\n T. All logs are present in file    : \"$tarfile\"\n" >> $tempsummarylog;
}
# =================================================================================
function dbStats()
{
 # DB queries
 $GREPBIN "AbstractJDBCOperation\|JDBCTask" $logfile >> $dbcorrelationlog;
 if [ -s $dbcorrelationlog ]; then
   dbcalls=`$GREPBIN "JDBCTask" $dbcorrelationlog | wc -l`;
   $GREPBIN "JDBCTask" $dbcorrelationlog >> $dblog;
   $GREPBIN AbstractJDBCOperation $dbcorrelationlog >> $dbstrucqslog;
   dblookup=`$GREPBIN "JDBCLookupOperation" $dblog | wc -l`;
   dblookupnull=`$GREPBIN "is null" $dblog | wc -l`;
   dbdml=`$GREPBIN JDBCUpdateOperation $dblog | wc -l`;
   dbstrucqs=`$GREPBIN AbstractJDBCOperation $dbstrucqslog | wc -l`;
   dbunstrucqs=$(( $dbcalls - $dbstrucqs ));
 else
   echo "$currentTS INFO: No queries detected, recheck if collector is set to debug mode." | tee $tempsummarylog;
   echo "$currentTS INFO: set collector log to debug using command -" | tee $tempsummarylog;
   echo "  \"$setdebug\"" | tee $tempsummarylog;
   exit 1;
 fi
}
# =================================================================================
function rcStats()
{
 # Rulechains
 $GREPBIN -n "AbstractContextProvider\|LocalRuleChainInvoker" $logfile >> $rcfilename;
 
 if [ -s $rcfilename ]; then   
   
  totalrcees=`$GREPBIN -n "AbstractContextProvider\|LocalRuleChainInvoker" $rcfilename | wc -l`;
  $GREPBIN "AbstractContextProvider" $rcfilename | awk '{print $9}' >> $rceesused;
  $GREPBIN "LocalRuleChainInvoker" $rcfilename | awk '{print $11}' >> $rceesused;
  cat $rceesused | sort | uniq -d >> $duprceeslog;
  reusedrcees=`cat $duprceeslog | wc -l`;
 else
   echo "$currentTS INFO: No rulechains detected, recheck if collector is set to debug mode.";
   echo "$currentTS INFO: set collector log to debug using command -" | tee $tempsummarylog;
   echo "  \"$setdebug\"" | tee $tempsummarylog;
   exit 1;
 fi
  #cat $duprcees;
}
# =================================================================================
function logStats()
{
  # Info logs
  $GREPBIN "(LogNMERule) INFORMATIVE:" $logfile >> $infolog;
  infocount=`$GREPBIN "(LogNMERule) INFORMATIVE:" $infolog | wc -l`;
}
# =================================================================================
function cleanup()
{
 tar -cvzf $tarfile $summarylog $dbcorrelationlog $dblog $dbstrucqslog $rcfilename $rceesused $duprceeslog $infolog > /dev/null;
 rm -rf $summarylog $dbcorrelationlog $dblog $dbstrucqslog $rcfilename $rceesused $duprceeslog $infolog;
}
# =================================================================================
function Main()
{
  # if [[ -z $* ]]; then
	  # Usage;
	  # exit 1;
  # else
  # while getopts :l:t:h: opt; do
	# case ${opt} in
 #	l)
		if [ "x$logfile" = "x" ]; then
		 logfile="${defaultlogfile}";
		 printf "\n INFO: Specific scenario log file not found, using default log - $defaultlogfile";
		fi

	if [ "x$testname" = "x" ]; then
	 testname="test";
	fi
 #  done
	echo ""> tempsummarylog;
	if [ -s $logfile ]; then

	  printf "\n This might take a while, please wait..."
	  makeLogs; 
	  dbStats; 
	  rcStats;
	  logStats;  
	  summary;
		
	  cat $tempsummarylog;
	  cat $tempsummarylog >> $summarylog;
	  cleanup;
	  exit 0;
	else
	  display;
	  printf "\n ERROR: Empty collector log detected, recheck log file.";
	  exit 1;
	fi
#  fi
}
Main;
