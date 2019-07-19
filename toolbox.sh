#!/bin/bash

############ Configuration ############
$path=./tools
$fastboot=./tools/fastboot
$adb./tools/fastboot
$magisk=./files/magisk.zip
$twrp_img=./files/twrp.img
$twrp_zip=./files/twrp.zip
#######################################

Welcome() {
    clear
    echo "================================="
    echo "=     OnePlus 7 Pro Toolbox     ="
    echo "=          by Kevin             ="
    echo "================================="
}

Info() {
    Welcome
    #$version="cat ./version"
    echo "$(cat ./version)"
    read -p "按下任何按键以返回目录..."
    Menu
}

Menu() {
    Welcome
    echo "[1] 解锁/上锁手机"
    echo "[2] 刷入TWRP"
    echo "[3] Root设备"
    echo "[4] 刷入第三方ROM"
    echo "[i] 脚本信息          [c] 自定义功能"
    echo "[l] 免责条款          [x] 退出脚本"
    read -p "请输入您需要的功能> " id
    if [[ $id == "i" ]]
    then
        Info
    fi
}

Unlock() {
    Welcome
    echo "[1] 解锁手机"
    echo "[2] 上锁手机"
    echo "[b] 返回上一页          [x] 退出脚本"
    read -p "请输入您需要的功能> " id
    if [[ $id == "1" ]]
    then

}

Unlock() {
    Welcome
    echo "注意事项: 解锁手机将会清空手机内所有数据，请谨慎操作！"
    read -p "是否继续？[Y/N]" id
    if [[ $id == "Y"] -o [ $id =="y" ]]
    then
        Welcome
        echo "解锁之前请您进行如下操作: "
        echo "1. 进入系统 -> 设置 -> 关于设备 -> 敲击5次版本号 以进入开发者模式"
        echo "2. 开发人员选项 勾选 OEM解锁 以及 USB调试"
        echo "3. 使用线缆将您的OnePlus设备与您的电脑连接"
        echo "==============================================="
        read -p "请在您完成操作后按下Enter键，如需取消操作请关闭终端"
        Welcome
        echo "正在检测模式...."
        # MODE CHECK
        if [[ $mode == "fb" ]]
        then
            FB-Unlock
        else
            if [[ $mode == "system" ]]
            then
            echo "正在重启至Bootloader..."
            $adb reboot bootloader
            echo "等待设备进入指定状态"
            sleep 30
            # MODE CHECKE
            if [[ $mode == "fb" ]]
            then
                FB-Unlock
            else
                echo "出现错误: 设备未在指定时间内响应！请手动排查设备状态以及线缆质量！"
                read -p "输入回车以返回菜单..."
                Menu
            fi
        fi
    else
        if [[ $id == "N" ] -o [ $id == "n"]]
        then
            echo "已取消相关操作"
            read -p "输入回车以返回菜单..."
            Menu
        else
            echo "错误的参数！"
            sleep 5
            Unlock
        fi
    fi
}

FB-Unlock() {
    echo "解锁中..."
    $fastboot oem unlock
    echo "请在出现的界面选择Unlock，并等待开机"
}

Menu