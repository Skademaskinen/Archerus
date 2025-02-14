import sys
from PIL import Image, ImageOps

def convert(data, source, target):
    return [target if item == source else item for item in data]


background = sys.argv[1]
os_art = sys.argv[2]
destination = sys.argv[3]

print(os_art)

os_art_img = Image.open(os_art)

os_art_rgba = os_art_img.convert("RGBA")
os_art_data = os_art_rgba.getdata()

os_art_transparent = convert(os_art_data, (47,48,47,255), (0,0,0,0))

os_art_rgba.putdata(os_art_transparent)

background_img = Image.open(background)
background_img_rgba = background_img.convert("RGBA")
background_img_resized = background_img_rgba.resize((1920, 1080))

background_img_resized.paste(os_art_rgba, (int(1920/4.5), int(1080/4.5)), os_art_rgba)

background_img_resized.save(destination, "PNG")
