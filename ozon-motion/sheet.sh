# usage: sheet.sh dir out cols w
cd $1; files=$(ls | sed 's/^t//; s/.png$//' | sort -g | sed 's/^/t/; s/$/.png/'); n=$(echo $files | wc -w); w=$4; h=$((w*16/9))
ffmpeg -v error -y $(for f in $files; do echo -i $f; done) -filter_complex "$(i=0; for f in $files; do echo -n "[$i]scale=$w:-1,drawtext=text='${f%.png}':x=6:y=6:fontsize=18:fontcolor=gray[v$i];"; i=$((i+1)); done; for j in $(seq 0 $((i-1))); do echo -n "[v$j]"; done; echo -n "xstack=inputs=$i:fill=gray:layout=$(python3 -c "print('|'.join(f'{(k%$3)*$w}_{(k//$3)*$h}' for k in range($n)))")")" -frames:v 1 $2
