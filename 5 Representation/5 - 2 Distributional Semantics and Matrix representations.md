# Distributional Semantics and Matrix Representations

*How to compare word meanings based on observed usage in vector space.*

**Distributional Hypothesis**: *The more contexts two words share, the more similar they are.*

*"A word is characterised by the company it keeps."* (J.R. Firth)

**Types of Context:** "context" can be defined in various ways:
- **Document-level:** Co-occurrence within the same document.
- **Window-based:** Co-occurrence within a short sequence of words.
- **Syntactic:** Grammatical relations (e.g., subject-verb, verb-object).

**Vector space models (VSMS)** capture distributional semantics in high dimensional space.
- Representations include term-document matrix, term-context (co-occurrence) matrix, syntactic co-occurrence matrix.
- Weighting schemes include raw counts, TF, IDF, TF-IDF, PMI, PPMI.

Once we have established mechanisms for VSMS we can compute similarity scores with cosine similarity, euclidean distance, Manhattan distance...

***See also [[5 - 3 Word Embeddings]] (Neural Network-based Methods)***

## Cosine Similarity

**Motivation**: Normalised similarity measure independent on the number of contexts.

**Definition:** The cosine similarity metric measures the similarity between two non-zero vectors by calculating the cosine of the angle between them.

**Formula:**
$\qquad \text{cosine}(\mathbf{v}, \mathbf{w}) = \frac{\mathbf{v} \cdot \mathbf{w}}{||\mathbf{v}|| \cdot ||\mathbf{w}||}$

**Vector Norm (Magnitude):**
$\qquad ||\mathbf{v}|| = \sqrt{\sum_{i=1}^{N} v_i^2} = \sqrt{\mathbf{v} \cdot \mathbf{v}}$
where $N$ is the dimensionality of the vector $\mathbf{v}$, and $v_i$ is the $i$-th component of $\mathbf{v}$.

**Key Properties:**

* **Normalised Dot Product:** Cosine similarity is a normalised version of the dot product. This normalisation ensures that the magnitude of the vectors does not affect the similarity score.
* **Maximum Similarity:** $\text{cosine}(\mathbf{v}, \mathbf{v}) = 1$. This occurs when the two vectors are identical, indicating maximum similarity.
* **Orthogonal Vectors:** $\text{cosine}(\mathbf{v}, \mathbf{w}) = 0$ if $\mathbf{v}$ and $\mathbf{w}$ are orthogonal (perpendicular). This indicates no similarity between the vectors.
* **Opposite Directions:** $\text{cosine}(\mathbf{v}, \mathbf{w}) = -1$ if $\mathbf{v}$ and $\mathbf{w}$ are in opposite directions. This indicates maximum dissimilarity.
- **Range:** The cosine similarity value ranges from -1 to 1 (inclusive):
$\qquad -1 \le \text{cosine}(\mathbf{v}, \mathbf{w}) \le 1$

## BoW and T-F representations

1. decide size of vector and token for each position
	1. analyse corpus to extract vocabulary (CountVectorizer SciKit-learn)
2. deice fill vector function
	1. (0,1) presence (binary)
	2. raw count $f_{t,d}$
	3. Term frequency: $\frac{f_{t,d}}{\sum_{t'\in d}f_{t',d}}$
	4. log norm: $log(1+f_{t,d})$
3. compute BoW representation (CountVectorizer transform method)
4. Compute similarities between texts with **dot product** or **cosine similarity**

**Properties:**
- Simple to compute.
- Discard position in sentence (n-grams are a quasi-solution.

## One-hot
Vectorial representation of a single word within a BoW context -
where only one word (index) has a non-zero value in the vector.
**Property:**
- sparse
- all words are equally dissimilar to each other when taking the dot product. (not useful )

## Co-occurrence matrices

### Term-Document Matrix

- Directly embodies the distributional hypothesis.
  - Context as documents
- Treat each row as a vector in the document space
- compute cosine similarities between vectors - words that appear in similar documents are said to be semantically similar.

Let
- i corresponds to the text/document
- j corresponds to the jth word in the vocabulary (built from all documents)
- L = window size (hyper parameter)
Then term-matrix(i,j) =
- Count of word in document with window size L
  - bad for stopwords (too much impact)

With a Term-Document Matrix we can compute:
- **TF with log scaling:$\qquad \text{tf}_{t,d} = \log_{10}(\text{count}(t, d) + 1)$
- **IDF (Inverse Document Frequency):** $\qquad \text{idf}_{t} = \log_{10}\left(\frac{N}{\text{df}_t}\right)$
  - weights higher terms that are rare amongst documents
- **TF-IDF:** The TF-IDF weight of a term in a document is the product of its TF and IDF $$\qquad w_{t,d} = \text{tf}_{t,d} \times \text{idf}_{t}$$

### Term-Term Matrix

A more *directly contextual* representation. Rather than *Context as documents*, Context is framed as *Neighbouring words*.
- Treat each row as a vector in the space of *other words*
- words that appear with the same neighbouring words are considered more semantically similar.

With Term-Term matrices - count of words within window size of each-other - We use **PPMI**.
**Context:**
- Term-term matrices represent the co-occurrence counts of words within a specific context window.
- **Problem with Raw Counts:** Using raw co-occurrence counts can be problematic for frequent but less informative words (stop words), as they tend to have high co-occurrence with many other words, thus dominating the similarity measures.

**PMI (Pointwise Mutual Information):**
- PMI measures how often two events $w$ (word) and $c$ (context word) occur together, compared to what we would expect if they were statistically independent. **Formula:** $$\qquad \text{PMI}(w, c) = \log_2 \left( \frac{P(w, c)}{P(w)P(c)} \right)$$
**Range of PMI:**
- PMI values range from negative infinity to positive infinity.
**PPMI (Positive Pointwise Mutual Information):**
- To address the issue of negative PMI values (which can be unstable or difficult to interpret as similarity), PPMI restricts the PMI values to be non-negative.
**Formula:**
$$\qquad \text{PPMI}(w, c) = \max \left( \log_2 \left( \frac{P(w, c)}{P(w)P(c)} \right), 0 \right)$$

**Count-Based Embeddings:** PPMI is a technique used in count-based word embeddings, where the entries of the word vectors are based on the PPMI values between the target word and its context words.

**Problem:** generates long vectors the size of the vocabulary.

## Latent semantics

**Motivation**: The original term-document matrix $C$ (representing word occurrences in documents) often suffers from high dimensionality, noise, redundancy, and an inability to directly capture underlying semantic relationships (synonymy, polysemy). Approximating $C$ with a lower-rank matrix $\hat{C}_k$ aims to:
* **Reduce Dimensionality:** Obtain compact vector representations.
* **Reduce Noise:** Filter out less important variations.
* **Reveal Latent Semantic Structure:** Capture hidden semantic connections.
* **Improve Generalization:** Enhance performance in downstream tasks.

Mathematically, the goal is to find a rank-$k$ approximation $\hat{C}_k$ that minimises the Frobenius norm of the error:
$$\qquad \min_{\hat{C}_k: \text{rank}(\hat{C}_k)=k} ||C - \hat{C}_k||_F$$

The optimal solution is given by the truncated Singular Value Decomposition (SVD):
$$\qquad \hat{C}_k = U_k S_k V_k^T$$

**Properties of the Reduced Semantic Space:**

* **Dimensionality Reduction:** Achieved by selecting $k \ll$ original dimensions.
* **Noise Reduction:** Lower singular values (less important variations) are discarded.
* **Latent Semantic Structure:** The reduced space captures underlying semantic relationships.
* **Semantic Similarity:** Vector representations in this space can be used to measure similarity (e.g., using cosine similarity).
* **Interpretation of Dimensions:** Each dimension can be seen as a latent concept.

**Process of LSA:**

1.  **Construct Term-Document Matrix ($C$):** Terms as rows, documents as columns (or vice versa), entries represent term occurrences.
2.  **Perform Singular Value Decomposition (SVD):** $C = U S V^T$.
3.  **Select Top $k$ Singular Values and Vectors:** Choose the $k$ largest singular values and corresponding left ($U_k$) and right ($V_k$) singular vectors.
4.  **Form Reduced Matrices:** $U_k$ ($m \times k$), $S_k$ ($k \times k$), $V_k^T$ ($k \times n$).
5.  **Obtain Vector Representations:**
    * **Term Vectors:** Rows of $U_k$ (or columns of $U_k S_k$).
    * **Document Vectors:** Rows of $V_k^T$ (or columns of $V_k S_k$).
6.  **Analyse Semantic Relationships:** Use the reduced vectors to measure similarity.

**Limitations of LSA:**
* Loss of Information due to dimensionality reduction.
* Assumption of Linearity in relationships.
* Lack of Word Order Information (bag-of-words approach).
* Difficulty in Interpreting the Latent Dimensions.
* Computational Cost of SVD on large matrices.
* Sensitivity to the input data.
* Challenges with Polysemy (multiple meanings of a word).

**Extensions and Related Techniques:**
* Probabilistic Latent Semantic Analysis (pLSA)
* Latent Dirichlet Allocation (LDA)
* Word Embeddings (Word2Vec, GloVe, FastText) - often address LSA's limitations.
