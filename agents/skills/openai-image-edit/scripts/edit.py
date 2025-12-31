#!/usr/bin/env python3
"""
Edit images via OpenAI gpt-image-1 API.

Creates edited or extended images given one or more source images and a prompt.
Supports masks for selective editing and multiple input images for compositing.
"""

import argparse
import base64
import datetime as _dt
import json
import mimetypes
import os
import re
import sys
import uuid
from urllib.error import HTTPError
from urllib.request import Request, urlopen

MODEL = "gpt-image-1"

VALID_SIZES = ["1024x1024", "1536x1024", "1024x1536", "auto"]
VALID_QUALITIES = ["low", "medium", "high", "auto"]
VALID_BACKGROUNDS = ["transparent", "opaque", "auto"]
VALID_OUTPUT_FORMATS = ["png", "jpeg", "webp"]
VALID_INPUT_FIDELITIES = ["low", "high"]


def _stamp() -> str:
    return _dt.datetime.now().strftime("%Y-%m-%d-%H%M%S")


def _slug(text: str, max_len: int = 60) -> str:
    s = text.lower()
    s = re.sub(r"[^a-z0-9]+", "-", s).strip("-")
    return (s[:max_len] or "edited").strip("-")


def _default_out_dir() -> str:
    projects_tmp = os.path.expanduser("~/Projects/tmp")
    if os.path.isdir(projects_tmp):
        return os.path.join(projects_tmp, f"openai-image-edit-{_stamp()}")
    return os.path.join(os.getcwd(), "tmp", f"openai-image-edit-{_stamp()}")


def _api_url() -> str:
    base = (
        os.environ.get("OPENAI_BASE_URL")
        or os.environ.get("OPENAI_API_BASE")
        or "https://api.openai.com"
    ).rstrip("/")
    if base.endswith("/v1"):
        return f"{base}/images/edits"
    return f"{base}/v1/images/edits"


def _file_extension(output_format: str) -> str:
    return {"jpeg": "jpg", "webp": "webp", "png": "png"}.get(output_format, "png")


def _get_content_type(path: str) -> str:
    """Get MIME type for image file."""
    mime, _ = mimetypes.guess_type(path)
    if mime and mime.startswith("image/"):
        return mime
    ext = os.path.splitext(path)[1].lower()
    return {
        ".png": "image/png",
        ".jpg": "image/jpeg",
        ".jpeg": "image/jpeg",
        ".webp": "image/webp",
    }.get(ext, "application/octet-stream")


def _build_multipart(fields: list[tuple[str, str, bytes, str | None]]) -> tuple[bytes, str]:
    """
    Build multipart/form-data body.
    
    fields: list of (name, filename, data, content_type)
            For text fields: (name, "", value.encode(), None)
            For files: (name, filename, file_bytes, content_type)
    
    Returns: (body_bytes, content_type_header)
    """
    boundary = f"----PythonBoundary{uuid.uuid4().hex}"
    lines: list[bytes] = []
    
    for name, filename, data, content_type in fields:
        lines.append(f"--{boundary}".encode())
        if filename:
            lines.append(
                f'Content-Disposition: form-data; name="{name}"; filename="{filename}"'.encode()
            )
            if content_type:
                lines.append(f"Content-Type: {content_type}".encode())
        else:
            lines.append(f'Content-Disposition: form-data; name="{name}"'.encode())
        lines.append(b"")
        lines.append(data)
    
    lines.append(f"--{boundary}--".encode())
    lines.append(b"")
    
    body = b"\r\n".join(lines)
    header = f"multipart/form-data; boundary={boundary}"
    return body, header


def _post_multipart(url: str, api_key: str, fields: list[tuple[str, str, bytes, str | None]], timeout_s: int) -> dict:
    """Post multipart/form-data request."""
    body, content_type = _build_multipart(fields)
    
    req = Request(
        url,
        data=body,
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": content_type,
        },
        method="POST",
    )
    
    try:
        with urlopen(req, timeout=timeout_s) as resp:
            raw = resp.read()
    except HTTPError as e:
        raw = e.read()
        try:
            data = json.loads(raw.decode("utf-8", errors="replace"))
        except Exception:
            raise SystemExit(f"OpenAI HTTP {e.code}: {raw[:500]!r}")
        raise SystemExit(f"OpenAI HTTP {e.code}: {json.dumps(data, indent=2)[:1200]}")
    except Exception as e:
        raise SystemExit(f"request failed: {e}")
    
    try:
        return json.loads(raw)
    except Exception:
        raise SystemExit(f"invalid JSON response: {raw[:300]!r}")


def _write_index(out_dir: str, items: list[dict], input_images: list[str]) -> None:
    """Write HTML gallery."""
    html = [
        "<!doctype html>",
        "<meta charset='utf-8'>",
        "<meta name='viewport' content='width=device-width, initial-scale=1'>",
        "<title>openai-image-edit</title>",
        "<style>",
        "body{font-family:ui-sans-serif,system-ui;margin:24px;max-width:1200px}",
        ".inputs{display:flex;gap:12px;flex-wrap:wrap;margin-bottom:24px}",
        ".inputs img{width:150px;height:150px;object-fit:cover;border-radius:10px;border:2px solid #ccc}",
        ".card{display:grid;grid-template-columns:220px 1fr;gap:16px;align-items:start;margin:18px 0}",
        "img.output{width:220px;height:220px;object-fit:cover;border-radius:14px;box-shadow:0 14px 38px rgba(0,0,0,.14)}",
        "pre{white-space:pre-wrap;margin:0;background:#111;color:#eee;padding:12px 14px;border-radius:14px;line-height:1.35}",
        "h2{margin-top:32px}",
        "</style>",
        "<h1>openai-image-edit</h1>",
        "<h2>Input Images</h2>",
        "<div class='inputs'>",
    ]
    for img in input_images:
        html.append(f"<img src='{os.path.basename(img)}' title='{os.path.basename(img)}'>")
    html.append("</div>")
    html.append("<h2>Results</h2>")
    
    for it in items:
        html.append("<div class='card'>")
        html.append(f"<a href='{it['file']}'><img class='output' src='{it['file']}'></a>")
        html.append(f"<pre>{it['prompt']}</pre>")
        html.append("</div>")
    
    with open(os.path.join(out_dir, "index.html"), "w", encoding="utf-8") as f:
        f.write("\n".join(html))


def main(argv: list[str]) -> int:
    p = argparse.ArgumentParser(
        prog="openai-image-edit",
        description=f"Edit images via OpenAI {MODEL} API.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=f"""
Valid parameter values:
  --size          {", ".join(VALID_SIZES)}
  --quality       {", ".join(VALID_QUALITIES)}
  --background    {", ".join(VALID_BACKGROUNDS)}
  --format        {", ".join(VALID_OUTPUT_FORMATS)}
  --input-fidelity {", ".join(VALID_INPUT_FIDELITIES)}
  --compression   0-100 (only for jpeg/webp)

Examples:
  # Edit a single image
  {sys.argv[0]} --image photo.png --prompt "Add a hat to the person"

  # Combine multiple images
  {sys.argv[0]} --image item1.png --image item2.png --prompt "Arrange these items in a gift basket"

  # Use a mask for selective editing
  {sys.argv[0]} --image photo.png --mask mask.png --prompt "Replace the sky with sunset"

  # High fidelity for preserving facial features
  {sys.argv[0]} --image portrait.jpg --prompt "Add sunglasses" --input-fidelity high
""",
    )
    p.add_argument(
        "--image",
        action="append",
        required=True,
        metavar="PATH",
        help="input image (repeatable, up to 16 images)",
    )
    p.add_argument(
        "--prompt",
        required=True,
        help="description of the desired edit",
    )
    p.add_argument(
        "--mask",
        metavar="PATH",
        help="PNG mask where transparent areas indicate where to edit",
    )
    p.add_argument(
        "--count",
        type=int,
        default=1,
        help="number of variations to generate (default: 1)",
    )
    p.add_argument(
        "--size",
        default="auto",
        choices=VALID_SIZES,
        help="output dimensions (default: auto)",
    )
    p.add_argument(
        "--quality",
        default="high",
        choices=VALID_QUALITIES,
        help="image quality (default: high)",
    )
    p.add_argument(
        "--background",
        default=None,
        choices=VALID_BACKGROUNDS,
        help="background type (default: API default)",
    )
    p.add_argument(
        "--format",
        dest="output_format",
        default="png",
        choices=VALID_OUTPUT_FORMATS,
        help="output format (default: png)",
    )
    p.add_argument(
        "--compression",
        type=int,
        default=None,
        metavar="0-100",
        help="compression level for jpeg/webp (default: API default)",
    )
    p.add_argument(
        "--input-fidelity",
        default=None,
        choices=VALID_INPUT_FIDELITIES,
        help="how closely to match input style/features (default: low)",
    )
    p.add_argument(
        "--timeout",
        type=int,
        default=300,
        help="per-request timeout in seconds (default: 300)",
    )
    p.add_argument(
        "--out-dir",
        default=None,
        help="output directory",
    )
    p.add_argument(
        "--api-key",
        default=None,
        help="OpenAI API key (or set OPENAI_API_KEY)",
    )
    p.add_argument(
        "--dry-run",
        action="store_true",
        help="print request details without making API calls",
    )
    args = p.parse_args(argv)

    # Validate inputs
    if len(args.image) > 16:
        print("error: maximum 16 input images allowed", file=sys.stderr)
        return 2

    for img_path in args.image:
        if not os.path.isfile(img_path):
            print(f"error: image not found: {img_path}", file=sys.stderr)
            return 2

    if args.mask and not os.path.isfile(args.mask):
        print(f"error: mask not found: {args.mask}", file=sys.stderr)
        return 2

    if args.compression is not None:
        if not 0 <= args.compression <= 100:
            print("error: --compression must be 0-100", file=sys.stderr)
            return 2
        if args.output_format == "png":
            print("error: --compression is only valid for jpeg/webp", file=sys.stderr)
            return 2

    api_key = args.api_key or os.environ.get("OPENAI_API_KEY")
    if not api_key:
        print("error: missing OPENAI_API_KEY (or --api-key)", file=sys.stderr)
        return 2

    out_dir = args.out_dir or _default_out_dir()
    
    if args.dry_run:
        print(f"Model: {MODEL}")
        print(f"Images: {args.image}")
        print(f"Prompt: {args.prompt}")
        print(f"Mask: {args.mask}")
        print(f"Count: {args.count}")
        print(f"Size: {args.size}")
        print(f"Quality: {args.quality}")
        print(f"Format: {args.output_format}")
        print(f"Input fidelity: {args.input_fidelity}")
        print(f"out_dir={out_dir}")
        return 0

    os.makedirs(out_dir, exist_ok=True)

    # Copy input images to output dir for reference
    for img_path in args.image:
        img_name = os.path.basename(img_path)
        dest = os.path.join(out_dir, f"input-{img_name}")
        with open(img_path, "rb") as src, open(dest, "wb") as dst:
            dst.write(src.read())

    # Build multipart form fields
    fields: list[tuple[str, str, bytes, str | None]] = []
    
    # Add model
    fields.append(("model", "", MODEL.encode(), None))
    
    # Add prompt
    fields.append(("prompt", "", args.prompt.encode(), None))
    
    # Add images - use image[] for multiple images per API spec
    for img_path in args.image:
        img_name = os.path.basename(img_path)
        content_type = _get_content_type(img_path)
        with open(img_path, "rb") as f:
            img_data = f.read()
        fields.append(("image[]", img_name, img_data, content_type))
    
    # Add mask if provided
    if args.mask:
        mask_name = os.path.basename(args.mask)
        with open(args.mask, "rb") as f:
            mask_data = f.read()
        fields.append(("mask", mask_name, mask_data, "image/png"))
    
    # Add optional parameters
    fields.append(("n", "", str(args.count).encode(), None))
    fields.append(("size", "", args.size.encode(), None))
    fields.append(("quality", "", args.quality.encode(), None))
    fields.append(("output_format", "", args.output_format.encode(), None))
    
    if args.background:
        fields.append(("background", "", args.background.encode(), None))
    if args.compression is not None:
        fields.append(("output_compression", "", str(args.compression).encode(), None))
    if args.input_fidelity:
        fields.append(("input_fidelity", "", args.input_fidelity.encode(), None))

    url = _api_url()
    print(f"Sending request to {url}...")
    
    data = _post_multipart(url=url, api_key=api_key, fields=fields, timeout_s=args.timeout)
    
    results = data.get("data", [])
    if not results:
        raise SystemExit(f"unexpected response: {json.dumps(data, indent=2)[:1200]}")

    ext = _file_extension(args.output_format)
    items: list[dict] = []
    
    for i, result in enumerate(results, 1):
        b64 = result.get("b64_json")
        if not b64:
            print(f"warning: no image data in result {i}", file=sys.stderr)
            continue
        
        img_bytes = base64.b64decode(b64)
        filename = f"edited-{i:02d}-{_slug(args.prompt)}.{ext}"
        path = os.path.join(out_dir, filename)
        with open(path, "wb") as f:
            f.write(img_bytes)
        
        items.append({
            "file": filename,
            "prompt": args.prompt,
            "size": args.size,
            "quality": args.quality,
            "format": args.output_format,
        })
        print(f"wrote {filename}")

    # Save metadata
    metadata = {
        "model": MODEL,
        "prompt": args.prompt,
        "input_images": [os.path.basename(p) for p in args.image],
        "mask": os.path.basename(args.mask) if args.mask else None,
        "results": items,
    }
    with open(os.path.join(out_dir, "metadata.json"), "w", encoding="utf-8") as f:
        json.dump(metadata, f, indent=2, ensure_ascii=False)

    # Write HTML gallery
    input_copies = [os.path.join(out_dir, f"input-{os.path.basename(p)}") for p in args.image]
    _write_index(out_dir, items, input_copies)
    
    print(f"out_dir={out_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
