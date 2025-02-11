import sys
from PIL import Image, ImageOps

def convert(data, source, target):
    return [target if item == source else item for item in data]


background = sys.argv[1]
os_art = sys.argv[2]
destination = sys.argv[3]

os_art_img = Image.open(os_art)
os_art_img_inverted = ImageOps.invert(os_art_img)
os_art_img_inverted_rgba = os_art_img_inverted.convert("RGBA")
os_art_data = os_art_img_inverted_rgba.getdata()

os_art_img_inverted_transparent = convert(os_art_data, (208,207,208,255), (0,0,0,0))
os_art_img_inverted_rgba.putdata(os_art_img_inverted_transparent)

os_art_semifinal = ImageOps.mirror(os_art_img_inverted_rgba)
os_art_final = ImageOps.flip(os_art_semifinal)

background_img = Image.open(background)
background_resized = background_img.resize(os_art_final.size)

background_resized.paste(os_art_final, None, os_art_final)

background_resized.save(destination, "PNG")
