from PIL import Image
import time

C_WIDTH = 8
C_HEIGHT = 16

print(f"Font ROM target: {C_WIDTH}x{C_HEIGHT}")

startTime = time.time()
raw = Image.open("./vga_font.png")

pix = raw.load()


def parseChar(fx, fy):
    pack = []

    for y in range(0, C_HEIGHT):
        for x in range(0, C_WIDTH):
            px = pix[x + fx,y + fy]

            val = '1' if px > 0 else '0'

            pack.append(val)

    return str(C_WIDTH*C_HEIGHT) + "'b" + "".join(reversed(pack))

chars_w = raw.width / C_WIDTH;
chars_h = raw.height / C_HEIGHT;

f = open("meminit_font.v", "w")

i = 0
for y in range(0, raw.height, C_HEIGHT):
    for x in range(0, raw.width, C_WIDTH):
        chr = parseChar(x,y);

        #print("Char", i, "at", x, y)

        f.write("`FONT_MAP[" + str(i) + "] = " + chr + ";\n")

        i += 1;

f.close();

print("Loaded", i, "characters")
print(f"Done ({round((time.time() - startTime) * 1000) / 1000} s)")