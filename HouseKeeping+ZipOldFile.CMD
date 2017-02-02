::---------------------------------------------------------------------------------
::   HouseKeeping+ZipOldFile.CMD v1.1 | WadeEaton1@gmail.com
::---------------------------------------------------------------------------------
::@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
set batchname=HouseKeeping+ZipOldFile
 
::--------------------------------------
:: 時間變數
::--------------------------------------
del %tmp%\%batchname%.vbs
@echo wscript.echo dateadd("d",-1,date) >%tmp%\%batchname%.vbs
for /f "tokens=1,2,3 delims=/- " %%i in ('cscript /nologo %tmp%\%batchname%.vbs') do set y=%%i
for /f "tokens=1,2,3 delims=/- " %%i in ('cscript /nologo %tmp%\%batchname%.vbs') do set m=%%j
for /f "tokens=1,2,3 delims=/- " %%i in ('cscript /nologo %tmp%\%batchname%.vbs') do set d=%%k
if %m% LSS 10 set m=0%m%
if %d% LSS 10 set d=0%d%
set OYYYYMMDD=%y%-%m%-%d%
set OYYYY-MM-DD=%y%-%m%-%d%
set YYYYMMDD=%date:~0,4%-%date:~5,2%-%date:~8,2%
::ECHO %YYYYMMDD
 
::---------------------------------------------------------------------------------
::  需要修改的變數
::===================================================
:: BatchPath        批次檔案存放路徑       
:: SourcePath        刪除舊資料的資料夾路徑
:: TmpPath1        暫存的資料夾路徑
:: TmpFile1        暫存的檔案名稱
:: GoalPath        檔案伺服器路徑
:: GoalFile        備份壓縮檔案名稱
:: EXC        排除不要檢查的資料夾路徑
:: NN        幾天前的舊檔案
::---------------------------------------------------------------------------------
set BatchPath=D:\Batch\
set SourcePath=D:\Syslogd\Log\ASA\
set TmpPath1=D:\Backup\tmp\
set TmpFile1=ZipPathList_%YYYYMMDD%.txt
set GoalPath=D:\Backup\
set GoalFile=%YYYYMMDD%.zip
set EXC=
set NN=7
set ZipPassword=12345678
::===================================================
set TmpPathFile1=%BatchPath%%TmpFile1%
 
echo.
echo ------------------------------------------------------------------
echo     HouseKeeping+ZipOldFile.CMD 運作步驟
echo ------------------------------------------------------------------
echo   1.【搬移】搬移舊檔案至檔案伺服器暫存區
echo   2.【清單】列出檔案伺服器暫存區目錄清單
echo   3.【壓縮】透過目錄清單壓縮檔案伺服器舊檔案
echo   4.【刪除】刪除檔案伺服器暫存區舊檔案
echo ------------------------------------------------------------------
echo.
 
::--------------------------------------
::  開始執行
::--------------------------------------
::  1.搬移舊檔案至檔案伺服器暫存區
::robocopy %SourcePath% %TmpPath1% /mov /s /minage:%NN% /r:1 /w:1 /xd %EXC% rd /q/s %TmpPath1%
 
::--------------------------------------
::  2.列出檔案伺服器暫存區目錄清單
del %BatchPath%%TmpFile1%
dir %TmpPath1% /B /O:N  /A:D > %BatchPath%%TmpFile1%
 
::--------------------------------------
::  3.透過目錄清單壓縮檔案伺服器舊檔案
FOR /F %%y in (%TmpPathFile1%) do (7z.exe a -tzip -p%ZipPassword% %GoalPath%%%y.zip %TmpPath1%%%y)
 
::--------------------------------------
::  4.刪除檔案伺服器暫存區舊檔案
:: rd /q/s %TmpPath1%