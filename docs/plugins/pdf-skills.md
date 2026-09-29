# pdf-skills

`pdf-skills` provides skills for shrinking PDFs, making scans searchable, and getting at the content of dynamic XFA forms (Adobe LiveCycle) that other viewers show only as a "Please wait..." placeholder.

## What It Does

- Compresses PDFs with Ghostscript and writes a `_komprimiert.pdf` copy next to the original.
- Adds an invisible OCR text layer to image-only scans with `ocrmypdf`, leaving the page images untouched.
- Extracts the field data of XFA forms into searchable Markdown.
- Converts XFA forms into normal PDFs with a full text layer by printing them from Adobe Reader to a virtual PDF printer.

## Skills

| Skill | Description |
| --- | --- |
| `/pdf-compressing` | Compresses a PDF with Ghostscript's `/ebook` preset and reports the size reduction. |
| `/pdf-ocr-adding` | Adds an OCR text layer to scans that cannot be searched, with verification and safe batch handling. |
| `/pdf-xfa-extracting` | Pulls the XML data packet out of XFA forms into Markdown, using a bundled standard-library Python script. |
| `/pdf-xfa-printing` | Walks the user through printing XFA forms to the PDFwriter virtual printer, then verifies and replaces the original. |

## Requirements

- `gs` (Ghostscript) and `pdftotext`/`pdfinfo` (Poppler)
- `ocrmypdf` and `tesseract-lang` for `pdf-ocr-adding`
- `python3` for `pdf-xfa-extracting`
- macOS, Adobe Reader, and `rwts-pdfwriter` for `pdf-xfa-printing`

## Installation

```bash
claude plugin install pdf-skills@ji-agent-skills --scope project
```
