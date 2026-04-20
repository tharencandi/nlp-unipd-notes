# LLM Evaluation and Scaling Laws

## Language Model Evaluation

**For both Statistical and Neural Language Models**

### Perplexity

How well a probability model predicts a sample, i.e., how well an LLM predicts a sequence of text.

average negative log-likelihood (cross entropy) of the predicted words in a sequence, exponentiated.

The perplexity (sometimes abbreviated as PP or PPL) of a language model on a test set is the inverse probability of the test set (one over the probability of the test set), normalized by the number of words (or tokens). For this reason it's sometimes called the per-word or per-token perplexity.

A **High Perplexity** corresponds to low probabilities across the distribution of predictions.

A **Low Perplexity** corresponds to high probabilities.

- the model is 'confident'

Perplexity must be paired with specific evaluation metrics for downstream tasks. Low perplexity does not imply good performance downstream.

### Perplexity as Weighted Average Branching Factor

- Perplexity = **weighted average branching factor** of a language.
- Branching factor = number of possible next words.

### Example: Deterministic Language (3 colors)

* Language $L = \{\text{red, blue, green}\}$ (3.18)
* Branching factor = 3.
* If each word has equal probability (1/3).
* Test set $T = \text{"red red red red red"}$

Perplexity for Model A (equal probabilities):
$$
\text{perplexity}_A(T) = \left(\left(\frac{1}{3}\right)^5\right)^{-1/5} = \left(\frac{1}{3}\right)^{-1} = 3 \quad (3.19)
$$

### Example: Probabilistic Language (Preferring "red")

* Model B with probabilities: $P(\text{red}) = 0.8$, $P(\text{green}) = 0.1$, $P(\text{blue}) = 0.1$ (3.20)
* Test set $T = \text{"red red red red red"}$ (length = 5)
* We expect a low perplexity, red p0.8 is very predictable)

Perplexity for Model B (preferring "red"):
$$
\text{perplexity}_B(T) = (0.8^5)^{-1/5} = 0.8^{-1} = 1.25 \quad (3.21)
$$
*(Note: Original text's calculation $0.527^{-1} = 1.89$ for Eq. 3.21 appears inconsistent with $0.8^5$. Using $0.8^{-1} = 1.25$ here.)*

**Conclusion:** Lower perplexity (1.25 vs 3) indicates a better fit to the data when the model assigns higher probabilities to the observed sequence.

## Intrinsic vs Extrinsic Evaluation

- Intrinsic: perplexity, cloze tests, contrastive scoring
- Extrinsic: downstream performance

## Linguistic Probing Tasks

- Syntactic agreement
- Negation, coreference, etc.

## Known Limitations

- Overfitting to training data
- Incomparability across datasets

## Scaling Laws of LLMs
If we were to build an LLM, what could we optimise for (given a
fixed budget)?

- What and how much data to train on
- Model size (number of parameters)
- What learning tasks they have been (pre)trained on and how much computing power has been used

- The performance (cross-entropy loss) for a transformer architecture depends on N (size of the model –performance does not seem to depend on the exact architecture-), D (dataset size), C (amount of computing)
- Performance has roughly a power law relationship with these elements: Na
- Performance improves predictably as long as we scale up N and D in tandem
- every time we increase the model size 8x, we only need to increase the data by roughly 5x to avoid a penalty
- Large models are more sample-efficient than small models, reaching the same level of performance with fewer optimization steps and using fewer data points
- if C is fixed, we attain optimal performance by training very large models and stopping significantly short of convergence

Kaplan et al., "Scaling laws for neural language models." (https://arxiv.org/pdf/2001.08361)
