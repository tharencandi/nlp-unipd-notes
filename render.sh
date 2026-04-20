#!/bin/bash
# Pandoc PDF Rendering Script for NLP Course Notes
# Converts Obsidian-style links and renders to PDF with clean formatting

set -e  # Exit on error

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

OUTPUT_PDF="NLP-Course-Notes-CS-2025.pdf"
TEMP_DIR=".render_temp"
IMAGES_DIR="images"

echo "=== NLP Course Notes - Pandoc PDF Renderer ==="
echo ""

# Check if pandoc is installed
if ! command -v pandoc &> /dev/null; then
    echo "ERROR: Pandoc is not installed."
    echo ""
    echo "Install with:"
    echo "  Ubuntu/Debian: sudo apt install pandoc texlive-xetex texlive-latex-extra"
    echo "  macOS: brew install pandoc && brew install --cask basictex"
    exit 1
fi

# Check Pandoc version
echo "Pandoc version: $(pandoc --version | head -n1)"
echo ""

# Create temporary directory for processed files
echo "[1/5] Creating temporary directory..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"

# Function to process a markdown file
process_file() {
    local src="$1"
    local dst="$2"
    
    # Create destination directory if needed
    mkdir -p "$(dirname "$dst")"
    
    # Calculate relative path to images directory
    local rel_path="${src#./}"
    local depth=$(echo "$rel_path" | grep -o "/" | wc -l)
    local img_prefix=""
    for ((i=0; i<depth; i++)); do
        img_prefix="../$img_prefix"
    done
    
    # Process the file with multiple passes for better handling
    # Pass 1: Convert Obsidian syntax with image width constraints and centering
    sed -e "s|!\[\[Pasted image \([^]]*\)\.png\]\]|![](${img_prefix}images/pasted-image-\1.png){width=90% fig-align=\"center\"}|g" \
        -e "s|!\[\[Pasted image \([^]]*\)\.jpg\]\]|![](${img_prefix}images/pasted-image-\1.jpg){width=90% fig-align=\"center\"}|g" \
        -e 's/\[\[\([^]|]*\)|\([^]]*\)\]\]/\2/g' \
        -e 's/\[\[\([^]]*\)\]\]/\1/g' \
        -e 's/^---$/\*\*\*/g' \
        "$src" > "$dst"
}

# Process all markdown files
echo "[2/5] Copying and processing markdown files..."
find . -name "*.md" -type f | while read -r file; do
    if [[ "$file" != *"$TEMP_DIR"* ]] && [[ "$file" != "./README.md" ]] && \
       [[ "$file" != "./RENDERING_COMPARISON.md" ]] && [[ "$file" != "./IMAGE_LIST.md" ]]; then
        relative_path="${file#./}"
        process_file "$file" "$TEMP_DIR/$relative_path"
        echo "  Processed: $relative_path"
    fi
done

# Copy index.qmd if it exists (Pandoc can handle .qmd files)
if [ -f "index.qmd" ]; then
    echo "  Copying: index.qmd"
    cp "index.qmd" "$TEMP_DIR/"
fi

# Copy images directory if it exists
if [ -d "$IMAGES_DIR" ]; then
    echo "[3/5] Copying images..."
    cp -r "$IMAGES_DIR" "$TEMP_DIR/"
else
    echo "[3/5] No images directory found (skipping)..."
    mkdir -p "$TEMP_DIR/$IMAGES_DIR"
fi

# Create metadata file for Pandoc
echo "[4/5] Creating metadata..."
cat > "$TEMP_DIR/metadata.yaml" << 'EOF'
---
title: "Natural Language Processing - Course Notes"
subtitle: "University of Padova, Mathematics Department"
author: "Tharen Emmanuel Candi"
date: "2026"
---

EOF

# Build the file list in order
echo "[5/5] Rendering PDF with Pandoc..."
echo ""

cd "$TEMP_DIR"

# Create ordered list of files
pandoc metadata.yaml \
    "0 Preface.md" \
    "1 2 3 4 The Basics/2 Elements of Linguistics.md" \
    "1 2 3 4 The Basics/3 Learning Tasks, Pre-processing and Data Collection.md" \
    "1 2 3 4 The Basics/4 Text-Processing.md" \
    "5 Representation/5 - 1 Simple Text Representations (Bag-of-Words and TF-IDF).md" \
    "5 Representation/5 - 2 Distributional Semantics and Matrix representations.md" \
    "5 Representation/5 - 3 Word Embeddings.md" \
    "5 Representation/5 - 4 Sentence and Document Embeddings.md" \
    "6 Language Models/6 - 1 Introduction to Language Models.md" \
    "6 Language Models/6 - 2 N-Gram Language Model.md" \
    "6 Language Models/6 - 3 Neural Models - Introducing the Feed-forward Network for language.md" \
    "6 Language Models/6 - 4 Sequence Modelling  - RNNs and LSTMs.md" \
    "6 Language Models/6 - 5 Encoder Decoders.md" \
    "6 Language Models/6 - 6 Attention and Transformers.md" \
    "6 Language Models/6 - 7 BERT and Masked LLMs.md" \
    "6 Language Models/6 - 8 Generative Models (Decoder Only), Prompts and GPT.md" \
    "6 Language Models/6 - 9 LLM Evaluation and Scaling Laws.md" \
    "7 Applications/Coreference Resolution.md" \
    "7 Applications/Discourse Coherence.md" \
    "7 Applications/Information Retrieval and Retrieval-Augmented Generation (RAG).md" \
    "7 Applications/Parsing.md" \
    "7 Applications/Question Answering.md" \
    "7 Applications/Semantic Role Labelling (SRL).md" \
    "7 Applications/Sentiment Analysis.md" \
    "7 Applications/Sequence Labelling.md" \
    -o "../$OUTPUT_PDF" \
    --from gfm+wikilinks_title_after_pipe \
    --wrap=auto \
    --resource-path=".:./images" \
    --pdf-engine=xelatex \
    --toc \
    --toc-depth=3 \
    --number-sections \
    -V geometry:margin=1in \
    -V fontsize=11pt \
    -V documentclass=report \
    -V linkcolor=blue \
    -V urlcolor=blue \
    -V toccolor=black \
    -V tables=true \
    --highlight-style=tango \
    -V colorlinks=true \
    -V header-includes="\usepackage{longtable,booktabs,array}" \
    -V header-includes="\usepackage{calc}" \
    -V header-includes="\usepackage{caption}" \
    -V header-includes="\captionsetup[table]{skip=5pt}" \
    -V header-includes="\usepackage{float}" \
    -V header-includes="\makeatletter" \
    -V header-includes="\def\fps@figure{H}" \
    -V header-includes="\makeatother" \
    -V header-includes="\let\origfigure\figure" \
    -V header-includes="\let\endorigfigure\endfigure" \
    -V header-includes="\renewenvironment{figure}[1][2]{\expandafter\origfigure\expandafter[H]\centering}{\endorigfigure}" \
    2>&1 | tee ../render.log

cd ..

# Check if PDF was created
if [ -f "$OUTPUT_PDF" ]; then
    echo ""
    echo "=== SUCCESS ==="
    echo "PDF generated: $OUTPUT_PDF"
    echo "Log saved to: render.log"
    echo ""
    
    # Clean up temp directory
    echo "Cleaning up temporary files..."
    rm -rf "$TEMP_DIR"
    echo "Done!"
else
    echo ""
    echo "=== ERROR ==="
    echo "PDF generation failed. Check render.log for details."
    echo "Temporary files kept in: $TEMP_DIR"
    exit 1
fi
