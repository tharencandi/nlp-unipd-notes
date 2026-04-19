# Question Answering

*Fulfilling the information needs of a user is inherently complex.*

It’s not enough to just “have” the information — we need systems that can retrieve, understand, and contextualize it efficiently. As knowledge grows, storing all relevant information **within the model weights** becomes infeasible — both practically and for **privacy-sensitive applications**. Hence, **retrieval-augmented methods** are increasingly used in modern QA pipelines.

---

First we take a step back to understand Classical Information Retrieval as it one of the two components of RAG system. 
## Search Engines

We begin with the classical paradigm. The task is straightforward in concept:

**Input**: a query $q$ and a collection of documents $\{d_1, \dots, d_N\}$  
**Goal**: return a ranked list of documents $\{d_i\}$ sorted by their relevance to $q$

### Traditional Pipeline:

1. **Preprocessing**:
   - Filter stop words (e.g., “the”, “of”, “is”)
   - Tokenize and normalize text

2. **Inverted Index Construction**:
   - Maps each term to the set of documents it appears as an inverted index:
     $$
     (\text{Term}, \text{List of Document IDs})
     $$

3. **Term Weighting with TF-IDF**:
   - Emphasises rare but informative terms:
     $$
     \text{TF-IDF}(t, d) = \text{TF}(t, d) \cdot \log\left( \frac{N}{\text{df}(t)} \right)
     $$

4. **Relevance Scoring**:
   - Document score; sum of weights of matching terms:
     $$
     \text{Score}(q, d) = \sum_{t \in q \cap d} \text{TF-IDF}(t, d)
     $$

### Limitations:

Despite its historical success, this method hinges on **exact string overlap** — the query and document must share terms verbatim. This is brittle in practice.

To address this, traditional methods introduced:
- **Synonym expansion** (e.g., using WordNet)
- **Lemmatization** (e.g., “running” → “run”)
- **Subword tokenization**
- **Latent Semantic Indexing (LSI)** to capture hidden topics

But even these only scratch the surface of **semantic relevance**.
we can do better with **word embeddings** (common pattern by now...)

---

## Neural Ranking: Cross-Encoders

A more powerful approach is to move into **embedding space** and learn to compare queries and documents **contextually**.

A popular design is the **cross-encoder**, where we concatenate the query and document:

$$
z = \text{BERT}([CLS]; q; [SEP]; d)
$$

We apply a **linear classifier** on the contextualised CLS token to get the score:
$$
\text{score}(q, d) = \sigma(Uz)
$$

### Interpretation:

- The model jointly attends over both the query and document.
- Enables rich interactions — e.g., attention from specific query terms to specific document passages.
- Trained end-to-end on query-document relevance labels.

### But... it's not efficient.

- We need to recompute BERT for *each* $(q, d_i)$ pair.
- For $N$ documents, that’s $\mathcal{O}(N)$ full BERT runs.
- No possibility of indexing — we can’t precompute document representations.

So despite excellent ranking accuracy, cross-encoders are **unsuitable for real-time or web-scale retrieval**.

---

## Bi-Encoders

The natural next step: let’s **encode the query and document separately**, and compute their similarity via a simple operation (like dot product).

- we train two (BERT) encoders in parallel producing CSL_Q and CLS_D
- we put the same sigmoid function linear classifier that takes both encoder outputs as input for s(q,d)

We define:
- $q_{\text{vec}} = f(q)$
- $d_{\text{vec}} = g(d)$

And then:
$$
\text{score}(q, d) = \langle q_{\text{vec}}, d_{\text{vec}} \rangle \quad \text{or} \quad \sigma(U[q_{\text{vec}}; d_{\text{vec}}])
$$

Typically, both $f$ and $g$ are BERT (or similar) encoders trained with a contrastive loss (e.g., in-batch negatives).

### Benefits:
- Document embeddings can be **precomputed and indexed** (e.g., with FAISS).
- Query encoding is **independent of corpus size**.
- Makes large-scale retrieval practical.

### Tradeoff:
- Since there’s no joint attention, the model can’t "see" specific query-document term interactions during encoding.
- Thus, **bi-encoders trade off accuracy for scalability**.

---

## ColBERT: Late Interaction

What if we want to keep the efficiency of bi-encoders, but regain *some* of the fine-grained matching from cross-encoders?

**ColBERT**: a late interaction model that encodes queries and documents separately but computes **token-level interactions** at retrieval time.

### Pipeline:

1. Use an inverted index to retrieve a candidate subset of documents (e.g., BM25).
2. Encode:
   - Query: $q = \{q_1, ..., q_m\}$ → token embeddings
   - Document: $d = \{d_1, ..., d_n\}$ → token embeddings
3. For each query token $q_i$, find:
   $$
   \max_j sim(q_i, d_j)
   $$
4. Sum across query tokens:
   $$
   \text{score}(q, d) = \sum_{i=1}^m \max_j sim(q_i, d_j)
   $$

5. Feed into a scoring function (e.g., sigmoid classifier).

### Benefits:
- Still allows **precomputed document token embeddings**.
- Captures **contextual token-level interactions** without recomputing full BERT for each $(q, d)$.
- Efficient, scalable, and more accurate than basic bi-encoders.

---

## Retrieval-Augmented Generation (RAG)

Large language models (LLMs) are powerful generative tools, but they suffer from two key limitations:  
(1) They cannot dynamically access new or external knowledge.  
(2) Storing all potentially relevant information in the model weights is infeasible — both in terms of scale and for privacy or freshness.

**Retrieval-Augmented Generation (RAG)** addresses these concerns by incorporating an external knowledge source — usually a large text corpus — into the generation pipeline. The result is a hybrid system that can **retrieve and reason**, making it useful for QA, summarization, grounded dialogue, and more.
### Architecture Overview

RAG combines two components:

1. **Retriever**  
   - Given a query $q$, retrieves a set of top-$k$ relevant documents/passages $\{d_1, ..., d_k\}$ from a corpus $C$
   - Retrieval may be lexical (e.g., BM25) or dense (e.g., using a bi-encoder)

2. **Generator (Reader)**  
   - Takes the query and retrieved passages as context
   - Generates an answer using an LLM conditioned on the augmented prompt:
     $$
     \text{Input to LLM: } [\text{Query } q] + [\text{Passages } d_1, ..., d_k]
     $$

Thus, RAG dynamically incorporates retrieved content into the generation process, effectively expanding the LLM’s “knowledge” without retraining.

### Motivation

- **Privacy and compliance**: Some facts must be retrieved at runtime, not memorized.
- **Up-to-date knowledge**: Pretrained models cannot access post-training events.
- **Scalability**: It's easier to update a corpus than retrain a model.
- **Interpretability**: Retrieved documents can be shown to users as evidence.

### Retriever Design Considerations

The performance of RAG hinges critically on the retriever. Several design factors influence its behavior:

- **Context Window Size**:
  - LLMs have limited input token budgets (e.g., 4k, 8k, 32k tokens)
  - This constrains the number and length of passages that can be provided
  - Tradeoff: fewer long documents vs. more short documents

- **Passage Granularity**:
  - In dense retrieval, shorter passages often yield better semantic matching
  - Chunking strategy must preserve coherence while maximizing retrievability

- **Retriever Architecture**:
  - **Sparse**: traditional TF-IDF or BM25 (fast, interpretable)
  - **Dense**: dual encoders trained on similarity objectives (semantic, generalizable)
  - **Hybrid**: combine both (e.g., dense reranking of sparse candidates)

- **Indexing Strategy**:
  - Precompute document embeddings and store in vector index (e.g., FAISS, ScaNN)
  - Enables low-latency Approximate Nearest Neighbor (ANN) search at inference time

- **Efficiency Requirements**:
  - Real-time applications (e.g., chat assistants) need low retrieval latency
  - Batched retrieval and GPU acceleration may be necessary at scale

### Generator Behavior

Once passages are retrieved, the generator (typically a seq2seq model like BART or T5) must integrate them effectively.

- Early fusion (concatenation of $q$ and $\{d_i\}$ as input)
- Attention mechanisms allow the generator to selectively attend to different passages
- The quality of the generation depends on both **retrieval precision** and the model’s **contextual understanding**

Some variants score and re-rank generations using a separate model (e.g., reranker, verifier).

### Challenges and Tradeoffs

| Factor               | Tradeoff                                 |
|----------------------|------------------------------------------|
| Retrieval breadth    | Higher recall vs. noise introduction     |
| Passage length       | Coherence vs. specificity                |
| Index size           | Coverage vs. memory footprint            |
| Latency              | Depth of search vs. response time        |
| Generator length     | Verbosity vs. token limits               |
| Evidence grounding   | Faithful use of passages vs. hallucination |

---

## Evaluation of Question Answering (QA) Systems

Evaluating QA systems depends on the **format of model output** and the **type of task** (e.g., extractive, ranking, or generative QA). Metrics are chosen based on how well they capture relevance, correctness, and semantic fidelity between system predictions and ground truth (gold) answers.

Evaluation assumes the availability of a **gold dataset**, where each question is paired with one or more correct answers.


### 1. Extractive QA (Span Selection)

In extractive QA, the model selects a span from the context passage. Since the ground truth is also a span of tokens, overlap-based metrics are used.

#### $F_1$ Score

The $F_1$ score captures **token-level agreement** between the predicted and gold answer spans.

- Represent both the prediction and ground truth as bags of tokens.
- Compute:
  $$
  \text{Precision} = \frac{|\text{pred} \cap \text{gold}|}{|\text{pred}|}, \quad \text{Recall} = \frac{|\text{pred} \cap \text{gold}|}{|\text{gold}|}
  $$
  $$
  F_1 = \frac{2 \cdot \text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}}
  $$

The final score is the mean $F_1$ across all QA pairs.

**Advantages**:
- Simple, interpretable, and works for multiple gold references.
- Captures partial correctness (some correct tokens → partial credit).

**Limitations**:
- Ignores word order and syntax.
- Sensitive to small formatting differences (e.g., "5 dollars" vs "five dollars").
- Does not reward semantically equivalent but lexically different answers.

### 2. Ranking QA (Community QA / Retrieval QA)

In ranked QA, the model outputs an ordered list of candidate answers or documents. The evaluation assesses whether the **correct answer appears near the top** of the list.

#### Mean Reciprocal Rank (MRR)

MRR rewards systems for returning correct answers **early** in the ranked list.

- Let $\text{rank}_i$ be the position of the first correct answer for question $i$.
  $$
  \text{MRR} = \frac{1}{|Q|} \sum_{i=1}^{|Q|} \frac{1}{\text{rank}_i}
  $$

**Advantages**:
- Easy to compute and interpret.
- Sensitive to position of the correct answer.

**Limitations**:
- Only considers the **first correct answer**.
- Ignores multiple correct answers ranked further down.
- Discrete — not suitable when partial relevance matters.

#### Mean Average Precision (MAP)

MAP averages precision scores at each position where a relevant item is retrieved.

- For each question $q_i$, define $R_i$ = set of ranks with correct answers:
  $$
  \text{AP}_i = \frac{1}{|R_i|} \sum_{k \in R_i} \text{Precision@k}
  $$
  $$
  \text{MAP} = \frac{1}{|Q|} \sum_{i=1}^{|Q|} \text{AP}_i
  $$

**Advantages**:
- Takes into account multiple relevant answers.
- Considers both position and precision cumulatively.

**Limitations**:
- Still binary — assumes all relevant documents are equally good.
- Does not consider semantic similarity — only exact match to gold set.

### 3. Generative QA (Free-Form Text)

In generative QA, models produce open-ended answers that must be evaluated by comparing them to one or more reference answers.

#### BLEU (Bilingual Evaluation Understudy)

BLEU evaluates **precision of $n$-gram overlap** between the generated (hypothesis) and reference texts.

- $p_n$: proportion of hypothesis $n$-grams that appear in the reference:
  $$
  p_n = \frac{\text{\# matching } n\text{-grams}}{\text{\# } n\text{-grams in hypothesis}}
  $$

- Combined score with geometric mean:
  $$
  \text{BLEU} = \text{BP} \cdot \exp\left( \frac{1}{N} \sum_{n=1}^N \log p_n \right)
  $$

- Brevity Penalty (BP) discourages overly short outputs:
  $$
  \text{BP} = \begin{cases}
  1 & \text{if } c > r \\
  e^{1 - r/c} & \text{if } c \leq r
  \end{cases}
  $$

**Advantages**:
- Standard in MT and text generation.
- Works well for tasks with fixed reference phrasing (e.g., translations).

**Limitations**:
- Requires exact $n$-gram match — no synonymy or paraphrasing allowed.
- Penalizes semantically correct answers with different wording.
- Sensitive to output length (very short or very long answers skew scores).
- Repetition of words can artificially inflate scores.
- Scores saturate quickly — not sensitive to small improvements.


#### ROUGE (Recall-Oriented Understudy for Gisting Evaluation)

ROUGE is a family of recall-focused metrics, widely used in **summarization** and **QA generation**.

- **ROUGE-N** (unigram, bigram):
  $$
  \text{ROUGE-N} = \frac{\text{\# matching } n\text{-grams}}{\text{\# } n\text{-grams in reference}}
  $$

- **ROUGE-L** (Longest Common Subsequence — LCS):
- ![[Pasted image 20250618143519.png]]
  - Measures how much of the reference order is preserved in the output.
  - Recall:
    $$
    R_{\text{LCS}} = \frac{\text{LCS}(X, Y)}{|Y|}
    $$
  - Precision:
    $$
    P_{\text{LCS}} = \frac{\text{LCS}(X, Y)}{|X|}
    $$
  - F-measure:
    $$
    F_{\text{LCS}} = \frac{(1 + \beta^2) \cdot R_{\text{LCS}} \cdot P_{\text{LCS}}}{R_{\text{LCS}} + \beta^2 \cdot P_{\text{LCS}}}
    $$

**Advantages**:
- Widely used in summarization and QA generation benchmarks.
- Captures some degree of fluency and order preservation.

**Limitations**:
- Still surface-form based — no credit for semantically similar words.
- Sensitive to paraphrasing and grammatical variation.
- Not suitable for very short generations (unstable for few tokens).

#### BERTScore

BERTScore leverages **contextualized token embeddings** to compute semantic similarity between hypothesis and reference text.

- For each token in hypothesis $x$ and reference $\hat{x}$, compute contextual embeddings using a pretrained BERT model.

- Match tokens by maximum cosine similarity:

  - **Precision**:
    $$
    P_{\text{BERT}} = \frac{1}{|\hat{x}|} \sum_{\hat{x}_j \in \hat{x}} \max_{x_i \in x} \cos(x_i, \hat{x}_j)
    $$

  - **Recall**:
    $$
    R_{\text{BERT}} = \frac{1}{|x|} \sum_{x_i \in x} \max_{\hat{x}_j \in \hat{x}} \cos(x_i, \hat{x}_j)
    $$

  - **$F_1$ Score**:
    $$
    F_{\text{BERT}} = \frac{2 \cdot P \cdot R}{P + R}
    $$

- Extended version includes **IDF weighting** to downweight stopwords:
  $$
  \text{Weighted cosine}(x_i, \hat{x}_j) = \text{IDF}(x_i) \cdot \cos(x_i, \hat{x}_j)
  $$

- Final score (originally in $[-1, 1]$) is linearly mapped to $[0, 1]$.

**Advantages**:
- Captures **semantic similarity** beyond lexical overlap.
- Tolerant to paraphrasing and synonymy.
- Outperforms BLEU/ROUGE on correlation with human judgment.

**Limitations**:
- Requires model inference (slow at scale).
- Sensitive to embedding model choice.
- Still local — may miss global meaning inconsistencies.
- More difficult to interpret than discrete metrics.


## Summary of Evaluation Metrics

| Metric      | Output Type     | Captures                  | Strengths                              | Limitations                                  |
|-------------|------------------|---------------------------|-----------------------------------------|----------------------------------------------|
| $F_1$        | Span QA          | Token-level overlap       | Simple, partial credit                  | No order or semantic understanding           |
| MRR          | Ranked QA        | First relevant rank       | Sensitive to top-ranked correctness     | Ignores all but first relevant hit           |
| MAP          | Ranked QA        | Precision over relevance  | Considers multiple relevant docs        | Binary relevance only                        |
| BLEU         | Generated text   | $n$-gram precision        | Standard in MT                          | Penalizes paraphrase, favors brevity         |
| ROUGE        | Summarization, QA | $n$-gram recall, LCS     | Recall-focused, widespread usage        | Requires surface match                       |
| BERTScore    | Generated text   | Semantic token similarity | Embedding-aware, paraphrase-tolerant    | Slower, harder to interpret                  |
