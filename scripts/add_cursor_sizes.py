#!/usr/bin/env python3
"""Fix cursor nominal sizes and add missing 32px, 36px, and 40px sizes.

Upstream cursors declare wrong nominal sizes (e.g. nominal=32 but actual=48x48).
This script:
  1. Fixes nominal sizes to match actual pixel dimensions
  2. Creates proper 32px, 36px, and 40px cursors by scaling
  3. Removes any old incorrectly-sized entries for 36/40

Usage: add_cursor_sizes.py <cursor_dir> [<cursor_dir> ...]
"""

import struct
import sys
from pathlib import Path
from PIL import Image


def read_xcursor(filepath):
    """Parse an Xcursor file and return list of image entries."""
    with open(filepath, "rb") as f:
        data = f.read()

    if data[0:4] != b"Xcur":
        return None

    ntoc = struct.unpack_from("<I", data, 12)[0]

    images = []
    for i in range(ntoc):
        toc_offset = 16 + i * 12
        toc_type = struct.unpack_from("<I", data, toc_offset)[0]
        toc_subtype = struct.unpack_from("<I", data, toc_offset + 4)[0]
        toc_position = struct.unpack_from("<I", data, toc_offset + 8)[0]

        if toc_type != 0xFFFD0002:
            continue

        pos = toc_position
        chunk_header_size = struct.unpack_from("<I", data, pos)[0]
        chunk_version = struct.unpack_from("<I", data, pos + 12)[0]
        width = struct.unpack_from("<I", data, pos + 16)[0]
        height = struct.unpack_from("<I", data, pos + 20)[0]
        xhot = struct.unpack_from("<I", data, pos + 24)[0]
        yhot = struct.unpack_from("<I", data, pos + 28)[0]
        delay = struct.unpack_from("<I", data, pos + 32)[0]

        pixel_data_start = pos + chunk_header_size
        pixel_data_size = width * height * 4
        pixels = data[pixel_data_start : pixel_data_start + pixel_data_size]

        images.append(
            {
                "size": toc_subtype,
                "width": width,
                "height": height,
                "xhot": xhot,
                "yhot": yhot,
                "delay": delay,
                "pixels": pixels,
                "version": chunk_version,
            }
        )

    return images


def pixels_to_pil(pixels, width, height):
    """Convert premultiplied BGRA pixel data to straight-alpha PIL Image."""
    import numpy as np

    arr = np.frombuffer(pixels, dtype=np.uint8).reshape((height, width, 4)).copy()
    b, g, r, a = arr[:, :, 0], arr[:, :, 1], arr[:, :, 2], arr[:, :, 3]
    mask = a > 0
    af = a[mask].astype(np.float32) / 255.0
    r[mask] = np.clip(r[mask].astype(np.float32) / af, 0, 255).astype(np.uint8)
    g[mask] = np.clip(g[mask].astype(np.float32) / af, 0, 255).astype(np.uint8)
    b[mask] = np.clip(b[mask].astype(np.float32) / af, 0, 255).astype(np.uint8)
    rgba = np.stack([r, g, b, a], axis=2)
    return Image.fromarray(rgba)


def pil_to_pixels(img):
    """Convert straight-alpha PIL Image to premultiplied BGRA pixel data."""
    import numpy as np

    rgba = np.array(img, dtype=np.uint8)
    r, g, b, a = rgba[:, :, 0], rgba[:, :, 1], rgba[:, :, 2], rgba[:, :, 3]
    af = a.astype(np.float32) / 255.0
    r_pm = np.clip(r.astype(np.float32) * af, 0, 255).astype(np.uint8)
    g_pm = np.clip(g.astype(np.float32) * af, 0, 255).astype(np.uint8)
    b_pm = np.clip(b.astype(np.float32) * af, 0, 255).astype(np.uint8)
    bgra = np.stack([b_pm, g_pm, r_pm, a], axis=2)
    return bytes(bgra.tobytes())


def scale_image_entry(entry, new_size):
    """Scale a cursor image entry to a new size."""
    img = pixels_to_pil(entry["pixels"], entry["width"], entry["height"])
    scaled = img.resize((new_size, new_size), Image.LANCZOS)

    scale_factor = new_size / entry["width"]
    new_xhot = round(entry["xhot"] * scale_factor)
    new_yhot = round(entry["yhot"] * scale_factor)

    return {
        "size": new_size,
        "width": new_size,
        "height": new_size,
        "xhot": new_xhot,
        "yhot": new_yhot,
        "delay": entry["delay"],
        "pixels": pil_to_pixels(scaled),
        "version": entry["version"],
    }


def write_xcursor(filepath, images):
    """Write images to an Xcursor file."""
    ntoc = len(images)
    header_size = 16
    toc_size = ntoc * 12
    chunk_header_size = 36

    positions = []
    pos = header_size + toc_size
    for img in images:
        positions.append(pos)
        pos += chunk_header_size + img["width"] * img["height"] * 4

    out = bytearray()
    out += b"Xcur"
    out += struct.pack("<I", header_size)
    out += struct.pack("<I", 0x00010000)
    out += struct.pack("<I", ntoc)

    for i, img in enumerate(images):
        out += struct.pack("<I", 0xFFFD0002)
        out += struct.pack("<I", img["size"])
        out += struct.pack("<I", positions[i])

    for img in images:
        out += struct.pack("<I", chunk_header_size)
        out += struct.pack("<I", 0xFFFD0002)
        out += struct.pack("<I", img["size"])
        out += struct.pack("<I", img["version"])
        out += struct.pack("<I", img["width"])
        out += struct.pack("<I", img["height"])
        out += struct.pack("<I", img["xhot"])
        out += struct.pack("<I", img["yhot"])
        out += struct.pack("<I", img["delay"])
        out += img["pixels"]

    with open(filepath, "wb") as f:
        f.write(out)


def process_cursor_file(filepath):
    """Fix nominal sizes and add 32, 36, 40, 44 pixel sizes."""
    images = read_xcursor(filepath)
    if images is None:
        return False

    # Step 1: Fix nominal sizes to match actual pixel dimensions
    for img in images:
        img["size"] = img["width"]

    # Step 2: Remove any entries whose actual pixels don't match nominal size
    # (from previous runs where nominals were wrong)
    images = [img for img in images if img["size"] == img["width"]]

    # Group by actual size (for animated cursors with multiple frames)
    by_size = {}
    for img in images:
        by_size.setdefault(img["size"], []).append(img)

    # Step 3: Create missing sizes by scaling from nearest larger size
    sizes_to_add = {32, 36, 40, 44} - set(by_size.keys())

    for target_size in sorted(sizes_to_add):
        # Find closest larger size, or closest overall
        available = sorted(by_size.keys())
        larger = [s for s in available if s > target_size]
        if larger:
            source_size = larger[0]  # smallest larger size
        else:
            source_size = available[-1]  # largest available

        for source_entry in by_size[source_size]:
            new_entry = scale_image_entry(source_entry, target_size)
            images.append(new_entry)

        by_size[target_size] = [img for img in images if img["size"] == target_size]

    # Sort by size then delay
    images.sort(key=lambda x: (x["size"], x["delay"]))

    write_xcursor(filepath, images)
    return True


def main():
    if len(sys.argv) < 2:
        print("Usage: add_cursor_sizes.py <cursor_dir> [<cursor_dir> ...]")
        sys.exit(1)

    for cursor_dir in sys.argv[1:]:
        cursor_path = Path(cursor_dir)
        if not cursor_path.is_dir():
            print(f"Skipping {cursor_dir}: not a directory")
            continue

        print(f"Processing {cursor_path.parent.name}...")
        count = 0
        errors = 0
        for cursor_file in sorted(cursor_path.iterdir()):
            if cursor_file.is_symlink():
                continue
            if not cursor_file.is_file():
                continue
            with open(cursor_file, "rb") as f:
                magic = f.read(4)
            if magic != b"Xcur":
                continue

            try:
                process_cursor_file(cursor_file)
                count += 1
            except Exception as e:
                print(f"  Error processing {cursor_file.name}: {e}")
                errors += 1

        print(f"  Processed {count} cursor files, {errors} errors")


if __name__ == "__main__":
    main()
