---
name: pdf-xfa-extracting
description: This skill should be used when a PDF shows only a "Please wait — if this message is not eventually replaced…" placeholder instead of its content, or when the user asks to "read this PDF", "make this form readable", "das PDF zeigt nichts an", "Acrobat-PDF konvertieren", "XFA extrahieren", or "run pdf-xfa-extracting". Typical for forms from German banks and public authorities (Sparkasse/OSPlus, LBS, insurers). Extracts the hidden XFA data into searchable Markdown.
---

# pdf-xfa-extracting

Dynamic XFA forms (Adobe LiveCycle) carry their real content as an XML packet inside a compressed
stream. The single visible page is only a placeholder telling the reader to install Adobe Reader.
**No viewer other than Adobe Reader renders these** — Preview, Chrome, Firefox/pdf.js and MuPDF all
show the placeholder. So don't try to convert them by printing or re-rendering; read the data
directly.

## Workflow

### 1. Confirm it is actually XFA

```bash
pdftotext -f 1 -l 1 "datei.pdf" - | head -3        # → "Please wait..."
strings "datei.pdf" | grep -c NeedsRendering       # → ≥1
```

`/NeedsRendering` marks it dynamic. A page count of 1 on a document that should be longer is
another tell. Note that `grep XFA` on the raw file usually finds nothing — the catalog sits in a
compressed object stream.

### 2. Extract

```bash
python3 scripts/xfa_extract.py "datei.pdf" [...] -o _extrahiert
```

Writes one Markdown file per PDF. Options:

- `--bilder` also writes embedded images. Off by default because they are almost always the
  sender's logos and stock photography, easily hundreds of KB of clutter.
- `--roh` keeps every field. By default a noise filter drops layout, institution master data and
  debug fields, which are roughly two thirds of the payload.

Requires only the standard library, no dependencies.

### 3. Read the result, then summarise

The output is a field tree, not prose — field names in caps, no layout. Do not hand the raw dump to
the user. Read it and write up what matters, and put the summary where the user's notes already track
that topic rather than in a fresh orphan note.

Useful anchors in Sparkasse/OSPlus forms: `PMSDATA` holds the payload, `FINANZBAUSTEIN/_1`, `_2`
etc. the individual loan tranches, `KOSTEN/ADD` the itemised costs, `VEREINBARUNG/BV/TEXT*` the
free-text clauses (often the most interesting part), `BERATER*` the responsible clerk.

## Notes

- **Cross-check the numbers against what the user's notes already record.** These extracts are the
  authoritative contract data and have repeatedly differed slightly from earlier offer summaries.
  Report the deltas rather than silently overwriting.
- **Watch for template residue.** Unused form slots keep placeholder values such as `999.999,00`
  or dummy entries for a third or fourth loan tranche. Check the count field (`KRANZAHL*`) before
  treating such an entry as real.
- **Fields can be multi-line.** A value continues on the following indented lines without repeating
  the field name. `SICHERUNGSGEBER_NAME` held two borrowers this way, and reading only the first
  line produced a wrong note claiming the document named just one of them. When a field could carry
  several parties, read to the end of the block before summarising.
- **Watch for preview versions.** `FORMULAR_VERARB_ART: VORANSICHT` means the file is a draft; it
  may name only one of several parties. Find the operative version before acting on it.
- Keep the extracts next to the source PDFs (`_extrahiert/` beside them), so they stay searchable
  in the notes app and the link back to the original is obvious.
