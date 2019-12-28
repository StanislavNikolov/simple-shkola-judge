#!/bin/bash

#safeBin="LD_PRELOAD=./EasySandbox.so $1"
task="$1"
safeBin="$2"

wrongTests=0
allTests=0

tmpfile=`mktemp`
sstmp=`mktemp`  # system status tmp file
excode=`mktemp` # system status tmp file

function shortName {
	echo "$1" | awk -F '.' '{print $1}'
}

function fail_timeout {
	t=`shortName $1`
	echo -n "$t: <font color=\"fireBrick\">Time limit</font><br>"
	wrongTests=$((wrongTests+1))
}

function fail_nonZeroExitCode {
	t=`shortName $1`
	echo -n "$t: <font color=\"brown\">Crashed</font><br>"
	wrongTests=$((wrongTests+1))
}

function fail_wrong {
	t=`shortName $1`
	echo -n "$t: <font color=\"darkRed\">Wrong answer</font><br>"
	wrongTests=$((wrongTests+1))
}

function prn_ok {
	t=`shortName $1`
	echo -n "$t: <font color=\"green\">OK</font> ~$(<$sstmp)s.<br>"
}

for test in problems/$task/tests/*.in
do
	str="$test"
	if [[ ! $str =~ "00.in" ]]; then
		allTests=$((allTests+1))
		out=`basename -s .in $test`.sol
		if timeout 0.2 bash -c "TIMEFORMAT=%3R; time ($safeBin < $test &> $tmpfile; echo \$? > $excode) &> $sstmp"; then
			#sed -i 1,2d $tmpfile # EasySandbox garbage, rtfm
			ec=$(<$excode)
			if [[ "$ec" == "0" ]]
			then
				(diff -qbZB problems/$task/tests/$out $tmpfile > /dev/null && prn_ok $out) || fail_wrong $out
			else
				fail_nonZeroExitCode $out
			fi
		else
			fail_timeout $out
		fi
	fi
done;

correctTests=$((allTests-wrongTests))

output=`python -c "print(round($correctTests * 100 / $allTests))"`
printf "<b>%d/%d</b>\n" $correctTests $allTests

rm $tmpfile
rm $sstmp
