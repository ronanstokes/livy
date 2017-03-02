#!/bin/bash


SCRIPT_NAME=$0

logOutput() {
  if [[ $# -eq 1 ]] ; then 
    echo "$1"
  elif [[ $# -eq 2 ]] ; then
    echo "$(date) [$1] $2"
  fi
}

die() {
 if [[ $# -eq 0 ]] ||  [[ $1 != "silent" ]] ; then 
 logOutput 'INFO' ' exiting script'
 fi
  exit 1
  
}

usage() {
  echo " " 
  echo "Usage: $SCRIPT_NAME [dir-name]"
  echo "  creates distribution in directory name" 
  echo " " 
}


# process the arguments
if [[ $# -eq 0 ]] ; then 
  logOutput 'ERROR' ' no arguments passed'
  usage && die
fi

echo "mkDrop $1"
targetDir=$1

if [ -d "$targetDir" ]; then
   logOutput 'ERROR' "Directory $targetDir already exists - please provide non existing directory"
   die
fi

if [ ! -d "$targetDir" ]; then 
  logOutput 'INFO' "Building directories at $targetDir"
  mkdir $targetDir
  mkdir $targetDir/bin
  mkdir $targetDir/conf
  mkdir $targetDir/jars
  mkdir $targetDir/repl-jars
  mkdir $targetDir/rsc-jars
fi

logOutput 'INFO' "copies binaries to $targetDir/bin"
cp bin/livy-server $targetDir/bin

logOutput 'INFO' "copies configurations to $targetDir/conf"
cp conf/* $targetDir/conf

logOutput 'INFO' "copies server-jars to $targetDir/jars"
cp server/target/jars/* $targetDir/jars

logOutput 'INFO' "copies repl-jars to $targetDir/repl-jars"
cp repl/target/jars/* $targetDir/repl-jars

logOutput 'INFO' "copies rsc-jars to $targetDir/rsc-jars"
cp rsc/target/jars/* $targetDir/rsc-jars

tar czf $targetDir.tgz $targetDir
