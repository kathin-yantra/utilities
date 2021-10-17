******************************
Steps for rebranding codebase:
******************************
1. Backup and move rebrand.sh and pattern.sed to the parent directory where the rebranding needs to be done
2. Update the pattern.sed file with patterns as required if new patterns are added
3. Run rebrand.sh in 'sh' shell
4. Check for any errors in the STDOUT/STDERROR
5. Check for files in /tmp - filelist, files.properties and pattern.sed
6. git status to check file changes
7. Git commands: git -fd clean; git reset --hard if required
8. Ensure to checkin only required files -
	git status
	git add <new or renamed files> 
	git rm <olderfiles>
	git commit
	git push

***************************************************************************************************************
For testing/automation or miscellaneous files, please follow below steps if performing rebranding separately -
***************************************************************************************************************
1. Use branch 2.1_rcs_acs_90_verizon or 2.0_rcs_acs_90 to check out files [ReadME.txt, pattern.sed and rebrand..sh] under utilities/vz_rebrand/
2. Create a directory say - mkdir /home/rebrand
3. Copy the automation or to be rebranded artefact files, rebrand.sh and pattern.sed files to /home/rebrand
4. a. Change directory - cd /home/rebrand
4. b. If the git checkout directory is not used, open the rebrand.sh file and comment the below lines -
 # if [ -d "processes" ]; then
	
 # fi
5. Run rebrand.sh in 'sh' shell
6. Check for any errors in the STDOUT/STDERROR
7. Check for files in /tmp - filelist, files.properties and pattern.sed and their content as required
8. Verify the artefacts subject to rebranding if any residual patterns remain or if the required rebranding is done successfully
9. In case of any new patterns or file types, discuss and add to the pattern.sed file


******
NOTE: For a new filebase, a base pattern list must be made identified manually to ensure the patterns are unique and have minimal impact on the changes
******
