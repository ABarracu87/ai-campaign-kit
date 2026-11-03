#!/usr/bin/env python3
"""Compose a motion ad: AI motion plate + Figma text layers + audio -> H.264/AAC MP4.

usage: compose.py <plate.mp4> <layers_dir> <out.mp4> --size W H --duration S [--scale W H --crop X Y]
Layers are full-frame transparent PNGs named NN_key.png (exported from the
"<CODE> — video layers" Figma page), so positions match the approved static exactly.
"""
import subprocess, sys, os, argparse

FPS = 30
# key: (start s, fade s, slide px from below). EXAMPLE values from one storyboard: replace them with yours;
# the disclaimer, scrims and AI tag are on screen for the whole spot.
TIMELINE = {
    "00_scrims":     (0.0, 0.0, 0),
    "08_disclaimer": (0.0, 0.0, 0),
    "09_aitag":      (0.0, 0.0, 0),
    "01_logo":       (0.15, 0.40, 16),
    "02_eyebrow":    (0.35, 0.35, 24),
    "03_hook":       (0.55, 0.45, 48),
    "04_sub":        (2.40, 0.45, 32),
    "05_hero":       (5.00, 0.30, 90),   # the slam, synced with the impact hit
    "06_codecta":    (9.00, 0.40, 36),
    "07_sticker":    (9.60, 0.40, 28),
}
SFX = [("whoosh.wav", 1.45, 1.0), ("impact.wav", 1.95, 0.8), ("impact.wav", 5.0, 1.0)]  # (file, start s, gain): sync to the plate's key beats, not the prompt's


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("plate"); ap.add_argument("layers"); ap.add_argument("out")
    ap.add_argument("--size", nargs=2, type=int, required=True, help="output size W H, from your format list")
    ap.add_argument("--duration", type=float, required=True, help="spot length in seconds")
    ap.add_argument("--scale", nargs=2, type=int, help="scale plate to WxH before cropping")
    ap.add_argument("--crop", nargs=2, type=int, default=[0, 0], help="crop offset X Y after scaling")
    ap.add_argument("--audio", default=os.path.join(os.path.dirname(__file__), "audio"))
    a = ap.parse_args()
    W, H = a.size
    DUR = a.duration
    layers = sorted(f for f in os.listdir(a.layers) if f.endswith(".png"))
    missing = set(TIMELINE) - {f[:-4] for f in layers}
    assert not missing, f"missing layers: {missing}"

    cmd = ["ffmpeg", "-y", "-hide_banner", "-loglevel", "error", "-i", a.plate]
    for f in layers:
        cmd += ["-loop", "1", "-framerate", str(FPS), "-t", str(DUR), "-i", os.path.join(a.layers, f)]
    music = os.path.join(a.audio, "music.m4a")
    cmd += ["-i", music] + sum((["-i", os.path.join(a.audio, s)] for s, _, _ in SFX), [])

    g = []
    sc = f"scale={a.scale[0]}:{a.scale[1]}," if a.scale else ""
    g.append(f"[0:v]fps={FPS},{sc}crop={W}:{H}:{a.crop[0]}:{a.crop[1]},setsar=1,trim=0:{DUR},setpts=PTS-STARTPTS[v0]")
    prev = "v0"
    for i, f in enumerate(layers, start=1):
        st, fd, slide = TIMELINE[f[:-4]]
        lab = f"l{i}"
        fade = f",fade=t=in:st={st}:d={fd}:alpha=1" if fd > 0 else ""
        g.append(f"[{i}:v]format=rgba{fade}[{lab}]")
        # ease-out cubic slide-up: offset = slide * (1-p)^3, p = clamp((t-st)/fd)
        y = f"'{slide}*pow(1-min(max((t-{st})/{fd},0),1),3)'" if slide else "0"
        g.append(f"[{prev}][{lab}]overlay=x=0:y={y}:eval=frame:format=auto[o{i}]")
        prev = f"o{i}"
    g.append(f"[{prev}]format=yuv420p[vout]")
    n = len(layers) + 1
    g.append(f"[{n}:a]atrim=0:{DUR},afade=t=in:st=0:d=0.3,afade=t=out:st={DUR-1.2}:d=1.2,volume=0.8[m]")
    mix = ["[m]"]
    for k, (s, st, gain) in enumerate(SFX, start=1):
        ms = int(st * 1000)
        g.append(f"[{n+k}:a]adelay={ms}|{ms},volume={gain}[s{k}]")
        mix.append(f"[s{k}]")
    g.append(f"{''.join(mix)}amix=inputs={len(mix)}:normalize=0:duration=first,loudnorm=I=-14:TP=-1.5:LRA=11,"
             f"aresample=48000,aformat=channel_layouts=stereo,apad,atrim=0:{DUR}[aout]")

    cmd += ["-filter_complex", ";".join(g), "-map", "[vout]", "-map", "[aout]",
            "-c:v", "libx264", "-profile:v", "high", "-pix_fmt", "yuv420p", "-r", str(FPS),
            "-b:v", "12M", "-maxrate", "16M", "-bufsize", "24M", "-movflags", "+faststart",
            "-c:a", "aac", "-b:a", "192k", "-ar", "48000", "-ac", "2", "-t", str(DUR), a.out]
    subprocess.run(cmd, check=True)


if __name__ == "__main__":
    main()
