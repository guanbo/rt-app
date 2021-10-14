#!/bin/bash

# Copyright 2021 AutoCore
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

if [ $USER != 'root' ]
then
  echo "Root user only!"
  exit 1
fi

# CPUSET
CPUSET_DIR="/sys/fs/cgroup/cpuset/example"
if [ ! -d  "$CPUSET_DIR" ] 
then
  mkdir $CPUSET_DIR
fi
echo 3 > $CPUSET_DIR/cpuset.cpus  
echo 0 > $CPUSET_DIR/cpuset.mems
echo 1 > $CPUSET_DIR/cpuset.cpu_exclusive
echo 1 > $CPUSET_DIR/cpuset.mem_exclusive
setcap cap_sys_nice+ep /usr/local/bin/rt-app

echo $$ > $CPUSET_DIR/tasks
echo "========="
cat $CPUSET_DIR/tasks
echo "========="
setcap cap_sys_nice+ep /usr/local/bin/rt-app
sudo /usr/local/bin/rt-app -l 50 test.json
