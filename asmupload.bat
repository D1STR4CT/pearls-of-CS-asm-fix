@ECHO OFF

IF "%1"=="help" GOTO helpmenu
IF "%1"=="" GOTO helpmenu

ECHO -- Converting to hex....
IF exist files\index.hex DEL files\intel.hex
SET filename_ext=%2
SET filename=%filename_ext:~0,-4%

"avra-1.2.3/bin/avra" %2
IF exist %filename%.txt SET filename=%filename%.txt
IF exist %filename%.cof DEL %filename%.cof
IF exist %filename%.eep.hex DEL %filename%.eep.hex
IF exist %filename%.obj DEL %filename%.obj
IF %errorlevel% NEQ 0 GOTO error
SET f=%filename%
SET f=%f:/=\%
MOVE %f%.hex files\intel.hex

ECHO -- Uploading...
avrdude -q -q -patmega328p -carduino -P %1 -b115200 -D -Uflash:w:files/intel.hex:i
IF %errorlevel% NEQ 0 GOTO error

echo -- OK!
GOTO end

:error
ECHO -- Aborted due to error (level %errorlevel%).
exit /b  %errorlevel%
PAUSE

:helpmenu
ECHO Usage: asmupload port filename
PAUSE

:end