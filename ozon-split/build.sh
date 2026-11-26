#!/usr/bin/env bash
# Ozonoterapiya_reels_v2 + new nurses video:
# 29.3–43.9 s the new video plays in the bottom panel (below the green line at y=958),
# then the top end card slides up and the new video fills the screen.
# The new video's music plays from its start at 29.3 s; the first video's sound fades out just before.
set -euo pipefail
A="$1"   # Ozonoterapiya_reels_v2.mp4 (1080x1920, 43.9 s)
B="$2"   # Ozon_terapiya_yangi_hamshiralar.mp4 (720x1280, 22.5 s)
OUT="${3:-ozonoterapiya_reels_v3.mp4}"
S=29.3    # bottom panel starts
E=43.9    # top video ends, transition to full screen
T=0.5     # transition length
P="clip((t-$E)/$T,0,1)"
EASE="if(lt($P,0.5),4*pow($P,3),1-pow(-2*$P+2,3)/2)"
ffmpeg -y -i "$A" -i "$B" -filter_complex "
[0:v]fps=30,tpad=stop_mode=clone:stop_duration=9,split[a1][a2];
[a2]crop=1080:966:0:0[top];
[1:v]fps=30,scale=1080:1920:flags=lanczos,setsar=1,setpts=PTS-STARTPTS+$S/TB[b];
[a1][b]overlay=x=0:y='675*(1-($EASE))':eval=frame:enable='gte(t,$S)':eof_action=pass[m];
[m][top]overlay=x=0:y='-966*($EASE)':eval=frame:enable='between(t,$S,$E+$T)'[v];
[0:a]afade=t=out:st=$(echo "$S-0.4"|bc):d=0.4,atrim=0:$S[aa];
[1:a]asetpts=PTS-STARTPTS,afade=t=in:d=0.2,adelay=$(echo "$S*1000/1"|bc)|$(echo "$S*1000/1"|bc)[ab];
[aa][ab]amix=inputs=2:duration=longest:normalize=0[a]
" -map "[v]" -map "[a]" -t $(echo "$S+22.5"|bc) -c:v libx264 -preset medium -crf 18 -pix_fmt yuv420p -c:a aac -b:a 192k -movflags +faststart "$OUT"
