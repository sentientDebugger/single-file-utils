#!/usr/bin/env bash
set -euo pipefail

# EXAMPLE USAGE:
# path/to/git-text-in-diff.sh HEAD target-file.js searchTerm

if [[ $# -ne 3 ]]; then
	RED='\033[0;31m'
	NOCOLOR='\033[0m'
	echo -en "${RED}\
First parameter should be the branch name or \"HEAD\".
Second parameter should be the file to test.
Third parameter should be the string to test for.
${NOCOLOR}"
	exit 1
fi
# branchName is typically just "HEAD"
branchName=$1
fileName=$2
searchSubject=$3

for ref in $(git rev-list "$branchName" "$fileName")
do
	# if [[ $(git show -p $ref | grep $searchSubject) ]]; then
	if [[ $(git diff-tree -p $ref "$fileName" | grep -E -e '^(\+|\-)' | grep "$searchSubject") ]]; then
		# echo "diff for: $ref"
		# echo
		## git diff $ref^ $ref $fileName
		# git diff-tree -p $ref "$fileName"
		git log -n 1 $ref
	fi
done
