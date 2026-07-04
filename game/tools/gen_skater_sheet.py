#!/usr/bin/env python3
"""Generate the placeholder silhouette skater sprite sheet.

REPLACED-style: dark figure, cool rim light on top edges, tiny accents
(wheels, cap). Drawn at 1x logical pixels; the game displays it at 2x with
nearest filtering. Regenerate with:  python3 game/tools/gen_skater_sheet.py

Output: game/assets/player/skater_sheet.png  (grid of FRAME x FRAME cells)
Frame order must match FRAMES in scripts/player/player_visuals.gd.
"""
from PIL import Image, ImageDraw
import os

FRAME = 44          # logical px per cell
COLS = 8
INK   = (26, 29, 40, 255)    # main silhouette
INK2  = (40, 45, 61, 255)    # far-side limbs (depth)
RIM   = (134, 156, 185, 255) # top rim light
DECK  = (46, 35, 30, 255)
GRIP  = (16, 17, 22, 255)
WHEEL = (214, 205, 186, 255)
CAP   = (118, 48, 54, 255)   # maroon cap accent

# ---------------------------------------------------------------- helpers ---

def limb(d, p0, p1, w, c):
    d.line([p0, p1], fill=c, width=w)

def torso(d, hip, sho, w=5, c=INK):
    d.line([hip, sho], fill=c, width=w)

def head(d, cx, cy, c=INK, cap=True, face=1):
    # 6x6 head block + cap brim pointing `face` direction
    d.rectangle([cx - 3, cy - 3, cx + 2, cy + 2], fill=c)
    if cap:
        d.rectangle([cx - 3, cy - 3, cx + 2, cy - 2], fill=CAP)
        d.rectangle([cx + 2 + (1 if face > 0 else -7), cy - 3,
                     cx + 2 + (3 if face > 0 else -5), cy - 2], fill=CAP)

def board(d, cx, y, carried=False):
    """Deck centered at cx with top at y. y is the deck top row."""
    if carried:
        # vertical-ish board tucked under arm: thin tall rect
        d.rectangle([cx - 1, y, cx + 1, y + 16], fill=DECK)
        d.rectangle([cx - 1, y, cx, y + 16], fill=GRIP)
        return
    d.rectangle([cx - 11, y, cx + 11, y + 1], fill=GRIP)      # grip tape
    d.rectangle([cx - 11, y + 2, cx + 11, y + 2], fill=DECK)  # deck side
    # kick tails
    d.point((cx - 12, y), fill=GRIP); d.point((cx + 12, y), fill=GRIP)
    # trucks + wheels
    for wx in (cx - 7, cx + 7):
        d.rectangle([wx - 1, y + 3, wx, y + 4], fill=WHEEL)

def rim_pass(img):
    """1px rim light on silhouette pixels whose upper neighbour is empty."""
    px = img.load()
    w, h = img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a and (r, g, b) in (INK[:3], INK2[:3], CAP[:3]):
                if y == 0 or px[x, y - 1][3] == 0:
                    px[x, y] = RIM

# ------------------------------------------------------------------ poses ---
# All poses face right. Baseline: wheel bottom row = 41, deck top = 37,
# feet stand on y = 36. Frame origin top-left.

def pose_roll(d, bob=0):
    b = bob
    board(d, 22, 37)
    limb(d, (25, 36), (24, 30 + b), 3, INK)   # front leg (shin)
    limb(d, (24, 30 + b), (21, 25 + b), 3, INK)  # front thigh
    limb(d, (17, 36), (18, 30 + b), 3, INK2)  # back leg
    limb(d, (18, 30 + b), (21, 25 + b), 3, INK2)
    torso(d, (21, 26 + b), (20, 15 + b))
    limb(d, (20, 16 + b), (17, 22 + b), 2, INK2)  # back arm
    limb(d, (20, 16 + b), (24, 21 + b), 2, INK)   # front arm relaxed
    head(d, 22, 11 + b)

def pose_push(d, phase):
    board(d, 20, 37)
    # front foot planted on board, deep-ish bend
    limb(d, (24, 36), (23, 30), 3, INK)
    limb(d, (23, 30), (20, 26), 3, INK)
    if phase == 0:      # windup: back leg lifted behind
        limb(d, (20, 27), (15, 30), 3, INK2)
        limb(d, (15, 30), (11, 27), 3, INK2)
    elif phase == 1:    # kick: back leg extended to ground behind
        limb(d, (20, 27), (14, 33), 3, INK2)
        limb(d, (14, 33), (10, 40), 3, INK2)
    else:               # recover: leg swinging forward low
        limb(d, (20, 27), (16, 33), 3, INK2)
        limb(d, (16, 33), (17, 38), 3, INK2)
    torso(d, (20, 27), (18, 16))
    limb(d, (18, 17), (14, 22), 2, INK2)
    limb(d, (18, 17), (23, 21), 2, INK)
    head(d, 20, 12)

def pose_crouch(d):
    board(d, 22, 37)
    limb(d, (26, 36), (27, 31), 3, INK)
    limb(d, (27, 31), (21, 29), 3, INK)
    limb(d, (17, 36), (15, 31), 3, INK2)
    limb(d, (15, 31), (21, 29), 3, INK2)
    torso(d, (21, 30), (18, 22), 5)
    limb(d, (18, 23), (12, 26), 2, INK2)   # arms out for balance
    limb(d, (18, 23), (26, 24), 2, INK)
    head(d, 20, 18)

def pose_air(d):
    # tucked: board pulled up with feet, knees to chest
    board(d, 22, 30)
    limb(d, (25, 29), (26, 24), 3, INK)
    limb(d, (26, 24), (21, 21), 3, INK)
    limb(d, (18, 29), (16, 24), 3, INK2)
    limb(d, (16, 24), (21, 21), 3, INK2)
    torso(d, (21, 22), (19, 13), 5)
    limb(d, (19, 14), (12, 11), 2, INK2)   # arms up-out
    limb(d, (19, 14), (27, 11), 2, INK)
    head(d, 21, 9)

def pose_land(d):
    board(d, 22, 37)
    limb(d, (27, 36), (28, 32), 3, INK)
    limb(d, (28, 32), (22, 30), 3, INK)
    limb(d, (16, 36), (14, 32), 3, INK2)
    limb(d, (14, 32), (22, 30), 3, INK2)
    torso(d, (22, 31), (17, 24), 5)        # torso pitched forward
    limb(d, (17, 25), (11, 29), 2, INK2)   # arms low
    limb(d, (17, 25), (24, 28), 2, INK)
    head(d, 19, 20)

def pose_grind(d):
    board(d, 22, 37)
    limb(d, (26, 36), (27, 31), 3, INK)
    limb(d, (27, 31), (21, 28), 3, INK)
    limb(d, (17, 36), (15, 31), 3, INK2)
    limb(d, (15, 31), (21, 28), 3, INK2)
    torso(d, (21, 29), (19, 20), 5)
    limb(d, (19, 21), (11, 19), 2, INK2)   # arms wide, surf style
    limb(d, (19, 21), (28, 19), 2, INK)
    head(d, 21, 16)

def pose_bail(d):
    # tumbling ball; controller spins the Visual node
    d.ellipse([13, 20, 29, 36], fill=INK)
    limb(d, (27, 23), (32, 18), 3, INK2)   # flailing arm
    limb(d, (15, 33), (10, 38), 3, INK2)   # flailing leg
    head(d, 17, 22, cap=False)
    board(d, 30, 35)  # board escaping

def pose_recover(d):
    # one knee down, pushing up
    board(d, 30, 37)
    limb(d, (14, 40), (15, 34), 3, INK2)   # kneeling shin on ground
    limb(d, (15, 34), (19, 32), 3, INK2)
    limb(d, (23, 40), (23, 35), 3, INK)    # planted foot
    limb(d, (23, 35), (19, 32), 3, INK)
    torso(d, (19, 33), (17, 24), 5)
    limb(d, (17, 25), (13, 30), 2, INK)    # hand toward ground
    head(d, 19, 20)

def pose_walk(d, phase):
    # board carried under left (far) arm
    stride = [(3, -3), (1, 0), (-3, 3), (0, 0)][phase]
    f, bk = stride
    limb(d, (21, 28), (21 + f, 34), 3, INK)
    limb(d, (21 + f, 34), (22 + f, 40), 3, INK)
    limb(d, (21, 28), (21 + bk, 34), 3, INK2)
    limb(d, (21 + bk, 34), (20 + bk, 40), 3, INK2)
    torso(d, (21, 29), (20, 17))
    board(d, 16, 18, carried=True)
    limb(d, (20, 19), (16, 24), 2, INK2)   # far arm holds board
    limb(d, (20, 18), (24, 24), 2, INK)    # near arm swings
    head(d, 21, 13)

def pose_stand(d, breathe=0):
    b = breathe
    limb(d, (22, 28 + b), (23, 40), 3, INK)
    limb(d, (20, 28 + b), (19, 40), 3, INK2)
    torso(d, (21, 29 + b), (20, 17 + b))
    board(d, 16, 18 + b, carried=True)
    limb(d, (20, 19 + b), (16, 24 + b), 2, INK2)
    limb(d, (20, 18 + b), (23, 25 + b), 2, INK)
    head(d, 21, 13 + b)

def pose_crawl(d, phase):
    # hands-and-knees, board flat on the back, contact at ground row 40
    a = 3 if phase else 0
    d.rectangle([12, 23, 24, 24], fill=GRIP)         # board on back
    d.rectangle([12, 25, 24, 25], fill=DECK)
    torso(d, (15, 31), (27, 30), 5)
    limb(d, (27, 30), (29 - a, 40), 2, INK)          # front arm
    limb(d, (25, 31), (21 + a, 40), 2, INK2)         # rear arm
    limb(d, (15, 31), (12 + a, 37), 3, INK)          # thigh
    limb(d, (12 + a, 37), (16 + a, 40), 3, INK)      # shin folded under
    limb(d, (16, 32), (10 - a // 2, 38), 3, INK2)    # far leg trailing
    head(d, 31, 27)

def pose_climb(d, phase):
    # on a ladder/fence face, arms overhead, board slung on the back
    a = 3 if phase else 0
    d.rectangle([13, 18, 15, 34], fill=DECK)         # board on back
    d.rectangle([14, 18, 14, 34], fill=GRIP)
    torso(d, (21, 33), (20, 21), 5)
    limb(d, (21, 33), (25, 37), 3, INK)              # bent legs into wall
    limb(d, (25, 37), (23, 42), 3, INK)
    limb(d, (20, 33), (23, 38 - a), 3, INK2)
    limb(d, (23, 38 - a), (21, 42 - a), 3, INK2)
    limb(d, (20, 22), (24, 12 + a), 2, INK)          # reaching arms
    limb(d, (20, 22), (16, 14 - a), 2, INK2)
    head(d, 19, 17, face=1)

POSES = [
    ("roll_0",  lambda d: pose_roll(d, 0)),
    ("roll_1",  lambda d: pose_roll(d, 1)),
    ("push_0",  lambda d: pose_push(d, 0)),
    ("push_1",  lambda d: pose_push(d, 1)),
    ("push_2",  lambda d: pose_push(d, 2)),
    ("crouch",  pose_crouch),
    ("air",     pose_air),
    ("land",    pose_land),
    ("grind",   pose_grind),
    ("bail",    pose_bail),
    ("recover", pose_recover),
    ("walk_0",  lambda d: pose_walk(d, 0)),
    ("walk_1",  lambda d: pose_walk(d, 1)),
    ("walk_2",  lambda d: pose_walk(d, 2)),
    ("walk_3",  lambda d: pose_walk(d, 3)),
    ("stand_0", lambda d: pose_stand(d, 0)),
    ("stand_1", lambda d: pose_stand(d, 1)),
    ("crawl_0", lambda d: pose_crawl(d, 0)),
    ("crawl_1", lambda d: pose_crawl(d, 1)),
    ("climb_0", lambda d: pose_climb(d, 0)),
    ("climb_1", lambda d: pose_climb(d, 1)),
]

def main():
    rows = (len(POSES) + COLS - 1) // COLS
    sheet = Image.new("RGBA", (COLS * FRAME, rows * FRAME), (0, 0, 0, 0))
    for i, (name, fn) in enumerate(POSES):
        cell = Image.new("RGBA", (FRAME, FRAME), (0, 0, 0, 0))
        fn(ImageDraw.Draw(cell))
        rim_pass(cell)
        cx, cy = (i % COLS) * FRAME, (i // COLS) * FRAME
        sheet.paste(cell, (cx, cy))
    out = os.path.join(os.path.dirname(__file__), "..", "assets", "player")
    os.makedirs(out, exist_ok=True)
    path = os.path.join(out, "skater_sheet.png")
    sheet.save(path)
    print("wrote", path, sheet.size)
    print("order:", ", ".join(f"{i}:{n}" for i, (n, _) in enumerate(POSES)))

if __name__ == "__main__":
    main()
