#!/bin/bash
#
###############################################################################################################################################
#
# ABOUT THIS PROGRAM
#
#	RD-Web-Feed.sh
#	https://github.com/Headbolt/RD-Web-Feed
#
#   This Script is designed for use in JAMF and was designed to connect to a Microsoft RDWEB Feed
#
#	The Following Variables should be defined
#	Variable 4 - Named "Download URL for Client Connector - eg. https://api-cloudstation-us-east-2.prod.hydra.sophos.com/api/download/SophosInstall.zip"
#	Variable 5 - Named "Install Command - eg. /Contents/MacOS/Sophos Installer - OPTIONAL"
#	Variable 6 - Named "Installer Switches - eg. --quiet - OPTIONAL"
#
###############################################################################################################################################
#
# HISTORY
#
#   Version: 1.1 - 06/12/2022
#
#	05/10/2018 - V1.0 - Created by Headbolt
#
#	06/12/2022 - V1.1 - Updated by Headbolt
#							Better reporting and notation
#
###############################################################################################################################################
#
#   DEFINE VARIABLES & READ IN PARAMETERS
#
###############################################################################################################################################
#
LoggedInUser=$3 # Grab the logged in Username from builtin JAMF variable #3
URL=$4 # Grab the Feed URL from JAMF variable #4 eg. https://server.domain.com/RDWeb/Feed/webfeed.aspx
Authentication=$5 # Grab the Authentication Method from JAMF variable #5 eg. NONE
Username=$6 # Grab the "Specific" Username ( If Needed ) from JAMF variable #6 eg. username
Password=$7 # Grab the "Specific" Password ( If Needed ) from JAMF variable #7 eg. password
#
ScriptName="Global | RD WEB Feed"
ExitCode=0 # Set Exitcode to a default of 0
#
###############################################################################################################################################
#
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###############################################################################################################################################
#
# Defining Functions
#
###############################################################################################################################################
#
# Mode Check End Function
#
ModeCheck(){
# Check which "Mode" is being used, and set actions accordingly
if [ -n "${Authentication}" ]
	then
    	#
		if [ ${Authentication} == "SPECIFIC" ]
			then
		    	/bin/echo "Setting up Feed as Specific User"
				/bin/echo # Outputting a Blank Line for Reporting Purposes
				#
				if [ -n "${Username}" ]
					then
						/bin/echo "Username set to $Username"
						/bin/echo # Outputting a Blank Line for Reporting Purposes
					else
						/bin/echo # Outputting a Blank Line for Reporting Purposes
						/bin/echo "Username is blank but required for this action. Cannot continue"
                        ExitCode=1
						ScriptEnd
				fi
				#
				if [ -n "${Password}" ]
					then
						/bin/echo "Password set to $Password"
						/bin/echo # Outputting a Blank Line for Reporting Purposes
					else
						/bin/echo # Outputting a Blank Line for Reporting Purposes
						/bin/echo "Password is blank but required for this action. Cannot continue"
                        ExitCode=2
						ScriptEnd
				fi
				Options=(--username '"'$Username'"' --password '"'$Password'"')
		fi
		#
		if [ ${Authentication} == "USER" ]
			then
				/bin/echo "Setting up Feed as Logged in User"
				/bin/echo # Outputting a Blank Line for Reporting Purposes
		    	Username=$3
				/bin/echo "Username set to $Username"
				/bin/echo # Outputting a Blank Line for Reporting Purposes
				Options=(--username '"'$Username'"')
		fi
		#
		if [ ${Authentication} == "NONE" ]
			then
				/bin/echo "Setting up Feed with No Credentials"
				/bin/echo # Outputting a Blank Line for Reporting Purposes
				Options=""
		fi
	else
		/bin/echo "Authentication variable either not set, or set incorrectly."
		/bin/echo "Setting up Feed with No Credentials" 
		/bin/echo # Outputting a Blank Line for Reporting Purposes
		Options=""
fi
#
}
#
###############################################################################################################################################
#
# Section End Function
#
SectionEnd(){
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
}
#
###############################################################################################################################################
#
# Script End Function
#
ScriptEnd(){
#
/bin/echo Ending Script '"'$ScriptName'"'
/bin/echo # Outputting a Blank Line for Reporting Purposes
/bin/echo  ----------------------------------------------- # Outputting a Dotted Line for Reporting Purposes
/bin/echo # Outputting a Blank Line for Reporting Purposes
#
exit $ExitCode
#
}
#
###############################################################################################################################################
#
# End Of Function Definition
#
###############################################################################################################################################
# 
# Begin Processing
#
###############################################################################################################################################
#
/bin/echo # Outputting a Blank Line for Reporting Purposes
SectionEnd
ModeCheck
#
/bin/echo "Running Command"
/bin/echo sudo -u $LoggedInUser "/Applications/Microsoft Remote Desktop.app/Contents/MacOS/Microsoft Remote Desktop" --script feed write "${URL[@]}" "${Options[@]}"
/bin/echo # Outputting a Blank Line for Reporting Purposes
sudo -u $LoggedInUser "/Applications/Microsoft Remote Desktop.app/Contents/MacOS/Microsoft Remote Desktop" --script feed write "${URL[@]}" "${Options[@]}"
#
SectionEnd
ScriptEnd
