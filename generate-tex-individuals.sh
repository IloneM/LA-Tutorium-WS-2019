#!/bin/bash
if [[ $# -gt 3 ]]; then
	textemplate=$4
else
	textemplate=individual-${1%\/*}-template.tex
fi
if [[ $# -gt 2 ]]; then
	titletemplate=$3
else
	titletemplate=${1#*\/}
	titletemplate=${titletemplate%.tex}
	titletemplate=${titletemplate//[\s0-9]/}
fi
if [[ $# -gt 1 ]]; then
	outfile=${2#*\/}
	if [ -z $outfile ]; then
		outfile=${1}
		outfile=${1#*\/}
	fi
	outfolder=${2%\/*.tex}
else
	outfile=${1#*\/}
	outfolder=${1%\/*}-out
fi
if [[ $# -gt 0 ]]; then
	if [ ! -d $outfolder ]; then
		mkdir $outfolder
	fi
	sed s+TITLE+"$titletemplate\ ${1//[^0-9]/}"+ $textemplate | sed s+CONTENT+..\/$1+ > $outfolder/$outfile
else
	(>&2 echo "You did not provide any parameter")
fi
