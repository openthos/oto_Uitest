#!/bin/bash -x

localpwd=`pwd`
date=`date +%Y%m%d%H%M`
touch $date".result"
##for testcase in `ls -d */|sed 's|[/]||g'`
testlist="com.futuremark.dmandroid.application"
for testcase in $testlist
do
    cd $localpwd
    cd $testcase
    [ -f bin/$testcase".jar" ] && rm bin/$testcase".jar"
    android create uitest-project -n $testcase -t 1 -p .
    ant build
    adb push bin/$testcase".jar" /data/local/tmp
    adb install *.apk
    ./auto_interact.sh `cat packagename` 2>&1 | tee tmpresult
    r=`cat tmpresult | grep -e "OK"`
    if [$r == ""]; then
      echo $testcase:0 >> ../$date".result"
    else
      echo $testcase:1 >> ../$date".result"
    fi
    rm tmpresult
    rm -rf bin
    rm build.xml local.properties  project.properties
done
