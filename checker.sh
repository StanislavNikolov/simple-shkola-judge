#/bin/env bash

if (( $# != 3 )); then
	echo "Usage: (---) test_dir binary time_limit"
	exit 0
fi

dir=$1
bin=$2
maxtime=$3
tmpfile=`mktemp`

maxPoints=0
fails=0

function print {
	if [[ "$STATUS" == "min" ]]
	then
		echo -n $1
	else
		output="Unknown"
		case "$1" in
			'T') output="Timeout";;
			'M') output="Memory Limit";;
			'x') output="Wrong Answer";;
			'.') output="OK";;
		esac
		echo $output
	fi
}

function fail_timeout {
	print 'T'
	fails=$((fails+1))
}

function fail_wrong {
	print 'x'
	fails=$((fails+1))
}

function tp {
	LIBC_FATAL_STDERR_=1 timeout $maxtime $bin < $test > $tmpfile
}

for test in $dir/*.in
do
	maxPoints=$((maxPoints+1))
	if tp &> /dev/null
	then
		out=`basename -s .in $test`.sol
		(diff -qb $dir/$out $tmpfile > /dev/null && print '.') || fail_wrong
	else
		fail_timeout
	fi
done

succsessful=$((maxPoints-$fails))

if [[ "$STATUS" == "min" ]]; then
	echo -n " "
fi
printf "Result: %d - %d/%d \n" `python3 -c "print(round(100 / $maxPoints * $succsessful))"` $succsessful $maxPoints

rm $tmpfile
