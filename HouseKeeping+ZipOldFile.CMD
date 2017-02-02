::---------------------------------------------------------------------------------
::   HouseKeeping+ZipOldFile.CMD v1.1 | WadeEaton1@gmail.com
::---------------------------------------------------------------------------------
::@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
set batchname=HouseKeeping+ZipOldFile
 
::--------------------------------------
:: �ɶ��ܼ�
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
::  �ݭn�ק諸�ܼ�
::===================================================
:: BatchPath        �妸�ɮצs����|       
:: SourcePath        �R���¸�ƪ���Ƨ����|
:: TmpPath1        �Ȧs����Ƨ����|
:: TmpFile1        �Ȧs���ɮצW��
:: GoalPath        �ɮצ��A�����|
:: GoalFile        �ƥ����Y�ɮצW��
:: EXC        �ư����n�ˬd����Ƨ����|
:: NN        �X�ѫe�����ɮ�
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
echo     HouseKeeping+ZipOldFile.CMD �B�@�B�J
echo ------------------------------------------------------------------
echo   1.�i�h���j�h�����ɮצ��ɮצ��A���Ȧs��
echo   2.�i�M��j�C�X�ɮצ��A���Ȧs�ϥؿ��M��
echo   3.�i���Y�j�z�L�ؿ��M�����Y�ɮצ��A�����ɮ�
echo   4.�i�R���j�R���ɮצ��A���Ȧs�����ɮ�
echo ------------------------------------------------------------------
echo.
 
::--------------------------------------
::  �}�l����
::--------------------------------------
::  1.�h�����ɮצ��ɮצ��A���Ȧs��
::robocopy %SourcePath% %TmpPath1% /mov /s /minage:%NN% /r:1 /w:1 /xd %EXC% rd /q/s %TmpPath1%
 
::--------------------------------------
::  2.�C�X�ɮצ��A���Ȧs�ϥؿ��M��
del %BatchPath%%TmpFile1%
dir %TmpPath1% /B /O:N  /A:D > %BatchPath%%TmpFile1%
 
::--------------------------------------
::  3.�z�L�ؿ��M�����Y�ɮצ��A�����ɮ�
FOR /F %%y in (%TmpPathFile1%) do (7z.exe a -tzip -p%ZipPassword% %GoalPath%%%y.zip %TmpPath1%%%y)
 
::--------------------------------------
::  4.�R���ɮצ��A���Ȧs�����ɮ�
:: rd /q/s %TmpPath1%