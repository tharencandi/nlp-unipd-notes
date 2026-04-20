# Sentiment Analysis

## Utility

Sentiment Analysis is the task of identifying the emotional valence or subjective attitude in text. It is widely used in NLP and computational social science for modelling public opinion, emotional state, and attitudes.

- Determine the attitude of people towards:
  - A brand, law, product, or public figure
  - Useful as a large-scale substitute for opinion polling
- Supports downstream applications:
  - Summarising meetings
  - Detecting user frustration in dialogue systems
  - Finding emotionally charged parts of a conversation
  - Modelling user personality (e.g., extroversion) for adaptive conversational agents

---

## Lexicon-Based Sentiment Analysis

Lexicon-based sentiment analysis reduces task complexity by using predefined word lists annotated for sentiment. These lexicons are often grounded in psychological theories of emotion.

- Key idea: focus on **sentiment-bearing words** with known polarity or emotional score
- Does not require training data
- Works well for interpretable, domain-specific sentiment applications

---

## Theory of Emotions

Annotation schemes and lexicon design are guided by emotion theories:

1. **Ekman (1972)** — Six basic emotions:

   - Surprise, Happiness, Anger, Fear, Disgust, Sadness

2. **Plutchik’s Wheel of Emotions** — Eight emotions in opposing pairs:

   - Joy–Sadness, Trust–Disgust, Fear–Anger, Surprise–Anticipation

3. **VAD Dimensions**:

   - **Valence**: Pleasantness of the stimulus
   - **Arousal**: Intensity of the emotion
   - **Dominance**: Perceived control over the emotion

---

## Sentiment Lexicons

### Binary Lexicons:

- **General Inquirer (1967)** — 1915 positive, 2291 negative words
- **MPQA Subjectivity Lexicon (2005)** — includes subjective, positive, and negative words

### Emotion-Oriented Lexicons:

- **NRC Word-Emotion Association Lexicon (EmoLex, 2013)** — 14k words annotated for Plutchik emotions

### Multi-Category Lexicon:

- **LIWC (2007)** — 73 lexical categories, 2300+ words
  - Includes sentiment and cognitive/behavioral categories (e.g., inhibition, sadness, anger)

### Real-Valued Lexicons:

- **NRC VAD Lexicon (2018)** — assigns valence, arousal, and dominance scores to 20k words
  - Annotation via Best-Worst Scaling:
    $$
    \text{Score}(w) = \frac{\#_{\text{best}}}{T} - \frac{\#_{\text{worst}}}{T}
    $$

---

## Bag-of-Words Sentiment (BoW)

In long documents, a BoW model combined with lexicon lookup may suffice under the assumption that **positive and negative terms balance out**.

- Effective for:
  - Lengthy reviews, social media analysis, blogs
- Problems in short texts:
  - Negation (e.g., “not bad”)
  - Sarcasm, irony
  - Local compositionality

### Solutions:

- Use *n-grams* to capture modifiers and negations
- Parse **syntax trees** to detect negation-object relationships
- Preprocessing like lemmatization and POS tagging may improve accuracy

---

## Learning Lexicons

Lexicons can also be learned automatically from data, allowing domain adaptation and discovery of context-dependent sentiment words.

---

## Semantic Axis Projection

- Words are embedded in a high-dimensional space (e.g., word2vec, GloVe)
- Seed sets define sentiment poles:
  - $S^+$ = {good, excellent}, $S^-$ = {bad, terrible}
- Define vectors:
  $$
  V^+ = \frac{1}{n} \sum_{i=1}^n E(w_i^+), \quad V^- = \frac{1}{n} \sum_{i=1}^n E(w_i^-)
  $$

- Sentiment axis:
  $$
  V_{\text{axis}} = V^+ - V^-
  $$

- Scoring a new word $w$:
  $$
  \text{score}(w) = \cos(E(w), V_{\text{axis}}) = \frac{E(w) \cdot V_{\text{axis}}}{\|E(w)\| \|V_{\text{axis}}\|}
  $$

- Handles domain-specific adaptation
- Learns representations even for neutral or ambiguous terms

---

## Label Propagation

Graph-based lexicon induction using seed word labels and word similarity:

1. **Graph Construction**:

- given word embeddings, build a weighted graph by connecting edge word to k nearest neighbours with cosine similarity.

   - Nodes = words
   - Edges = top-$k$ most similar words (based on cosine or alternative metrics)
     - Alternative similarity signals:
       - Adjectives co-occurring with “and” (positive similarity)
       - Avoid “but” conjunctions (negative contrast)
       - Morphological negation
       - Thesaurus-based expansion

1. define a seed set
	1. positive and negative seed words.
2. **Propagation**:

   - Random walks from seed nodes
   - Probability of moving to a neighbor $\propto$ edge weight

1. **Scoring**:

	- polarity score for a seed set is proportional to the probability of a random walk from the seed set landing on that word.
   - Sentiment score = proportion of walks reaching a word from positive seeds
   -

   - Confidence to each score
	   - scores are influenced by initial seed set
	   - Repeat with varied seed sets for confidence estimates
	   - standard deviation of bootstrap sampled polarity scores gives a confidence measure.

**Applications**:

- Online opinion clustering
- Inducing sentiment for unseen or rare words

---

## Supervised Learning of Lexicons

Given labelled text (e.g., reviews with ratings), derive lexicon scores:

- Example: associate words with 1-star or 10-star reviews
- Compute:
  $$
  P(w \mid c) = \frac{\text{count}(w, c)}{\sum_{w'} \text{count}(w', c)}
  $$

- Normalise with:
  $$
  \text{PottsScore}(w) = \frac{P(w \mid c)}{\sum_{c'} P(w \mid c')}
  $$

- Allows fine-tuned lexicons for specific domains (e.g., movie reviews, finance)

---

## Using Lexicons as Features

Lexicon-derived features can be plugged into machine learning pipelines:

1. **Binary presence**:

   - 1 if any word in doc is in positive or negative lexicon

2. **Count-based**:

   - Number of lexicon-matching words per class

3. **Weighted sum**:

   - Sum of sentiment scores for all matching words

These features can be combined with:

- Bag-of-Words or TF-IDF
- Word embeddings
- Neural representations

---

## Entity-Based Sentiment Analysis

Assess the sentiment **towards a specific entity** rather than the full document.

1. Identify entity mentions using NER, dependency parsing, or Semantic Role Labelling.
2. Extract **contextualised embeddings** (e.g., BERT) for all mentions.
3. Compute average embedding $\bar{E}$ per entity.
4. Train regression models to map $\bar{E}$ to VAD scores.

   - As in Field & Tsvetkov (2019):
     - One model each for valence, arousal, and dominance

5. At inference:

   - Predict VAD for each entity mention
   - Aggregate across document for final score

Applications:

- Detecting stance toward political figures
- Tracking sentiment shifts in multi-character narratives

---

## Compositional Sentiment and Sentiment Treebank

Phrase- and sentence-level sentiment often requires **compositional models**, especially for negation, modifiers, and sarcasm.

- **Stanford Sentiment Treebank (SST)**:
  - Each node in a parse tree is annotated with sentiment (0–4)
  - Includes sub-phrases and clauses

- **Recursive Neural Networks (RNNs)**:
  - Sentiment of parent node is composed from child nodes:
    $$
    h_{\text{parent}} = \tanh(W \cdot [h_{\text{left}}; h_{\text{right}}] + b)
    $$

Benefits:

- Models fine-grained interactions
- Captures "not good" ≠ "good"
- Enables sentence-level and phrase-level sentiment parsing

Reference:

- [Socher et al., EMNLP 2013](https://nlp.stanford.edu/~socherr/EMNLP2013_RNTN.pdf)

---

## Summary

| Approach | Strengths | Weaknesses |
|----------|-----------|------------|
| Lexicon-based | Interpretable, fast, no training needed | No syntax, poor at irony |
| Semantic Axis | Unsupervised adaptation | Sensitive to seed choice |
| Label Propagation | Data-efficient, smooth | Graph construction needed |
| Supervised Lexicon | Data-driven, statistical | Needs annotated data |
| Entity Sentiment | Fine-grained, contextualised | Requires NER, coref |
| Compositional | Phrase-level semantics | Requires parses |
