import subprocess

input_file = "py/input.mp4"
output_file = "py/output.mp4"

# -itsoffset -2 shifts audio backwards by 2 seconds
cmd = [
    "ffmpeg", "-i", input_file,
    "-itsoffset", "1", "-i", input_file,
    "-map", "0:v", "-map", "1:a",
    "-c:v", "copy", "-c:a", "aac",
    output_file
]

subprocess.run(cmd)
