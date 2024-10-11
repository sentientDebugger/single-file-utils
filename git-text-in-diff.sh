#!/usr/bin/env bash
set -euo pipefail

function uln() {
	echo "$(tput smul)$*$(tput rmul)"
}

function printHelp() {
	echo "\
Usage: git-text-in-diff -f $(uln path/to/file.md) -s $(uln searchTerm) [-b $(uln branch-name)] [-l $(uln max-commit-count)]
Options:
  -b $(uln branchName): The branch name to search within. Default: \"HEAD\".
  -f $(uln fileName): The file that is to be searched.
  -s $(uln searchTerm): The substring to be searched for in each commit's diff.
  -l $(uln max-commit-count): The maximum number of matching commits to print out. Pass \"0\" to show all matches. Default: 0.
"
}

branchName=HEAD
maxCommitCount=0

while getopts ":b:f:s:l:" o; do
	case "$o" in
		b)
			branchName=$OPTARG
			;;
		f)
			fileName=$OPTARG
			;;
		s)
			searchSubject=$OPTARG
			;;
		l)
			maxCommitCount=$OPTARG
			;;
		*)
			printHelp
			exit 0
			;;
	esac
done
shift $((OPTIND-1))

if [[ -z ${fileName:-} || -z ${searchSubject:-} || -z ${branchName:-} || -z ${maxCommitCount:-} ]]; then
	printHelp 1>&2
	exit 1
fi
if [[ ! ( -r $fileName ) ]]; then
	echo "$(tput setaf 1)$(uln $fileName) does not exist or is not readable$(tput sgr0)" 1>&2
	exit 1
fi

(( printedCommitCount = 0 )) || true # https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-let and `set -e`

# cd $(dirname fileName)
for ref in $(git rev-list "$branchName" "$fileName")
do
	# The `|| [[ $? == 141 ]]` below is only needed because of `set -o pipefail` and `grep -q` causing SIGPIPE to the previous `grep`
	# 141 - 128 == 13 == SIGPIPE
	if git diff-tree -p $ref "$fileName" | grep -E -e '^(\+|\-)' | grep -Fq "$searchSubject" || [[ $? == 141 ]]; then

		git log -n 1 $ref

		(( maxCommitCount != 0 && ++printedCommitCount >= maxCommitCount )) && break
	fi
done
