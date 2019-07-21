#!/bin/bash

############ Configuration ############
$path=./tools/mac
$fastboot=./tools/mac/fastboot
$adb./tools/mac/fastboot
$magisk=./files/core/magisk.zip
$twrp_img=./files/core/twrp.img
$twrp_zip=./files/core/twrp.zip
$driver=./files/mac
#######################################

Welcome() {
    clear
    echo "======================================"
    echo "=     OnePlus 7 Pro 工具箱 for Mac    ="
    echo "=             by Kevin               ="
    echo "======================================"
}

Info() {
    Welcome
    echo "$(cat ./.mac-version)"
    read -p "按下任何按键以返回目录..."
    Menu
}

Menu() {
    Welcome
    echo "[1] 解锁/上锁手机"
    echo "[2] 刷入TWRP"
    echo "[3] Root设备"
    echo "[4] 刷入第三方ROM"
    echo "[5] 安装驱动"
    echo "[i] 脚本信息          [c] 自定义功能"
    echo "[l] 免责条款          [x] 退出脚本"
    read -p "请输入您需要的功能> " id
    case $id in
        "1")
            Unlock
            ;;
        "2")
            TWRP
            ;;
        "3")
            Root
            ;;
        "4")
            ROM
            ;;
        "5")
            Install-Driver
            ;;
        "i" | "I")
            Info
            ;;
        "c" | "C")
            Custom
            ;;
        "l" | "L")
            License
            ;;
        "x" | "X")
            Exit
            ;;
        *)
            echo "错误的参数！请重新输入参数！"
            sleep 5
            Menu
            ;;
    esac
        


}

Custom() {
    Welcome

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

Install-Driver() {
    sudo cp $driver/* /Applications/
}

TWRP() {
    $mode=Check-Status
    if [[ $mode == "fb" ]]
    then
        Flash-TWRP
    elif [[ $mode == "recovery"] -o [ $mode == "system" ]]
    then
        $adb reboot bootloader
        Flash-TWRP
    else
        Error
    fi
}

Error() {
    echo "! 出现错误: 设备未在指定时间内响应！请手动排查设备状态以及线缆质量！"
    read -p "输入回车以返回菜单..."
    Menu

}

Flash-TWRP() {
    $currentslot=$($fastboot getvar current-slot | grep "current-slot: a")
    if [[ $currentslot == "current-slot: a" ]]
    then
        $activeslot="b"
    else
        $activeslot="a"
    fi
    $fastboot --set-active=$activeslot
    $fastboot flash boot $twrp_img
    $fastboot reboot recovery
    # Wait user 
    (echo "twrp sideload") | $adb shell
    $adb sideload $twrp_zip
}

Root() {
    $mode=Check-Status
    if [[ $mode == "recovery" ]]
    then
        Flash-Magisk
    elif [[ $mode == "system" ]]
    then
        $adb reboot recovery
        Flash-Magisk
    elif [[ $mode == "fb" ]]
    then
        $fastboot reboot recovery
    else
        Error
    fi
}

Flash-Magisk() {
    (echo "twrp sideload") | $adb shell
    $adb sideload $magisk
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
        echo "+ 正在检测模式...."
        # MODE CHECK
        if [[ $mode == "fb" ]]
        then
            FB-Unlock
        else
            if [[ $mode == "system" ]]
            then
            echo "+ 正在重启至Bootloader..."
            $adb reboot bootloader
            echo "? 等待设备进入指定状态"
            sleep 30
            # MODE CHECKE
            if [[ $mode == "fb" ]]
            then
                FB-Unlock
            else
                Error
            fi
        fi
    else
        if [[ $id == "N" ] -o [ $id == "n"]]
        then
            echo "! 已取消相关操作"
            read -p "输入回车以返回菜单..."
            Menu
        else
            echo "! 错误的参数！"
            sleep 5
            Unlock
        fi
    fi
}

FB-Unlock() {
    echo "+ 解锁中..."
    $fastboot oem unlock
    echo "* 请在出现的界面选择Unlock，并等待开机"
}

Check-Status() {
    temp=$($adb devices)
    if [[ $($temp |grep unauthorized) == "unauthorized" ]]
    then
        return unauthor
    elif [[ $($temp |grep recovery) == "recovery" ]]
    then
        return recovery
    elif [[ $($temp | grep sideload) == "sideload" ]]
    then
        return sideload
    elif [[ $($temp | gerp) == ]]
    then
        return system
    elif [[ $($fastboot devices | grep fastboot) == "fastboot" ]]
    then
        return fastboot
    fi
}

Initialize() {
    Welcome
    echo "+ 正在初始化..."
    $adb kill-server
    $adb start-server
    echo "+ 初始化完毕"
    sleep 1
    Menu
}

Initialize