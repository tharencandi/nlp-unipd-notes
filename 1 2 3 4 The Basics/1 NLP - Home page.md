# Natural Language Processing

*"Methods for making human language accessible to computers."*

**Instructor**: Giovanni Da San Martino
**Department**: Mathematics, University of Padova
**Email**: giovanni.dasanmartino@unipd.it
**Course Page**: [Moodle](https://elearning.unipd.it/math/course/view.php?id=11959)

**Author of these notes:** *Tharen Emmanuel Candi*
**Repo**: https://github.com/tharencandi/nlp-unipd-notes.git

## Course Information

**Labs**: 10 points (5 labs; top 4) (or RAG QA project + 3 page report due 3 days before the exam)
**Exam**:

- Coding exercise
  - Does the code do what the statement says? If not, fix it
  - Or just explain
- Open and multiple choice questions
  - Refer to book coverage not just slides
  - Example question: What is semantic role labelling? List the 5 elements of linguistic analysis and describe them briefly.

## Overview

### The Basics

- [[1 NLP - Home page]]
- [[2 Elements of Linguistics]]
- [[3 Learning Tasks, Pre-processing and Data Collection]]
- [[4 Text-Processing]]

### Chapter 5 - Representation

- [[5 - 1 Simple Text Representations (Bag-of-Words and TF-IDF)]]
- [[5 - 2 Distributional Semantics and Matrix representations]]
- [[5 - 3 Word Embeddings]]
- [[5 - 4 Sentence and Document Embeddings]]

### Chapter 6 - Language Models

- [[6 - 1 Introduction to Language Models]]
- [[6 - 2 N-Gram Language Model]]
- [[6 - 3 Neural Models - Introducing the Feed-forward Network for language]]
- [[6 - 4 Sequence Modelling  - RNNs and LSTMs]]
- [[6 - 5 Encoder Decoders]]
- [[6 - 6 Attention and Transformers]]
- [[6 - 7 BERT and Masked LLMs]]
- [[6 - 8 Generative Models (Decoder Only), Prompts and GPT]]
- [[6 - 9 LLM Evaluation and Scaling Laws]]

### Chapter 7 - Applications

- [[Coreference Resolution]]
- [[Discourse Coherence]]
- [[Information Retrieval and Retrieval-Augmented Generation (RAG)]]
- [[Parsing]]
- [[Question Answering]]
- [[Semantic Role Labelling (SRL)]]
- [[Sentiment Analysis]]
- [[Sequence Labelling]]

---

**Applications**:

1. **Analysis**: sentiment analysis, text classification, paraphrasing, entailment, authorship attribution, topic modelling, QA, fake news/reviews detection
2. **Generation**: machine translation, automatic journalism, chatbots, summarization
3. **GenAI**: Copilot (text→code), DALL·E/Midjourney (text→image), Pika/Sora (text→video)

**Related Fields**:

- **Linguistics**: language as subject
- **Ethics**: bias, privacy, access
- **Comp. Social Science**: NLP as a research tool
- **IR**: ranking, retrieval

**ML for NLP**:

- ML enables NLP, but text is discrete → harder optimization (vs. images). Issues: rare/slang terms, ungrammatical inputs, compositional meaning.

**Traditional NLP (Pipeline-based)**:

- Preprocessing: tokenization, stemming, stopword removal, POS tagging, dependency parsing, coreference resolution. Requires expert knowledge.

**End-to-End Deep Learning**:

- Deep models (e.g. BERT) skip most preprocessing. Input = tokenized text, Output = label or text. Needs large data.
- Use **pretrained models** (BERT, XLNet, GPT-x) via fine-tuning or prompt engineering.

## Textbooks

- **Jurafsky & Martin** – _Speech and Language Processing_ (3rd ed.)
- **Jacob Eisenstein** – _Natural Language Processing_, MIT Press (2019)
