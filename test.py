#!/use/bin/env python3
import board, adafruit_dotstar as dotstar, sys, time
max_n = 250

for n in range(max_n + 1):
    print(n, end=' '); sys.stdout.flush()
    dots = dotstar.DotStar(board.SCK, board.MOSI, n, brightness=0.1)
    for i in range(dots.n):
        dots[i] = (0x66, 0x33, 0x99, )  # Rebecca Purple
    time.sleep(1)
    dots.deinit()
    time.sleep(1)
print('done...')
