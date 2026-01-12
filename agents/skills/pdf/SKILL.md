---
name: pdf
description: Comprehensive PDF manipulation toolkit for extracting text and tables, creating new PDFs, merging/splitting documents, and handling forms. When Claude needs to fill in a PDF form or programmatically process, generate, or analyze PDF documents at scale.
license: Proprietary. LICENSE.txt has complete terms
---

# PDF Processing Guide

## Overview

This guide prioritizes **native CLI tools** (poppler) for speed and simplicity. Use Python only when CLI tools can't handle the task (table extraction, PDF creation, merging/splitting, form filling).

## Quick Decision Tree

```
What do you need to do?
│
├─ Extract text → pdftotext (CLI)
├─ Get PDF info → pdfinfo (CLI)
├─ Convert to images → pdftoppm (CLI)
├─ Extract images → pdfimages (CLI)
├─ Extract tables → pdfplumber (Python)
├─ Merge/split PDFs → pypdf (Python)
├─ Create new PDFs → reportlab (Python)
├─ Fill form fields → see forms.md
└─ OCR scanned PDFs → pytesseract (Python)
```

---

## CLI Tools (Preferred)

### poppler-utils

Installed via `brew install poppler`. Fast, reliable, no dependencies.

#### pdftotext - Extract Text
```bash
# Basic extraction
pdftotext input.pdf output.txt

# Preserve layout (columns, spacing)
pdftotext -layout input.pdf output.txt

# Extract specific pages (1-indexed)
pdftotext -f 1 -l 5 input.pdf output.txt

# Output to stdout
pdftotext input.pdf -

# Raw text (no page breaks)
pdftotext -raw input.pdf output.txt

# Get bounding box coordinates (XML output)
pdftotext -bbox-layout input.pdf output.xml
```

#### pdfinfo - Get Metadata
```bash
# Basic info (pages, size, dates, etc.)
pdfinfo input.pdf

# Check if encrypted
pdfinfo input.pdf | grep -i encrypted
```

#### pdftoppm - Convert to Images
```bash
# Convert all pages to PNG
pdftoppm -png input.pdf output_prefix
# Creates: output_prefix-1.png, output_prefix-2.png, ...

# High resolution (300 DPI)
pdftoppm -png -r 300 input.pdf output_prefix

# Single page (page 1)
pdftoppm -png -f 1 -l 1 input.pdf page1

# JPEG with quality
pdftoppm -jpeg -jpegopt quality=85 input.pdf output_prefix
```

#### pdfimages - Extract Embedded Images
```bash
# Extract all images (JPEG format)
pdfimages -j input.pdf output_prefix
# Creates: output_prefix-000.jpg, output_prefix-001.jpg, ...

# List images without extracting
pdfimages -list input.pdf

# Extract in original format
pdfimages -all input.pdf output_prefix
```

---

## Python (When CLI Isn't Enough)

### pdfplumber - Table Extraction

CLI tools can't reliably extract tables. Use pdfplumber.

```python
import pdfplumber

with pdfplumber.open("document.pdf") as pdf:
    for page in pdf.pages:
        # Extract tables as list of lists
        tables = page.extract_tables()
        for table in tables:
            for row in table:
                print(row)
```

#### Export Tables to CSV/Excel
```python
import pdfplumber
import pandas as pd

with pdfplumber.open("document.pdf") as pdf:
    all_tables = []
    for page in pdf.pages:
        tables = page.extract_tables()
        for table in tables:
            if table and len(table) > 1:
                df = pd.DataFrame(table[1:], columns=table[0])
                all_tables.append(df)

    if all_tables:
        combined = pd.concat(all_tables, ignore_index=True)
        combined.to_csv("tables.csv", index=False)
```

### pypdf - Merge/Split PDFs

```python
from pypdf import PdfReader, PdfWriter

# Merge multiple PDFs
writer = PdfWriter()
for pdf_file in ["doc1.pdf", "doc2.pdf", "doc3.pdf"]:
    reader = PdfReader(pdf_file)
    for page in reader.pages:
        writer.add_page(page)

with open("merged.pdf", "wb") as f:
    writer.write(f)
```

```python
# Split: extract pages 1-5
from pypdf import PdfReader, PdfWriter

reader = PdfReader("input.pdf")
writer = PdfWriter()

for i in range(5):  # Pages 0-4 (first 5 pages)
    writer.add_page(reader.pages[i])

with open("first_5_pages.pdf", "wb") as f:
    writer.write(f)
```

### reportlab - Create PDFs

For generating new PDFs from scratch.

```python
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas

c = canvas.Canvas("output.pdf", pagesize=letter)
width, height = letter

c.drawString(100, height - 100, "Hello World!")
c.save()
```

#### Multi-page Reports
```python
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet

doc = SimpleDocTemplate("report.pdf", pagesize=letter)
styles = getSampleStyleSheet()
story = []

story.append(Paragraph("Report Title", styles['Title']))
story.append(Spacer(1, 12))
story.append(Paragraph("Body text here...", styles['Normal']))

doc.build(story)
```

### OCR Scanned PDFs

For PDFs that are just images (no text layer).

```python
import pytesseract
from pdf2image import convert_from_path

images = convert_from_path('scanned.pdf')
text = ""
for i, image in enumerate(images):
    text += f"--- Page {i+1} ---\n"
    text += pytesseract.image_to_string(image)
    text += "\n\n"

print(text)
```

---

## Quick Reference

| Task | Tool | Command/Example |
|------|------|-----------------|
| Extract text | pdftotext | `pdftotext input.pdf output.txt` |
| Extract text (layout) | pdftotext | `pdftotext -layout input.pdf output.txt` |
| PDF info | pdfinfo | `pdfinfo input.pdf` |
| Convert to PNG | pdftoppm | `pdftoppm -png -r 300 input.pdf out` |
| Extract images | pdfimages | `pdfimages -j input.pdf out` |
| Extract tables | pdfplumber | Python (see above) |
| Merge PDFs | pypdf | Python (see above) |
| Split PDFs | pypdf | Python (see above) |
| Create PDFs | reportlab | Python (see above) |
| OCR scanned | pytesseract | Python (see above) |
| Fill forms | — | See forms.md |

---

## Next Steps

- **Form filling**: See forms.md for detailed instructions
- **Advanced features**: See reference.md for pypdfium2, pdf-lib (JS), advanced pdfplumber
- **Troubleshooting**: See reference.md for handling encrypted/corrupted PDFs
