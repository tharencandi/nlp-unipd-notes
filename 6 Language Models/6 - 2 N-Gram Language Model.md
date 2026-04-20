# N-Gram Language Model

How to leverage **[[5 - 1 Simple Text Representations (Bag-of-Words and TF-IDF)#N-Grams|N-Grams]]** to estimate the probability of linguistic sequences.

## Key Formulas

1. **Chain Rule**:
  $$
  P(W) = \prod_{i=1}^n P(w_i \mid w_1, \dots, w_{i-1})
  $$

2. **MLE for Bigrams**:
  $$
  P(w_i \mid w_{i-1}) = \frac{C(w_{i-1}, w_i)}{C(w_{i-1})}
  $$

3. **Laplace Smoothing**:
  $$
  P(w_i \mid w_{i-1}) = \frac{C(w_{i-1}, w_i) + 1}{C(w_{i-1}) + |V|}
  $$

## Sentence Probability Estimation

### Core Objective
Given a sentence $W = (w_1, w_2, \dots, w_n)$, compute its probability $P(W)$.
**Challenge**: Direct estimation is infeasible due to combinatoric explosion of possible sequences.

### Chain Rule Decomposition
Decompose $P(W)$ into conditional probabilities using the chain rule:
$$
P(w_1, \dots, w_n) = \prod_{i=1}^n P(w_i \mid w_1, \dots, w_{i-1})
$$
**Limitation**: Requires estimating probabilities for exponentially many histories.

## N-gram Language Models

### Approximation via Markov Assumption
Assume words depend only on the immediate $n-1$ predecessors:
$$
P(w_i \mid w_1, \dots, w_{i-1}) \approx P(w_i \mid w_{i-n+1}, \dots, w_{i-1})
$$
**Trade-offs**:

- **Small $n$**: Lower data sparsity but limited context.
- **Large $n$**: Richer context but higher sparsity and memory costs ($O(|V|^n)$).

#### Maximum Likelihood Estimation (MLE)
Estimate probabilities from empirical counts:
$$
P(w_i \mid w_{i-1}) = \frac{C(w_{i-1}, w_i)}{C(w_{i-1})}
$$
**Example**:
For corpus:

1. `<s> I am Sam </s>`
2. `<s> Sam I am </s>`
3. `<s> I do not like eggs </s>`

$$
P(\text{I} \mid \text{<s>}) = \frac{2}{3}, \quad P(\text{Sam} \mid \text{am}) = \frac{1}{2}
$$

**Failure Case**: If $C(w_{i-1}, w_i) = 0$, $P(w_i \mid w_{i-1}) = 0$, which undermines model robustness.

---

## Handling Data Sparsity

### **3.1 Smoothing Techniques**
**Goal**: Reassign probability mass to unseen events.

#### **Additive (Lidstone) Smoothing**
$$
P(w_i \mid w_{i-1}) = \frac{C(w_{i-1}, w_i) + \alpha}{C(w_{i-1}) + \alpha |V|}
$$

- **Laplace**: $\alpha = 1$ (uniform prior).
- **Jeffreys-Perks**: $\alpha = 0.5$ (compromise).

#### **Discounting Methods**
Subtract fixed $d$ from observed counts, redistribute to unobserved:
$$
P(w_i \mid w_{i-1}) = \frac{\max(C(w_{i-1}, w_i) - d, 0)}{C(w_{i-1})} + \lambda(w_{i-1}) P_{\text{backoff}}(w_i)
$$

#### Backoff and Interpolation

- **Backoff**: Use lower-order $n$-gram if higher-order count is zero.
- **Interpolation**: Weighted combination of all $n$-gram orders:
  $$
  P = \lambda_1 P_{\text{trigram}} + \lambda_2 P_{\text{bigram}} + \lambda_3 P_{\text{unigram}}
  $$

**Advanced Method**: *Kneser-Ney Smoothing* (integrates backoff and discounting).

---

## Out-of-Vocabulary (OOV) Words

### **4.1 Training Phase**

1. Replace infrequent words (e.g., frequency $< 5$) with `<UNK>`.
2. Estimate $P(\text{<UNK>})$ from its corpus frequency.

### **4.2 Test Phase**

1. Replace OOV words with `<UNK>`.
2. Exclude `<UNK>` from generation candidates.

---

## Practical Considerations

### Memory Efficiency

- **Storage**: $n$-gram models require $O(|V|^n)$ space.
- **Optimisations**:
  - Prune low-probability $n$-grams.
  - Use probabilistic data structures (e.g., Bloom filters).

### Computational Trade-offs

| Model   | Context Captured | Data Requirements |
|---------|------------------|-------------------|
| Bigram  | Local            | Moderate          |
| 5-gram  | Extended         | Very High         |

**Guideline**: Choose the largest $n$ where $C(w_{i-n+1}, \dots, w_i) > \text{threshold}$.

### Applications

- **Autocomplete**: Predict next word given context.
- **Grammar Correction**: Rank candidate corrections by $P(W)$.
- **Speech Recognition**: Disambiguate homophones (e.g., "their" vs. "there").

---

## Limitations

1. **Meaning Ignorance**: Purely statistical; no semantic understanding.
2. **Long-Range Dependencies**: Fails to capture dependencies beyond $n$-gram window.
3. **Bias Toward Frequent Patterns**: May reinforce corpus biases.

**Transition**: Modern neural models (e.g., RNNs, Transformers) address these issues but require significantly more resources.

---
