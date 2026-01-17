#!/usr/bin/env bash
#
# gpu-screen-recorder constrols for rofi
#
# Author: Justus0405
# Date: 30.04.2025
# License: MIT
# 
# Modified by: ponleou
# Date: 17.01.2026

###########
# CONFIG #
##########
SAVE_DIR="/media/Shared/Drive/Replay captures/GSR"
REPLAY_BUFFER_SEC="60"
FRAMERATE="60"
AUDIO_OUTPUT="default_output"
AUDIO_INPUT="default_input"
WINDOW="screen"                                 # 'screen', 'screen-direct', 'focused', 'portal' or 'region'
FRAMERATE_MODE="cfr"                            # 'cfr', or 'vfr'
VIDEO_CODEC="hevc"                              # 'auto', 'h264', 'hevc', 'av1', 'vp8', 'vp9', 'hevc_hdr', 'av1_hdr', 'hevc_10bit' or 'av1_10bit'
AUDIO_CODEC="opus"                              # 'aac', 'opus' or 'flac'
VIDEO_QUALITY="high"                            # 'medium', 'high', 'very_high' or 'ultra'
COLOR_RANGE="full"                              # 'limited', or 'full'
CONTAINER="mkv"                                 # 'mp4', 'mkv', 'flv', 'webm' and others that support h264, hevc, av1, vp8 or vp9
ENABLE_CURSOR="yes"                             # 'yes' or 'no'

START_REPLAY=" Start Replay"
START_REPLAY_PORTAL=" Start Replay (portal)"
SAVE_REPLAY=" Save Replay"
STOP_REPLAY=" Stop Replay"
START_RECORDING=" Start Recording"
START_RECORDING_PORTAL=" Start Recording (portal)"
STOP_RECORDING=" Stop Recording"
PAUSE_RECORDING=" Pause/Resume Recording"
####### END OF CONFIG #######


# Make sure the "Videos" folder exists
if [ ! -d "$SAVE_DIR" ]; then
    mkdir -p "$SAVE_DIR"
fi

if [[ -n "$1" ]]; then
    choice="$1"
    date=$(date +"%Y-%m-%d_%H-%M-%S")
    
    recording_options=(
        -w $WINDOW
        -f $FRAMERATE
        -fm $FRAMERATE_MODE
        -q $VIDEO_QUALITY
        -a "$AUDIO_OUTPUT|$AUDIO_INPUT"
        -k $VIDEO_CODEC
        -ac $AUDIO_CODEC
        -cursor $ENABLE_CURSOR
        -cr $COLOR_RANGE
        -c $CONTAINER
        -o "$SAVE_DIR/Recording_$date.$CONTAINER"
    )
    
    replay_options=(
        -w $WINDOW
        -f $FRAMERATE
        -fm $FRAMERATE_MODE
        -q $VIDEO_QUALITY
        -a "$AUDIO_OUTPUT|$AUDIO_INPUT"
        -k $VIDEO_CODEC
        -ac $AUDIO_CODEC
        -cursor $ENABLE_CURSOR
        -cr $COLOR_RANGE
        -c $CONTAINER
        -r $REPLAY_BUFFER_SEC
        -o "$SAVE_DIR"
    )
    
    case "$choice" in
       "$START_REPLAY")
            ( setsid gpu-screen-recorder "${replay_options[@]}" </dev/null &>/dev/null & )
            ;;
        "$START_REPLAY_PORTAL")
            replay_options[1]="portal"
            ( setsid gpu-screen-recorder "${replay_options[@]}" </dev/null &>/dev/null & )
            ;;
        "$START_RECORDING")
            ( setsid gpu-screen-recorder "${recording_options[@]}" </dev/null &>/dev/null & )
            ;;
        "$START_RECORDING_PORTAL")
            recording_options[1]="portal"
            ( setsid gpu-screen-recorder "${recording_options[@]}" </dev/null &>/dev/null & )
            ;;
        "$SAVE_REPLAY")
            pkill -SIGUSR1 -f gpu-screen-recorder
            ;;
        "$STOP_REPLAY")
            pkill -SIGINT -f gpu-screen-recorder
            ;;
        "$STOP_RECORDING")
            pkill -SIGINT -f gpu-screen-recorder
            ;;
        "$PAUSE_RECORDING")
            pkill -SIGUSR2 -f gpu-screen-recorder
            ;;
    esac
    exit 0
fi

# get process states (if its running and if its in replay mode)
process_list=$(pgrep -af gpu-screen-recorder)
pgrep_code=$?
running=0
replay_mode=0

if [[ $pgrep_code == 0 ]]; then
    running=1
fi

if [[ $running == 1 && "$process_list" == *"-r "* ]]; then
    replay_mode=1
fi

if [[ $running == 0 ]]; then
    echo "$START_REPLAY"
    echo "$START_REPLAY_PORTAL"
    echo "$START_RECORDING"
    echo "$START_RECORDING_PORTAL"
elif [[ $replay_mode == 1 ]]; then
    echo "$SAVE_REPLAY"
    echo "$STOP_REPLAY"
else
    echo "$PAUSE_RECORDING"
    echo "$STOP_RECORDING"
fi