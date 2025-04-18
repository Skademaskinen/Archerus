import sys
from PIL import Image, ImageOps
from cairosvg import svg2png

def convert(data, source, target):
    return [target if item == source else item for item in data]


def autocrop_image(image, border = 0):
    # Get the bounding box
    bbox = image.getbbox()

    # Crop the image to the contents of the bounding box
    image = image.crop(bbox)

    # Determine the width and height of the cropped image
    (width, height) = image.size

    # Add border
    width += border * 2
    height += border * 2
    
    # Create a new image object for the output image
    cropped_image = Image.new("RGBA", (width, height), (0,0,0,0))

    # Paste the cropped image onto the new image
    cropped_image.paste(image, (border, border))

    # Done!
    return cropped_image
    
def fixup_image(image:str) -> Image.Image:
    if image.split(".")[-1] == "svg":
        with open(image, "r") as file:
            svg2png(bytestring=file.read(), write_to="out.png")
        image = "out.png"
    img = Image.open(image)
    rgba = img.convert("RGBA")
    data = rgba.getdata()
    transparent = convert(data, (47,48,47,255), (0,0,0,0))
    rgba.putdata(transparent)
    cropped = autocrop_image(rgba)
    return ImageOps.contain(cropped, (150, 150))


x, y = (1920/4.5, 1080/3.3)

_, background, *images, destination = sys.argv

fixed_images = map(fixup_image, images)

background_img = Image.open(background)
background_img_rgba = background_img.convert("RGBA")
background_img_resized = background_img_rgba.resize((1920, 1080))

for i, image in enumerate(fixed_images):
    background_img_resized.paste(image, (int(x + (124 * i)), int(y)), image)

background_img_resized.save(destination, "PNG")
