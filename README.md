# HealthEnhance
A script designed to remind yourself to take a break after a period of continuous work
## 前言
我经常在工位上一坐就是一个上午，一个下午，这对健康是非常不好的，特别是成年男性的前列腺健康和尿路健康深受此害，可能我真的太过专注了吧😁，我开始寻找一个“能够在我连续工作一段时间后提醒我休息一下的程序”，可惜的是，大部分的程序只是傻傻的定时提醒，不能检测我是否连续工作了一段时间，所以我试着去自己写一个出来，所以便有了它。

## 需求描述
当连续工作达到60分钟时（中断工作的时间不到5分钟认为是连续工作），提醒我“停下来休息一下吧”，弹窗显示五秒后自动隐藏；

## 实现效果
1. 鼠标或者键盘处于活动状态时就认为是在工作，鼠标和键盘全都处于非活动状态时认为在休息；
2. 连续工作达到60分钟时，系统弹窗提醒休息，弹窗显示五秒自动隐藏，然后自动进入下一个连续工作60分钟的计时；
3. 中断工作不足5分钟，不影响连续工作60分钟的计时，中断工作超过5分钟，连续工作60分钟的计时从零开始；
---
![image](https://user-images.githubusercontent.com/59545510/222153715-7288654d-c82f-410c-8d30-a99477145bbd.png)

## 特点
1. 极简，资源占用低————使用powershell脚本，无前端页面，调用系统API，执行效率高，代码行不过百；
2. 功能强大，实用灵活————检测是否连续工作一段时间，支持开机自启动，执行无窗口，可灵活修改连续工作的时间阈值；

## 使用步骤
1. BurntToast模块
脚本的通知功能依赖BurntToast模块，需要打开Windows系统自带的powershell或windows-terminal，输入并执行`Install-Module -Name BurntToast`；
2. 修改powershell脚本执行策略
Windows系统默认不允许任何脚本语言运行，需要以管理员身份运行powershell，输入并执行`set-ExecutionPolicy RemoteSigned`，作用是使Windows支持执行本地powershell脚本；
3. 下载项目包并修改相关路径 
* 下载项目到本地，修改“HealthEnhance.ps1”文件中的`New-BurntToastNotification -AppLogo "C:\Users\yudon\AppData\Local\Programs\HealthEnhance\HealthEnhance.png" -Text "提醒", '已连续工作1小时，休息一下吧！'# 弹出提醒“休息一下吧”，持续5秒后消失`中的“C:\Users\yudon\AppData\Local\Programs\HealthEnhance\HealthEnhance.png”替换成你自己存放的文件路径（提醒文字和图标都可以灵活修改）；
```
{
  New-BurntToastNotification -AppLogo "C:\Users\yudon\AppData\Local\Programs\HealthEnhance\HealthEnhance.png" -Text "提醒", '已连续工作1小时，休息一下吧！'# 弹出提醒“休息一下吧”，持续5秒后消失
}
```
* 修改“HideRunHE.vbs”文件中的`objShell.Run "powershell.exe C:\Users\yudon\AppData\Local\Programs\HealthEnhance\HealthEnhance.ps1",0`中的“C:\Users\yudon\AppData\Local\Programs\HealthEnhance\HealthEnhance.ps1”替换成你自己存放的文件路径；
4. 创建快捷方式
为“HideRunHE.vbs”文件右键创建快捷方式，然后将快捷方式移动到“C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\”目录下；
5. 重启系统
执行完前面4步后，每次重启系统，脚本都会自动重启；

## 灵活修改
目前是连续工作60分钟进行提醒，中断工作5分钟影响连续工作时间的计时，可以按照自己的想法修改`$IdleLimit = 300 # 空闲时间限制（秒）
$WorkLimit = 3600 # 工作时间限制（秒）`；
```
{
  $IdleLimit = 300 # 空闲时间限制（秒）
  $WorkLimit = 3600 # 工作时间限制（秒）
}
```
