#!/bin/bash

# 创建目标文件夹q于根目录
mkdir /q

# 进入/hive/miners/custom目录
cd /hive/miners/custom

# 复制和重命名文件夹
for i in {1..10}; do
    cp -r qubic-hive /q/qubic-$i
    # 进入每个新创建的文件夹
    cd /q/qubic-$i
    # 捕获原alias值并在其基础上加上-01到-16
    # 使用jq修改alias值，并在原始alias后添加-$i
    jq ".Settings.alias |= . + \"-$i\"" appsettings.json > temp.json && mv temp.json appsettings.json
    # 修改amountOfThreads的值
    jq '.Settings.amountOfThreads = 3' appsettings.json > temp.json && mv temp.json appsettings.json
    # 使用screen在后台启动每个qli-Client实例，并设置会话名为当前目录名
    screen -dmS qubic-$i bash -c "taskset -c $((i*3-3)),$((i*3-2)),$((i*3-1)) ./qli-Client"
    # 返回上一级目录，继续下一个循环
    cd - > /dev/null
done

echo "操作完成"