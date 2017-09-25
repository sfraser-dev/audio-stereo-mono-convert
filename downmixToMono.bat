@echo off

:: Requires FFmpeg
:: A static build of FFmpeg can be found here: https://ffmpeg.zeranoe.com/builds

:: Look for media containers with the following extension  
SET CONTAINER_EXTN=mp4
:: Extension of audio codec used in the media container
SET AUDIO_EXTN=aac

:: Recursively search for required media container
for /f "delims=" %%f in ('dir "*.%CONTAINER_EXTN%" /s/b') do @call:THEFUN "%%f"
goto:EOF

:THEFUN
:: Resolving filenames
SET THE_ORIGINAL_NAME="%~f1"
SET THE_DRIVE_LETTER=%~d1
SET THE_PATH=%~p1
SET THE_FILE=%~n1
SET THE_EXTN=%~x1

:: Make a copy of the original audio
SET THE_AUDIO_NAME="%THE_DRIVE_LETTER%%THE_PATH%%THE_FILE%_originalAudio.%AUDIO_EXTN%"
ffmpeg -y -i %THE_ORIGINAL_NAME% -vn -c:a copy %THE_AUDIO_NAME%

:: Downmix the audio to mono in the container file
SET THE_TEMP_NAME="%THE_DRIVE_LETTER%%THE_PATH%%THE_FILE%_temp.%CONTAINER_EXTN%"
:: Rename the original video to "temp"
move /Y %THE_ORIGINAL_NAME% %THE_TEMP_NAME%
:: Use FFmpeg to downmix the audio
ffmpeg -y -i %THE_TEMP_NAME% -map 0:v -c:v copy -map 0:a -ac 1 -b:a 128k %THE_ORIGINAL_NAME%
:: Delete the "temp" container
del /Q %THE_TEMP_NAME%
goto:EOF

:EOF
