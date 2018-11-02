#!/usr/bin/env bash

set -xe

echo "Starting Katalon Studio"

current_dir=$(pwd)

# create tmp directory
tmp_dir=$KATALON_KATALON_ROOT_DIR/tmp
mkdir -p $tmp_dir
chmod -R 777 $tmp_dir

# project source code
project_dir=$KATALON_KATALON_ROOT_DIR/project
mkdir -p $project_dir

if [ -d "$KATALON_KATALON_ROOT_DIR/source" ]; then
  cp -r $KATALON_KATALON_ROOT_DIR/source/. $project_dir
else
  cp -r . $project_dir
fi

# create .classpath if not exist
touch $project_dir/.classpath || exit
chmod -R 777 $project_dir

# report
if [ -d "$KATALON_KATALON_ROOT_DIR/report" ]; then
  report_dir=$KATALON_KATALON_ROOT_DIR/report
  mkdir -p $report_dir
fi

# build command line
project_file=$(find $project_dir -maxdepth 5 -type f -name "*.prj" -print -quit)

if [ -z "$report_dir" ]; then
  cmd="$KATALON_KATALON_INSTALL_DIR/katalon -runMode=console -reportFolder=$report_dir -projectPath=$project_file $KATALON_OPTS"
else
  cmd="$KATALON_KATALON_INSTALL_DIR/katalon -runMode=console -projectPath=$project_file $KATALON_OPTS"
fi

$KATALON_BASE_ROOT_DIR/scripts/xvfb.sh start
cd $tmp_dir
eval "$cmd"

chmod -R 777 $report_dir

cd $current_dir
