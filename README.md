# Natural Language Processing - Course Notes

**Course**: Natural Language Processing  
**Institution**: Mathematics Department, University of Padova  
**Instructor**: Giovanni Da San Martino  
**Notes Author**: Tharen Emmanuel Candi  
**Repository**: https://github.com/tharencandi/nlp-unipd-notes.git

---

## 📚 Course Structure

### The Basics
1. NLP Home Page
2. Elements of Linguistics
3. Learning Tasks, Pre-processing and Data Collection
4. Text Processing

### Chapter 5 - Representation
- Simple Text Representations (Bag-of-Words and TF-IDF)
- Distributional Semantics and Matrix Representations
- Word Embeddings
- Sentence and Document Embeddings

### Chapter 6 - Language Models
- Introduction to Language Models
- N-Gram Language Model
- Neural Models - Feed-forward Networks
- Sequence Modelling - RNNs and LSTMs
- Encoder-Decoder Models
- Attention and Transformers
- BERT and Masked Language Models
- Generative Models and GPT
- LLM Evaluation and Scaling Laws

### Chapter 7 - Applications
- Coreference Resolution
- Discourse Coherence
- Information Retrieval and RAG
- Parsing
- Question Answering
- Semantic Role Labelling (SRL)
- Sentiment Analysis
- Sequence Labelling

---

## 🔧 Rendering to PDF

**Install Pandoc and LaTeX:**

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install pandoc texlive-latex-extra texlive-fonts-extra

# macOS
brew install pandoc
brew install --cask basictex
```

**Generate PDF:**

```bash
./render.sh
```

This will create `NLP-Course-Notes.pdf`

The script:
- Preserves original files (works on temporary copies)
- Converts Obsidian `[[wikilinks]]` to appropriate format
- Handles images and LaTeX math
- Generates professional PDF with table of contents and numbered sections

---

## 🌐 View Online with GitHub Pages

These notes are also available as an **interactive web documentation** via GitHub Pages!

**Live Site:** [Your GitHub Pages URL here]

The web version features:
- 🔍 Easy navigation with sidebar menu
- 📱 Mobile-responsive design
- 🔢 Rendered math equations
- 🎨 Clean, modern interface

### Setting up GitHub Pages:

1. Go to your repository settings on GitHub
2. Navigate to **Pages** (in the left sidebar)
3. Under **Source**, select the branch (usually `main` or `master`)
4. Click **Save**
5. Your site will be available at `https://[username].github.io/[repository-name]`

The site dynamically renders your markdown files, so any updates you push will automatically appear online!

---

## 📝 Notes Format

These notes are written in **Obsidian-flavored Markdown** with:
- WikiLinks for internal references: `[[Page Name]]`
- LaTeX math notation: `$equation$` and `$$block equation$$`
- Code blocks with syntax highlighting
- Tables and lists
- Embedded images

---

## 📖 Textbook References

- **Jurafsky & Martin** – *Speech and Language Processing* (3rd ed.)
- **Jacob Eisenstein** – *Natural Language Processing*, MIT Press (2019)

---

## 🤝 Contributing

Students are encouraged to:
- Add missing content
- Fix errors or typos
- Improve explanations
- Add examples and diagrams

Fork this repository, make your changes, and submit a pull request!

---

## 📄 License

These notes are provided for educational purposes for students of the NLP course at the University of Padova.

---

## ⚙️ Technical Details

### File Structure
```
NLP/
├── toc.md                   # Table of contents
├── 1 2 3 4 The Basics/      # Foundational concepts
├── 5 Representation/        # Text representation methods
├── 6 Language Models/       # Statistical & neural LMs
├── 7 Applications/          # NLP tasks
├── images/                  # Place images here
├── render.sh                # Pandoc PDF script
├── references.bib           # Bibliography (optional)
└── README.md                # This file
```

### Rendering Process

The `render.sh` script:
1. Creates a temporary directory
2. Processes all markdown files to convert Obsidian syntax
3. Runs Pandoc with optimized settings for academic content
4. Generates a professional PDF with table of contents and numbered sections
5. Cleans up temporary files

### Customization

Edit `render.sh` to customize:
- PDF filename
- Font sizes and margins
- Table of contents depth
- Document class and styling
- Header/footer content

---

**Last Updated**: April 2026
