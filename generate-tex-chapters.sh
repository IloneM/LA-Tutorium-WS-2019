#!/bin/bash
if [[ $# -gt 2 ]]; then
	texfilename=${3%.tex}
else
	texfilename=${1%\/}
fi
if [[ $# -gt 1 ]]; then
	chapternametemplate=$2
else
	chapternametemplate=''
fi
if [[ $# -gt 0 ]]; then
	if [ -f $texfilename.tex ]; then
		rm $texfilename.tex
	fi
	foldername=${1%\/}
	for i in $(ls $foldername/*.tex); do
		if [ -z "$chapternametemplate" ]; then
			chaptername=${i%.tex}
			chaptername=${chaptername#$foldername/}
		else
			chaptername=${chapternametemplate#\ }\ ${i//[^0-9]/}
		fi
		printf "\\chapter{$chaptername}\n\n\\input{$i}\n\n" >> $texfilename.tex
	done
else
	(>&2 echo "You did not provide any parameter")
fi
