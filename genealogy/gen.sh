#!/bin/bash

parent() {
	local id=$1
	#get page
	wget -q http://genealogy.math.ndsu.nodak.edu/id.php?id=$id

	#get name
	local temp=`cat id.php\?id\=$id  | grep '<title' | sed 's$<title>The Mathematics Genealogy Project - \(.*\)<\(.\)*$\1$g'`
	father=$temp
	if [[ "$son" == "" ]]; then
		son=$father
	else
		echo "\"$father\" -> \"$son\";"
		son=$father
	fi
	# test if there is an advisor
	if [[ `cat id.php\?id\=$id | grep Advisor` == *Unknown*  ]]; then 
		rm id.php\?id\=$id
	else 
		#find advisor id
		local adv_id=`cat id.php\?id\=$id | grep Advisor | sed 's/\(.\)*id=\([0-9]*\)\(.\)*/\2/' `
		local adv2_id=`cat id.php\?id\=$id | grep Advisor | sed "s/\(.\)*id=\([0-9]*\)\(.\)*id.php\(.\)*/\2/" `
		rm id.php\?id\=$id
		parent $adv_id
		if [[ ${#adv2_id} -lt 10 && "$adv2_id" != "" ]]; then 
			son=$temp
			parent $adv2_id
		fi
	fi
}


echo "strict digraph genealogy {"
for id in $*; do
		son=""
	parent $id
done
echo "}"