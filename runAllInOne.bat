@echo off
:: use a video with different audio in the left and right channels
:: initial test video had tapping in the left channel and counting in the right channel

if EXIST "%1" (
    goto MAIN
)
goto ERROR1

:MAIN
:: stereo output, L=tapping, R=counting (same as original)
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -map_channel 0.1.0 ^
    -map_channel 0.1.1 ^
    vid_stereo010011.mp4

:: mono output, tapping only (left channel only)
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -map_channel 0.1.0 ^
    vid_mono010.mp4

:: mono output, counting only (right channel only)
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -map_channel 0.1.1 ^
    vid_mono011.mp4

:: mono output, tapping and counting (left and right channel combined)
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -ac 1 ^
    vid_monoAC.mp4

:: mono output, tapping only (left channel only)
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -map_channel 0.1.0 ^
    -ac 1 ^
    vid_mono010AC.mp4

:: mono output, counting only (right channel only)
ffmpeg -y -i %1 ^
    -map 0:0 -map 0:1 ^
    -c:v copy ^
    -map_channel 0.1.1 ^
    -ac 1 ^
    vid_mono011AC.mp4

:: select the first video track and the first audio track, mono output, tapping and counting (left and right channel combined)
ffmpeg -y -i %1 -map 0:v:0 -c:v copy -map 0:a:0 -ac 1 vid_mono0v00a0AC.mp4

goto END


:ERROR1
echo ERROR: "video input (with stereo audio) needed ... exiting"
goto END


:END
