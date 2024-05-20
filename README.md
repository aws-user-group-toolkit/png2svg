# PNG2SVG

This is a Python script that converts PNG images to SVG format. It takes in a PNG image file and outputs an SVG file.

## Usage

### Available Environment Variables

| Variable Name | Description                                           | Valid inputs     | Default            |
| --- | --- | --- | --- |
| SOURCE_FILE_PATH | Input PNG file path                               | File path        | None               |
| OUTPUT_DIR    | Directory where result is stored within the container | Text             | /output            |
| OUTPUT_FILENAME | Output SVG file name                               | Text             | None               |

### Using Docker

1. Install Docker on your system. You can download Docker from the official website: https://www.docker.com/get-started

2. Run the Docker container:

   ```
   docker run --rm -v $(pwd):/output -e OUTPUT_DIR="/output/test" -e SOURCE_FILE_PATH="/output/test/my-image.png" -e OUTPUT_FILENAME="my-output-image" ghcr.io/aws-community-toolkit/png2svg:latest
   ```

   This command runs the Docker container and mounts the current directory to the `/output` directory in the container. It passes in the required parameters for the script using command-line arguments.

   You can add multiple `-e` parameters for all the environment variables listed in the table above.

3. Check the output directory for the generated SVG file:

   ```
   ls output/test/
   ```

   You should see an SVG file with the name you specified in `OUTPUT_FILENAME`.

### Using Podman

1. Install Podman on your system. You can download Podman from the official website: https://podman.io/getting-started/installation

2. Run the Podman container:

   ```
   podman run --rm -v $(pwd):/output -e OUTPUT_DIR="/output/test" -e SOURCE_FILE_PATH="/output/test/my-image.png" -e OUTPUT_FILENAME="my-image.svg" ghcr.io/aws-community-toolkit/png2svg:latest
   ```

   This command runs the Podman container and mounts the current directory to the `/output` directory in the container. It passes in the required parameters for the script using command-line arguments.

   You can add multiple `-e` parameters for all the environment variables listed in the table above.

3. Check the output directory for the generated SVG file:

   ```
   ls output/test/
   ```

   You should see an SVG file with the name you specified in `OUTPUT_FILENAME`.

That's it! You should now be able to use this script to convert PNG images to SVG format using Docker or Podman.