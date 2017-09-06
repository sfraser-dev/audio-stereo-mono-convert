@echo off
:: best to use a video with different audio in the left and right channels

if EXIST "%1" (
    goto MAIN
)
goto ERROR1

:MAIN
:: stereo output, L=tapping, R=counting (do nothing, same as original)
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -map_channel 0.1.0 ^
    -map_channel 0.1.1 ^
    vid_stereoLR.mp4

:: stereo output, L=tapping, R=tapping
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -map_channel 0.1.0 ^
    vid_stereoLL.mp4

:: stereo output, L=counting, R=counting
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -map_channel 0.1.1 ^
    vid_stereoRR.mp4

:: mono output, tapping and counting
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -ac 1 ^
    vid_monoLR.mp4

:: mono output, tapping only 
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -map_channel 0.1.0 ^
    -ac 1 ^
    vid_monoLL.mp4

:: mono output, counting only 
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -map_channel 0.1.1 ^
    -ac 1 ^
    vid_monoRR.mp4

goto END


:ERROR1
echo ERROR: "video input (with stereo audio) needed ... exiting"
goto END


:END
