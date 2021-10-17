Event Check Utility
=======================
This utility can be used for -
1. Individual event analyses of IUM collectors
2. Event code review
3. Performance tuning inputs
4. Developer Training
5. A few event based statistics for Database calls, Rulechains/functions and support logs

Pre-requisites –
================
1. Take backup of SPC_RCS_ACS_SS.log file [optional]
2. Clear log file [echo “” > SPC_RCS_ACS_SS.log]
3. Set log file to debug mode. Use command example:- cd /opt/SIU_90FP2VZW/bin/ ./siucontrol -n SPC_RCS_ACS_SS -c setloglevel 8
4. Disable or ensure any IUM schedulers with DB or rulechain executions are not in progress
5. Run event/scenario and save log

Steps to run utility
====================
1. Place util in a convenient location in a unix VM
2. Run command: chmod +x event-check.sh
3. Run command: dos2unix event-check.sh
4. Run util as seen below -
	./event-check.sh <acs log-file> <test/eventName>
			<acs log-file> - optional
			<test/eventName> - optional

# =================================================================================
# Input: Event-log-file and testname
# Usage: ./event-check.sh <logFile> <EventName>
# output: stats on STD with logfiles compressed and archived in current directory
# =================================================================================

Further Reading
================
Enhancements like automation of multiple events execution, analysis and more statistics/KPIs can be derived and included in future releases.

