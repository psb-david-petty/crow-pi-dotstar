#!/usr/bin/env python3
#
# ds.py
#
import board
import adafruit_dotstar as dotstar
import random, sys, time

LEDS = 240      # number of DotStar LEDs in the string

random_color = lambda: random.randrange(0, 7) * 32

def rand(dots, n=None, t=0.05, d=20):
    """Change the color of n LEDs randomly every t seconds for d seconds."""
    # Use len(dots) if n is None.
    if n is None:
        n = dots.n
    start = time.time()
    while True:
        for i in range(n):
            # Set dots[i] to a random color.
            dots[i] = (random_color(), random_color(), random_color(), )
        time.sleep(t)
        if time.time() > start + d:
            return

def pulse(dots, n=None, c=(0x66, 0x33, 0x99, ), s=10, t=0.10, d=20):
    """Pulse color c of n LEDs in s steps every t seconds for d seconds."""
    # Use len(dots) if n is None.
    if n is None:
        n = dots.n
    m = [ i / s for i in range(s) ]
    start = time.time()
    while True:
        for f in m + list(reversed(m)):
            # print(f"{f:.2f}", end=' '); sys.stdout.flush()
            for i in range(n):
                # Set dots[i] to c scaled by f.
                dots[i] = tuple( int(f * rgb) for rgb in c )
            time.sleep(t)
            if time.time() > start + d:
                return

if __name__ == '__main__':
    d, n = 2, 32
    # Take d (delay seconds) from first command-line argument.
    if len(sys.argv) > 1: d = int(sys.argv[1])
    # Take n (number of DotStar LEDs) from second command-line argument.
    if len(sys.argv) > 2: n = int(sys.argv[2])

    dots = dotstar.DotStar(board.SCK, board.MOSI, max(n, LEDS), brightness=0.2)
    try:
        print(f" rand(dots,n={n},d={d}) ({int(time.time()) % 100:2d}s)")
        rand(dots, n=n, d=d)
        print(f"pulse(dots,n={n},d={d}) ({int(time.time()) % 100:2d}s)")
        pulse(dots, n=n, d=d)
        print(f"                     ({int(time.time()) % 100:2d}s)")
    except KeyboardInterrupt:
        pass

    dots.deinit()
    print('done...')

# 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
