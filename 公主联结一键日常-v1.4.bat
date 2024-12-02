@echo off
setlocal enabledelayedexpansion
chcp 65001
echo 脚本名称[公主联结一键日常]
echo 作者[KillerBill]
echo =================================================================
::adb kill-server
adb devices -l | findstr "device product:" >nul
if errorlevel 1 (
    echo No connected devices 连接失败，请检查连接状态
    choice /t 1 /d y /n >nul
    echo=
    echo 按任意键退出
    pause>nul
    exit
) else (
    echo=
    echo Adb found 连接成功！
)

for /f "tokens=*" %%z in (
    'adb shell dumpsys window displays ^| findstr init^='
) do (set inistring=%%z)
:split
for /f "tokens=1,*" %%i in ("%inistring%") do (
    set midstring=%%i
    set inistring=%%j
)
for /f "tokens=1,2 delims=^=" %%a in ("%midstring%") do (
    set %%a=%%b
)
if not "%inistring%"=="" goto split
for /f "tokens=1,2 delims=x" %%o in ("%cur%") do (
    set resx=%%o
    set resy=%%p
)
rem 读取数据，如果有的话
if exist pcronetap.ini (
    for /f "tokens=1,2 delims=^= eol=:" %%i in (pcronetap.ini) do (set %%i=%%j)
)
set timi=2
goto jumpinto
:reSet
rem 接受分辨率输入
set timi=12
::choice /t 1 /d y /n >nul
echo 请输入手机分辨率，以纯数字分别输入长宽
echo=
choice /t 1 /d y /n >nul

::不知为什么必须要有空行

set /p resxin="请输入手机长："

set /p resyin="请输入手机宽："

if not "%resxin%"=="" set resx=%resxin%
if not "%resyin%"=="" set resy=%resyin%

rem 本来是要保存分辨率数据，但是自动获取后就不需要了
::( echo ::此文件为[公主联结一键日常]脚本配置文件,目前只是用来存手动输入的分辨率 & echo resx=%resx% & echo resy=%resy%)> pcronetap.ini
:jumpinto
rem 较大的应当在前，这里进行自动交换
if %resx% lss %resy% (
    set resx=%resy% & set resy=%resx%
    echo=
    echo 数据处理…
)
echo=
choice /t %timi% /d y /m "手机分辨率为 %resx%x%resy% 按 Y 确认，按 N 手动输入"
if %errorlevel%==2 (
    cls
    echo=
    echo 脚本名称[公主联结一键日常]
    echo 作者[KillerBill]
    echo =================================================================
    echo=
    goto reSet
)
rem 计算判断长宽比例
set /a sdx=%resx%*9
set /a sdy=%resy%*16
if %sdx% gtr %sdy% (
    set /a sdx=%sdy%/9
    set sdy=%resy%
) else (
    set /a sdy=%sdx%/16
    set sdx=%resx%
)
set /a dtx=(%resx%-%sdx%)/2
set /a dty=(%resy%-%sdy%)/2

set /a bkgx=%resx%*87
set /a bkgy=%resy%*200
if %bkgx% gtr %bkgy% (
    set /a bkgx=%bkgy%/87
    set bkgy=%resy%
) else (
    set bkgx=%resx%
    set bkgy=%resy%
)
set /a bkgdtx=(%resx%-%bkgx%)/2

if %timi% gtr 2 (
    echo=
    echo 准备完成，按任意键开始挂机
    pause>nul
    echo=
    echo （分辨率为手动输入时才会暂停等待确认）
    choice /t 1 /d y /n >nul
    timeout /t 3
) else (
    echo=
    echo 准备完成，开始挂机
)
timeout /t 3
echo=
set /p =正在进行：<nul
echo 免费十连扭蛋

set /a x=%sdx%*25/32+%dtx%
set /a y=%sdy%*17/18+%dty%*2
set wtapt=3
call :tap
set /a x=%sdx%*9/10+%dtx%*2
set /a y=%sdy%/8+%dty%
set wtapt=1
call :tap
set /a x=%sdx%*3/4+%dtx%*2
set /a y=%sdy%*35/54+%dty%
set wtapt=1
call :tap
set /a x=%sdx%*11/18+%dtx%
set /a y=%sdy%*11/16+%dty%
set wtapt=5
call :tap
set wbackt=0
call :back
set /p =完成！      <nul
echo=
choice /t 3 /d y /n >nul
echo=
set /p =正在进行：<nul
echo 探索

set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*17/18+%dty%*2
set wtapt=3
call :tap
set /a x=%sdx%*23/30+%dtx%*2
set /a y=%sdy%/4+%dty%
set wtapt=1
call :tap
set /a x=%sdx%*11/18+%dtx%
set /a y=%sdy%*7/16+%dty%
set wtapt=1
call :tap
set /a x=%sdx%*13/18+%dtx%
set /a y=%sdy%*5/18+%dty%
set wtapt=1
call :tap
set /a x=%sdx%*25/32+%dtx%
set /a y=%sdy%*11/18+%dty%
set wtapt=1
call :tap
set /a x=%sdx%*11/18+%dtx%
set /a y=%sdy%*11/16+%dty%
set wtapt=5
call :tap
set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*8/9+%dty%
set wtapt=1
call :tap
set /a x=%sdx%*13/18+%dtx%
set /a y=%sdy%*5/18+%dty%
set wtapt=1
call :tap
set /a x=%sdx%*25/32+%dtx%
set /a y=%sdy%*11/18+%dty%
set wtapt=1
call :tap
set /a x=%sdx%*11/18+%dtx%
set /a y=%sdy%*11/16+%dty%
set wtapt=5
call :tap
set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*8/9+%dty%
set wtapt=1
call :tap
set wbackt=1
call :back
set /p =完成！      <nul


echo=
echo=
set /p =正在进行：<nul
echo 地下城

set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*17/18+%dty%*2
set wtapt=3
call :tap
set /a x=%sdx%*11/12+%dtx%*2
set /a y=%sdy%/4+%dty%
set wtapt=2
call :tap
set /a x=%sdx%*7/8+%dtx%
set /a y=%sdy%/2+%dty%
set wtapt=1
call :tap
set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*43/54+%dty%
set wtapt=10
call :tap
set wbackt=1
call :back
set /p =完成！      <nul


echo=
choice /t 3 /d y /n >nul
echo=
set /p =正在进行：<nul
echo 双场

set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*17/18+%dty%*2
set wtapt=3
call :tap
set /a x=%sdx%*11/18+%dtx%*2
set /a y=%sdy%*41/54+%dty%
set wtapt=2
call :tap
set /a x=%sdx%*7/18+%dtx%
set /a y=%sdy%*11/16+%dty%
set wtapt=2
call :tap
set /a x=%sdx%*11/36+%dtx%
set /a y=%sdy%*17/27+%dty%
set wtapt=1
call :tap
set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*11/16+%dty%
set wtapt=1
call :tap

for /l %%i in (1,1,6) do (
set /a x=%sdx%*4/5+%dtx%
set /a y=%sdy%*17/54+%dty%
set wtapt=1
call :tap
set /a x=%sdx%*7/8+%dtx%
set /a y=%sdy%*38/45+%dty%
set wtapt=0
call :tap
set wtimef=1310
call :waitf
set /a x=%sdx%*17/20+%dtx%
set /a y=%sdy%*49/54+%dty%*2
set wbackt=2
call :back
set wtapt=3
call :tap

set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*17/18+%dty%*2
set wtapt=3
call :tap
set /a x=%sdx%*11/18+%dtx%*2
set /a y=%sdy%*41/54+%dty%
set wtapt=2
call :tap

)
set wbackt=2
call :back
set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*17/18+%dty%*2
set wtapt=2
call :tap
set /a x=%sdx%*31/36+%dtx%*2
set /a y=%sdy%*41/54+%dty%
set wtapt=2
call :tap
set /a x=%sdx%*7/18+%dtx%
set /a y=%sdy%*23/27+%dty%
set wtapt=2
call :tap
set /a x=%sdx%*11/36+%dtx%
set /a y=%sdy%*17/27+%dty%
set wtapt=1
call :tap
set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*11/16+%dty%
set wtapt=1
call :tap
for /l %%i in (1,1,6) do (
set /a x=%sdx%*4/5+%dtx%
set /a y=%sdy%*17/54+%dty%
set wtapt=1
call :tap
for /l %%i in (1,1,3) do (
set /a x=%sdx%*7/8+%dtx%
set /a y=%sdy%*38/45+%dty%
set wtapt=1
call :tap
)

set wtimef=1310

call :waitf
set wbackt=2
call :back
set /a x=%sdx%*17/20+%dtx%
set /a y=%sdy%*49/54+%dty%
set wtapt=3
call :tap

set /a x=%sdx%/2+%dtx%
set /a y=%sdy%*17/18+%dty%*2
set wtapt=2
call :tap
set /a x=%sdx%*31/36+%dtx%*2
set /a y=%sdy%*41/54+%dty%
set wtapt=2
call :tap

)

set wbackt=0
call :back
set /p =完成！      <nul
choice /t 3 /d y /n >nul

echo=
echo=
echo 挂机完成，即将退出
choice /t 5 /d y /n >nul

goto end
::返回
:back
set /p =返回          <nul
adb shell input keyevent 4
choice /t %wbackt% /d y /n >nul
set /p =<nul
exit /b
::等待
:waitf
set /p =等待中，剩余时间：<nul
for /l %%i in (%wtimef%,-1,1000) do (
    set t=%%i
    set /p =!t:~-3!秒<nul
    choice /t 1 /d y /n >nul
    set /p =<nul
)
set /p =<nul
set /p =                            <nul
set /p =<nul
exit /b
::点击
:tap
set /a x=%x%+10000
set /a y=%y%+10000
set /p =点击 %x:~-4%,%y:~-4%<nul
set /a x=%x%-10000
set /a y=%y%-10000
adb shell input tap %x% %y%
choice /t %wtapt% /d y /n >nul
set /p =<nul
exit /b
:end