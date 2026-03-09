import colorsys

def generate_similar_colors(base_color, num_colors):
    # Convert the RGB color to HSV
    base_hsv = colorsys.rgb_to_hsv(base_color[0] / 255.0, base_color[1] / 255.0, base_color[2] / 255.0)

    similar_colors = []

    for i in range(num_colors):
        # Adjust the hue to generate similar colors
        hue = (base_hsv[0] + (i * 0.05)) % 1.0

        # Convert the HSV color back to RGB
        rgb_color = colorsys.hsv_to_rgb(hue, base_hsv[1], base_hsv[2])

        # Scale the RGB values to the range [0, 255]
        rgb_color = tuple(int(value * 255) for value in rgb_color)

        similar_colors.append(rgb_color)

    return list(set(similar_colors))

# Base color (blue in RGB format)
base_blue = (129, 43, 73)

# Number of similar colors to generate
num_similar_colors = 10000

# Generate similar colors
similar_colors = generate_similar_colors(base_blue, num_similar_colors)

print(len(similar_colors))
print(similar_colors[-1])

# Display the generated colors
# for i, color in enumerate(similar_colors, start=1):
#     print(f"Similar Color {i}: {color}")
