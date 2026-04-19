In contrast to Semantic Role Labeling, where roles are assigned to **spans of text relative to a predicate**, **sequence labelling** assigns **discrete labels to individual elements** in a sequence, typically tokens or characters.

The task is to assign a label $y_t$ to each element $x_t$ in a sequence $x = (x_1, ..., x_T)$.

Sequence labelling is a fundamental abstraction in NLP, and it appears in many canonical tasks.

### Examples of Sequence Labelling Tasks

Sequence labelling occurs in a wide range of linguistic annotation tasks, including:

- **Named Entity Recognition (NER)**  
  Label each token with BIO tags indicating named entities and their type.

- **Aspect-Based Sentiment Analysis**  
  Identify which parts of a sentence express sentiment, and assign sentiment polarity labels to aspects (e.g., “food”: positive, “service”: negative).

- **Part-of-Speech (POS) Tagging**  
  Assign grammatical category labels (e.g., Noun, Verb, Adjective) to each token in a sentence.

Additional:

- **Tokenization**  
  Especially in languages like Chinese, where word boundaries are not explicit.  
  A common approach is to predict a **Start/NonStart** tag for each character.

- **Code-Switching Detection**  
  Detecting points where speakers switch between languages in multilingual contexts.  
  Each token may be labelled with the language it belongs to.

- **Dialogue Act Classification**  
  Classify each utterance in a conversation as one of: statement, question, command, backchannel, etc.  
  This supports understanding of the communicative function of each turn.
### Approaches to Sequence Labelling

Sequence labelling models can be broadly categorised into **local** and **global** approaches, depending on whether they predict labels independently or jointly.

#### Local Search

- The task is decomposed into a series of **independent classification problems**.  
- A classifier is trained to assign a label to each token based on local context (e.g., using a fixed-size window or contextual embedding).
- Example:  
  Predict the POS tag for each token based on surrounding words and its own features.

This approach is simple and efficient but may suffer from **label inconsistency** (e.g., predicting I-ORG following B-PER).

#### Global Search

- Formulated as a **structured prediction problem**, where the goal is to find the most likely sequence of labels over the entire input.
- This requires solving a **combinatorial optimisation problem** over all possible label sequences.
- Algorithms such as **Viterbi decoding**, **Conditional Random Fields (CRFs)**, and **structured perceptrons** are used.

Global search allows the model to enforce **label dependencies** and **structural constraints**, leading to better performance in tasks with strong sequential structure (e.g., BIO tagging).


## Named Entity Recognition (NER)

Named Entity Recognition (NER) is the task of identifying **proper names** or **specific expressions** in text and classifying them into a predefined set of semantic categories.

The most universally accepted NER types include:
- **Person** (e.g., “Angela Merkel”)
- **Location** (e.g., “Heathrow”, “Europe”)
- **Organisation** (e.g., “United Nations”, “MTV”)

Other common entity types include:
- **Date/Time expressions** (e.g., “3 p.m.”, “January 2020”)
- **Quantities and Measures** (e.g., “5 kg”, “20 percent”, “$100”)
- **Identifiers** (e.g., email addresses, IP addresses, URLs)
- **Domain-specific entities**, such as drug names, genes, or product codes in biomedical or financial texts.
### Ambiguities in Category Definition

Despite seemingly clear-cut categories, many cases introduce **semantic grey areas** where classification becomes context-sensitive:

- **Organisation vs Location**:  
  - “England won the World Cup” → *England* as an organisation (national team)  
  - “The World Cup took place in England” → *England* as a geographic location

- **Company vs Artefact**:  
  - “Shares in MTV rose” → *MTV* as a company  
  - “We were watching MTV” → *MTV* as a broadcast artefact

- **Location vs Organisation**:  
  - “She met him at Heathrow” → *Heathrow* as a location  
  - “The Heathrow authorities issued a statement” → *Heathrow* as an organisation

NER systems must **disambiguate** such cases based on context, which is a key challenge for robust entity recognition.

### Named Entity Labels in spaCy

Popular NLP libraries such as **spaCy** define their own extended label sets. These include:

- **PERSON** – people, including fictional  
- **ORG** – companies, agencies, institutions  
- **GPE** – geopolitical entities (countries, cities, states)  
- **LOC** – non-GPE locations (mountains, bodies of water)  
- **FAC** – facilities (e.g., buildings, airports)  
- **PRODUCT**, **EVENT**, **WORK_OF_ART**, **LAW**, **LANGUAGE**  
- **DATE**, **TIME**, **PERCENT**, **MONEY**, **QUANTITY**, **ORDINAL**, **CARDINAL**

These finer-grained labels improve expressivity but often increase annotation difficulty and classification ambiguity.
### BIO Encoding for Sequence Labeling

NER is typically cast as a **sequence labeling problem**, where each token is assigned a tag using the **BIO format**:

- **B-XXX**: beginning of an entity of type XXX  
- **I-XXX**: inside an entity  
- **O**: outside (not part of any entity)

Example (BIO-tagged sentence):

> The (O) United (B-COUNTRY) States (I-COUNTRY) of (I-COUNTRY) America (I-COUNTRY) played (O) soccer (O)

This structure supports contiguous entity detection and is suitable for input into neural sequence models.

BIO can also be extended to include **E (end)** or **S (singleton)** tags in more advanced systems, but B-I-O is the most widely used baseline.
### Subtasks of NER

NER can be divided into two subtasks:

1. **Boundary detection**: locate the span of text that constitutes an entity  
2. **Entity classification**: determine the type of the identified span

These may be performed jointly (in end-to-end systems) or sequentially (in pipeline architectures).
### Approaches to NER

#### Traditional Approaches

Early systems used hand-crafted features with **window-based classifiers**, similar to those used in POS tagging.

#### Neural Approaches

Modern systems rely on:
- **Recurrent Neural Networks (RNNs)** or **BiLSTMs**
	- See [[##Named Entity Recognition with MLLMs|NER with MLLMs]]
- **CRF decoding** for enforcing label constraints (e.g., I-ORG cannot follow B-PER)
- **Transformer-based encoders** (e.g., BERT), often fine-tuned on NER datasets

### Common Features (for non-neural models)

- **Orthographic and lexical features**:
  - Capitalisation (initial capital, all caps, title case)
  - Internal punctuation (e.g., “I.B.M.”)
  - Apostrophes (e.g., “O’Brien”)
  - Word shape and suffixes

- **POS tags**, **lemmas**, **stems**  
- **Gazetteers**: dictionaries of known entities (e.g., city names, company lists)  
- **Word frequency**: rare words are more likely to be named entities

These features can be encoded directly or used as inputs to statistical models.



## POS - Part of Speech labelling

A part of speech is a category of words that play similar roles within the syntactic structure of a sentence.

open class: 
- adj,adv,intj,noun,propn,verb
- varies speaker to speaker 

closed class: 
- adposition; auxiliary verb;conjunction;determinier;cardinal numbers;pronounms
- all speakers share the same words

There are canonical "tagsets" (for english mostly) that have been used in NLP. 

- Penn Treebank POS tags (Marcus et al. “Building a large annotated corpus of English:The Penntreebank”. Computational Linguistics, 19(2):313–330, 1993.)
- Other tagsets: Universal Dependencies (de Marneffe et al.. “Universal Dependencies”. Computational Linguistics, 47(2):255–308, 2021.)


### Part-of-Speech (PoS) Tagging

Part-of-speech tagging is the process of assigning a **syntactic category** (e.g., noun, verb, adjective) to each word in a sentence. It is a canonical example of a **sequence labelling task**, where each word $x_i$ is paired with a corresponding tag $y_i$ from a fixed inventory of part-of-speech labels.

Each word is labelled in context, as many words have multiple potential tags. The model must use contextual cues to resolve ambiguity.

### PoS as Disambiguation

PoS tagging is primarily a **disambiguation problem**, as many words are lexically ambiguous across parts of speech. A word like *back* can take on several syntactic functions depending on usage:

- “Earnings growth took a **back/JJ** seat.” → *adjective*
- “A small building in the **back/NN**.” → *noun*
- “Dave began to **back/VB** toward the door.” → *base verb*
- “Enable the country to buy **back/RP** debt.” → *particle*
- “I was twenty-one **back/RB** then.” → *adverb*

While the **majority of word types** (around 85%) are unambiguous and appear with a single PoS tag in annotated corpora, **word tokens** in real usage are frequently ambiguous. In typical running text, about **55% of tokens** are ambiguous with respect to PoS.

### Baseline Accuracy and State of the Art

A traditional baseline is the **majority class assignment**, where each word is assigned the most common tag it holds in the training corpus. This achieves high performance—approximately **92.34% accuracy** on the Wall Street Journal portion of the Penn Treebank when evaluated with Universal Dependencies.

However, this baseline fails to generalize to unseen words or context-driven disambiguation.

Modern PoS tagging systems, typically based on **neural architectures** such as BiLSTM or Transformer encoders, have achieved **human-level accuracy** on standard benchmarks. These models capture rich context through learned embeddings and attention, substantially outperforming symbolic or rule-based taggers.


### Aproaches

Rule based
- start with a dictionary
- assigned all possible tags to word from the dictionary
- write rules manually to selectivley remove tags
- with enough rules, this leaves the correct tag for each word

## Markov Chains

Markov chains are used to compute the probability of sequences of events under the **Markov assumption**:

$$
P(q_i = a \mid q_1, q_2, ..., q_{i-1}) = P(q_i = a \mid q_{i-1})
$$

That is, the probability of the current state depends **only on the previous state**, not the full sequence history. This assumption simplifies computation in sequence models.

- A Markov chain is a directed graph where **nodes** represent states and **edges** represent state transitions.
- **Edges are labeled with probabilities**, defining the likelihood of moving from one state to another.
- A **starting probability distribution** (initial state distribution) is also needed to describe the system.
- The **probability of a sequence of states** is the product of the transition probabilities along its path:
  $$
  P(q_1, q_2, ..., q_n) = P(q_1) \cdot P(q_2 \mid q_1) \cdot P(q_3 \mid q_2) \cdot \dots \cdot P(q_n \mid q_{n-1})
  $$

---

## Hidden Markov Models (HMMs) for PoS Tagging

In PoS tagging, we do **not observe the tags directly** — they are hidden. Instead, we observe a sequence of **words**, and we aim to infer the **most likely tag sequence** that generated them. HMMs extend Markov chains by introducing **emissions**: each hidden state emits an observable symbol with some probability.

This means:
- Each word is assumed to be **generated by a hidden tag**.
- The goal is to infer the most probable sequence of hidden states (tags) that could have produced the observed word sequence.

For every token in a sentence:
- There is an **emission probability**: $P(w_i \mid t_i)$  
  The probability that a tag $t_i$ emits word $w_i$.
- There is a **transition probability**: $P(t_i \mid t_{i-1})$  
  The probability that tag $t_i$ follows tag $t_{i-1}$.

---

### Components of the HMM

Let $Q = q_1, ..., q_N$ be the set of possible tags (hidden states).

- **Transition matrix** $A = [a_{ij}]$, where:
  $$
  a_{ij} = P(q_j \mid q_i)
  $$
  represents the probability of transitioning from state $i$ to state $j$.  
  Each row in $A$ must sum to 1:
  $$
  \sum_{j=1}^N a_{ij} = 1
  $$

- **Emission probabilities** $B = [b_i(o_t)]$, where:
  $$
  b_i(o_t) = P(o_t \mid q_i)
  $$
  is the probability of generating word $o_t$ from state $q_i$.  
  The vocabulary is denoted $V = \{v_1, ..., v_V\}$.

- **Initial state distribution** $\pi = [\pi_1, ..., \pi_N]$, where:
  $$
  \pi_i = P(q_i)
  $$
  is the probability of starting in state $q_i$.

---

### Why Use the Transition Matrix $A$?

The **Markov assumption** is the reason for modeling tag transitions with a matrix $A$:  
Each tag depends only on the previous tag, so transition probabilities between tag pairs are sufficient to describe the full tag sequence likelihood.

Similarly, the **emission probability** depends **only on the current tag** (not previous tags or words). This greatly simplifies modeling.

---

### Estimating A and B from Data

Using a labeled corpus (e.g., treebank), we can estimate:

- **Transition probabilities**:
  $$
  A = P(t_i \mid t_{i-1}) = \frac{C(t_{i-1}, t_i)}{C(t_{i-1})}
  $$

- **Emission probabilities**:
  $$
  B = P(w_i \mid t_i) = \frac{C(t_i, w_i)}{C(t_i)}
  $$

Where $C(t_i, w_i)$ is the count of word $w_i$ tagged with $t_i$ in the training data.

---

## Decoding: Finding the Best Tag Sequence

To find the most probable sequence of tags given a word sequence $w_1, ..., w_n$, we want:

$$
\arg\max_{t_1...t_n} P(t_1, ..., t_n \mid w_1, ..., w_n)
$$

Using Bayes' rule:

$$
\arg\max_{t_1...t_n} P(w_1, ..., w_n \mid t_1, ..., t_n) \cdot P(t_1, ..., t_n)
$$

Under the HMM assumptions:
- $P(t_i \mid t_{i-1})$ (transition depends only on previous tag)
- $P(w_i \mid t_i)$ (emission depends only on current tag)

We obtain the simplified scoring function:

$$
\arg\max_{t_1...t_n} \prod_{i=1}^n P(w_i \mid t_i) \cdot P(t_i \mid t_{i-1})
$$

This product form allows efficient decoding using **dynamic programming**.

---

## Viterbi Algorithm

The **Viterbi algorithm** finds the tag sequence that **maximizes the above expression**.

It builds a **matrix of tag probabilities**, where each entry records the probability of the best path to that tag at that word position. For each cell:
- Consider all incoming transitions from the previous column (tags)
- Keep the **highest-scoring** path only (prune the rest)
- Store backpointers to reconstruct the optimal sequence

This algorithm dramatically reduces the search space compared to brute-force enumeration.

---

## Limitations of HMM PoS Taggers

- **Unknown words**:  
  HMMs rely on count-based probabilities. If a word was never seen in training, its emission probability is zero. This leads to poor generalization on out-of-vocabulary (OOV) words.

- **One-tag context**:  
  The Markov assumption limits modeling to **first-order** tag dependencies. More expressive models (e.g., CRFs, neural taggers) can incorporate longer-range context.

- **Hard assumptions**:  
  Emission independence is often unrealistic — some words depend on both preceding tags and lexical content.

In practice, the Viterbi decoder can be **augmented with learning algorithms** or **smoothed** using backoff and lexicon heuristics to handle unknown words more effectively.



### Sliding Window Classifier for PoS Tagging

The **sliding window approach** is a classic discriminative method for part-of-speech tagging. It treats PoS tagging as a **token-level classification task**, where each word is assigned a tag independently. However, the decision for each token is informed by its surrounding **context window** — hence the name.

Each token is classified using a **fixed-size window** of neighboring tokens and their features.

#### Classification Pipeline

- Each token is represented by a **feature vector** derived from:
  - The current token
  - A fixed number of preceding and following tokens
- A classifier (e.g., perceptron, logistic regression, SVM) is trained to predict the PoS tag for the center token based on this context.

The classifier is applied independently at each position, but thanks to the contextual features, it captures some local dependencies between words and tags.

#### Typical Features

- Lowercased **word form** of the current token
- Word forms of the **preceding** and **following** tokens (unigrams and bigrams)
- **Capitalization**: is the token title-cased, all-caps, etc.
- **Token type**: alphabetic, numeric, punctuation
- **Prefixes and suffixes**: e.g., last 2–4 characters of the word
- **Hyphenation**: whether the token contains a hyphen
- **Sentence position**: is the token the first or last in the sentence

These handcrafted features encode both **lexical** and **orthographic** information relevant for syntactic role disambiguation.

---

### Inference with Viterbi

Although each token is classified independently, we may still want to find the **globally optimal tag sequence** according to a **decomposable scoring function**.

If our classifier defines a **score** for a tag sequence that is decomposable over token positions (e.g., scores depend only on current and previous tags), then we can apply the **Viterbi algorithm** for inference.

The Viterbi algorithm returns the highest scoring tag sequence given:
- A scoring function $s(t_{i-1}, t_i, x_i)$
- A trained model with optimised feature weights

---

#### Example

Input sentence:  
`they can fish`

Assume two possible tags: Noun (N) and Verb (V)

Each word can take on either tag, so the number of **possible labelings** is:
$$
2 \times 2 \times 2 = 8
$$

We define a scoring function based on:
- The current word $x_i$
- The previous and current tag pair $(t_{i-1}, t_i)$
- Feature weights from a learned model

Although each word is classified independently, the best sequence may be found using **dynamic programming** over the tag lattice. This allows us to select the **globally optimal sequence**, rather than the highest-scoring tag for each word in isolation.

---





### PoS Tagging with the Perceptron

To learn the parameters of a PoS tagger in a **discriminative setting**, we can combine the **structured perceptron algorithm** with **Viterbi decoding**, as proposed by Collins [1] and extended by Shen et al. [2].

This approach does not estimate transition and emission probabilities, as in HMMs. Instead, it learns a **weight vector over features**, where each complete tag sequence receives a score computed from the sum of local feature contributions.

---

### Learning Procedure

Let:
- $x$ be the input sentence (observed sequence of words)
- $y$ be the correct tag sequence
- $z$ be the predicted tag sequence under the current model weights

The training algorithm proceeds as follows:

1. **Prediction**  
   Use the current weights to decode the **best scoring sequence** $\hat{z}$ using **Viterbi decoding**:
   $$
   \hat{z} = \arg\max_{t_1, ..., t_n} \text{score}(x, t)
   $$
   where the score is a dot product between the weight vector $w$ and the feature vector $\Phi(x, t)$:
   $$
   \text{score}(x, t) = w \cdot \Phi(x, t)
   $$

2. **Update**  
   If $\hat{z} \neq y$ (i.e., the prediction is incorrect), **update the weights** by:
   $$
   w \leftarrow w + \Phi(x, y) - \Phi(x, \hat{z})
   $$
   This increases the score of the correct sequence and decreases the score of the incorrect one.

---

### Feature Templates

Features are based on:
- The **current word** and its predicted tag
- The **previous tag** and the current tag
- Possibly the **next word**, **capitalization**, and **suffixes**

Example features:
- `(current_word = "dog", tag = N)`
- `(prev_tag = D, current_tag = N)`
- `(prev_tag = N, current_tag = V)`

These features capture both lexical and sequential dependencies.

---

### Worked Example

Let:
- Gold tag sequence:  
  `y = the/D man/N saw/V the/D dog/N`
- Predicted tag sequence:  
  `z = the/D man/N saw/N the/D dog/N`  
  (i.e., the word *saw* was wrongly tagged as a noun instead of a verb)

The feature update will:
- **Increase** weights associated with the correct tag *V* for *saw*
- **Decrease** weights associated with the incorrect tag *N* for *saw*

Specifically:
- Add weight for `(word = "saw", tag = V)`
- Add weight for `(prev_tag = N, tag = V)`
- Subtract weight for `(word = "saw", tag = N)`
- Subtract weight for `(prev_tag = N, tag = N)`

This update will make it more likely that *saw* is tagged as a verb in similar future contexts.

---

### Summary

- The structured perceptron is a simple yet effective **discriminative learner** for PoS tagging.
- It combines **Viterbi decoding** for structured prediction with **online weight updates**.
- No probabilities are computed—just **scores and gradient-like corrections**.
- It supports rich and overlapping features, making it more flexible than HMMs.

**References:**
1. Collins, M. (2002). *Discriminative Training Methods for Hidden Markov Models* [W02-1001]  
2. Shen et al. (2007). *Guided Learning for Bidirectional Sequence Classification* [P07-1096]



1] Collins “Discriminative Training Methods for Hidden Markov Models: Theory and Experiments with Perceptron Algorithms” ( https://www.aclweb.org/anthology/W02-1001.pdf)
[2] Shen et al. “Guided Learning for Bidirectional Sequence Classification” (https://www.aclweb.org/anthology/P07-1096/)
