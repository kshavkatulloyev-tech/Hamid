# Hamid
Клиника фаолияти ҳақида юқори технологик роликлар

## Лойиҳалар

| Папка | Нима | Узунлиги |
|---|---|---|
| `ozon-motion/` | Озонотерапия моушн-рилси «O₂ → O₃»: вертикал 1080×1920, 60 fps, кодда ёзилган мусиқа | 22,5 с (80 BPM); 15 сониялик версияси `src_15s.html` |
| `ozon-reels/` | Озонотерапия рилси (HyperFrames): суратлар, матн, клиника маълумотлари | 23 с |
| `showreel-one-line/` | «ONE LINE» моушн-дизайн шоурили, 1920×1080, 60 fps | 15 с |

## Суратлар ҳақида

Бу репозиторий очиқ. Шунинг учун ходимлар ва беморлар суратлари, шунингдек суратлар солинган тайёр видеолар бу ерга юкланмаган. Тайёр видеоларни телефонингизда сақланг.

Видеони қайта ясаш учун суратларни қуйидаги жойларга қўйинг:

- `ozon-motion/`: `p1.jpg`, `p2.jpg`, `p3.jpg` (доира ичидаги учта ходим) ва `p4.jpg` (ёзилиш экранидаги аватар). Ҳар бири квадрат, юзи марказда, ~420×420.
- `ozon-reels/assets/`: `proc1.jpg`, `proc2.jpg` (муолажа), `nurse1.jpg`, `nurse3.jpg`, `staff4.jpg`, `room.jpg` (жамоа).

## Қандай рендер қилинади

**ozon-motion** ва **showreel-one-line** (Node.js, Playwright ва ffmpeg керак):

```bash
python3 build.py          # шрифт ва суратларни битта HTML файлга жойлайди
node render.js            # 60 fps × 3 субкадр → video.mp4 ва soundtrack.wav
ffmpeg -i video.mp4 -i soundtrack.wav -c:v copy -c:a aac -b:a 256k -shortest natija.mp4
```

Рендердан олдин ҳар бир бит учун битта кадр кўриш:
`node frames.js "[0.42,0.92]" kadrlar`

**ozon-reels** (HyperFrames):

```bash
npx hyperframes preview   # браузерда кўриш ва таҳрирлаш
npx hyperframes render --output natija.mp4
```
