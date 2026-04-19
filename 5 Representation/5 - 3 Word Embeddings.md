
Word embeddings are **dense vectors** that capture semantic and syntactic word relationships by mapping words to a continuous vector space. Unlike [[5 - 1 |sparse representations]](e.g., BoW or TF-IDF), embeddings are trained to place similar words closer together in this space.
### **Key Properties**

1. **Dimensionality Reduction**:
    - Compresses words into dense vectors (typically 50–300 dimensions vs. thousands in BoW).
2. **Distributional Learning**:
    - Follows the _distributional hypothesis_ (like matrix methods) but uses neural networks to encode patterns.
3. **Semantic Regularities**:
    - Captures analogies (e.g., _king – man + woman ≈ queen_) and hierarchies (e.g., _dog → animal_).

| Method         | Pros                            | Limitations                             |
| -------------- | ------------------------------- | --------------------------------------- |
| **BoW/TF-IDF** | Simple, interpretable           | Sparse, no word relationships           |
| **LSA/PPMI**   | Captures global stats           | Linear, ignores word order              |
| **Embeddings** | Dense, nonlinear, context-aware | Requires large data, less interpretable |
### **Neural vs. Count-Based Approaches**

While **matrix factorisation** (e.g., LSA, PPMI) relies on co-occurrence statistics, neural embeddings (e.g., Word2Vec, GloVe) **predict words from contexts** (or vice versa), enabling:

- **Nonlinear relationships** (e.g., polysemy handling).
- **Efficient similarity computation** (cosine distance).
- **Transfer learning** (pre-trained embeddings for downstream tasks).
### **Types of Context**
Embeddings can be trained using:
- **Window-based contexts** (Word2Vec: local neighbours).
- **Global co-occurrence** (GloVe: whole-corpus statistics).
- **Sub-word information** (FastText: character n-grams).
---

# Evaluation
Intrinsic (Tomas Mikolov, Kai Chen, Greg Corrado, Jeffrey Dean, "Efficient Estimation of Word Representations in Vector Space")
- 8869 semantic and 10675 syntactic questions – cosine similarity between words

**1. Semantic-Syntactic Word Relationship Test Set**
- **Task Design**:
    - Created a comprehensive test set with **8,869 semantic** and **10,675 syntactic** questions.
    - Examples:
        - _Semantic_: "Athens is to Greece as Oslo is to Norway" (capital cities).
        - _Syntactic_: "big is to bigger as small is to smaller" (morphological patterns).  
- **Metric**:
    - **Accuracy**: A question is correct only if the predicted word (via vector arithmetic, e.g., vec("King")−vec("Man")+vec("Woman")≈vec("Queen")vec("King")−vec("Man")+vec("Woman")≈vec("Queen")) exactly matches the ground truth. Synonyms are counted as errors.
    
**2. Word Similarity Tasks**
- **Datasets**: Evaluated on standard benchmarks (e.g., WordSim353, MEN) using **cosine similarity** between word vectors.
- **Metric**: **Spearman’s rank correlation** between model rankings and human-judged similarity scores.

 **3. Model Comparison**
- **Baselines**: Compared against:
    - Traditional NNLM (Feed-forward and RNN-based). 
    - Publicly available word vectors (e.g., Collobert-Weston, Turian). 
- **Key Results**:
    - Skip-gram outperformed CBOW on **semantic tasks** (55% vs. 24% accuracy).    
    - CBOW was better for **syntactic tasks** (64% vs. 59%).
    - Both models surpassed NNLM and RNNLM in accuracy and training speed (Table 3).
    
 **4. Scaling Experiments**
- **Training Data Impact**: Tested on subsets of Google News corpus (24M to 6B words).
    - Findings: Larger data + higher dimensionality (d=300−1000d=300−1000) improved accuracy, but with diminishing returns (Table 2).
- **Efficiency**:
    - CBOW trained faster (1 day for 6B words) vs. Skip-gram (3 days).
    - Distributed training (DistBelief) scaled to **trillions of words** (Table 6).
    
**5. Microsoft Sentence Completion Challenge**
- **Task**: Predict missing words in sentences from 5 choices.
- **Result**: Skip-gram alone achieved **48% accuracy**; combined with RNNLM, reached **58.9%** (new SOTA, Table 7).

**6. Qualitative Analysis**
- **Vector Arithmetic**: Demonstrated relationships like:
    - vec("Paris")−vec("France")+vec("Italy")≈vec("Rome")vec("Paris")−vec("France")+vec("Italy")≈vec("Rome").    
    - Analogies for grammar (e.g., verb tenses) and semantics (e.g., currencies).

- See: https://projector.tensorflow.org/
- **Extrinsic**
	- compare word embeddings and n-grams as input to a number of downstream tasks

# Visualising Word Embeddings

Word embeddings can be used to visualise the meaning of a word by:
- listing the words in V with highest cosine similarity with the word.
-  project the d dimensions of a word embedding down into 2 dimensions (t-distributed stochastic neighbor embedding (t-SNE)).
# Properties and Types 

Embeddings have the ability to capture relational meanings.

Can be used to solve analogy problems with a parallelogram model:
	https://doi.org/10.1016/j.cognition.2020.104440 

#### Diachronic Word Emebeddings
https://en.wikipedia.org/wiki/Orthogonal_Procrustes_problem 
Comparing embeddings trained on different but related data. 
- Same domain different time periods.

Orthogonal Procrustes Problem: 
- How to align embeddings into same space to be able to do meaningful comparisons.
$$R^{(t)} = arg \min_{Q^TQ=I}||W^{(t)}Q-W^{(t+1)}||_F$$
Where
- Q is a transformation (rotation and alignment) matrix.
- Solution is $UV^T$ where $U,V$ are from SVD decomposition of $W^{t+1}(W^t)^T$.
#### Polysemous Word Embeddings
Embeddings of words with multiple meanings;
Arora et al. “Linear Algebraic Structure of Word Senses, with Applications to Polysemy” (https://www.aclweb.org/anthology/Q18-1034.pdf) 

Shows that the resulting embeddings will be proportional to the sum of the embeddings of the various meanings.
$$v(tie) \approx a_1v(tie_1) + a_2v(tie_2) + a_3v(tie_3)$$
where $a_i$ is proportional to the relative frequency of the meaning $i$
- $v(tie_1)$ is a discourse atom (~topic) that can be learned (here represented by a set of representative words)
- 
## Methods - Word2Vec, GloVe, FastText, CBOW
#### Word2Vec

Major achievement:
- defining a learning problem without the need to annotate data manually (overcomes major limiting factor for machine learning)
- unlocks massive datasets

Train a classifier on a binary prediction task:
- Given a word $t$ predict if a word $c$ is in the context 
	- generating term-context $(t,c)$ pairs 
Thus we want our classifier to estimate the following probability:$$P(+|w,c)$$
Whereby $$similarity(w,c) \approx c \cdot w$$
$$P(+|w,c) = \sigma(c\cdot w) = \frac{1}{1+exp(-c \cdot w)}$$
Assuming independence of context words we can compute the log probability
$$logP(+|w,c_{1:L}) = \sum_{i=1}^{L}log*\sigma(c_i \cdot w)$$

Learning function that maximising probability of context words and minimises non-context words
$$L(\theta)=\sum_{(t,c) \in+}logP(+|t,c) + \sum_{(t,c) \in-}logP(-|t,c)+$
$$ 
Training process:
1. treat target word and neighbouring context as positive examples
2. randomly sample other words in lexicon for negative samples
3. logistic regression to train classifier
4. use the learned weights as the embeddings

Model perspective:
- each word t in corpus has two d-dimensional representations totalling $d*2|V|$ parameters
	- w - target words representation
	- c - context and noise word representation
- final embedding form for word i:
	1) $w_i + c_i$
	2) $w_i$

Gradient of loss function:
$$w^{t+1} = w^t - \eta [\sigma(c_{pos}\cdot w^t)-1]c_{pos} + \sum_{i=1}^k[\sigma(c_{neg_i}\cdot w^t)]c_{neg_i}]$$
- $w^{t+1}$, $w^t$: next word to predict t+1 using current word t.
- **η**: learning rate
- **The bracketed term**: The gradient of the loss function with respect to the word vector.
    1. positive pair (word t and neighbouring context):  $\sigma(c_{pos}\cdot w^t)-1]c_{pos}$ 
        - cpos​: This is the vector representation of the positive context word.
        - wt⋅cpos​: This is the dot product between the target word vector and the positive context word vector. A higher dot product indicates greater similarity.
        - (σ(cpos​⋅wt)−1): Sigmoid to squash dot between 0 and 1. Ideally, for a true positive pair (which it should be since its real context), we want σ(cpos​⋅wt) to be close to 1. If it's less than 1, this term will be negative, pushing the word vectors to become more similar.
        - The entire term (σ(cpos​⋅wt)−1)cpos​ contributes to adjusting wt in the direction that increases its similarity with the positive context word cpos​.
    2. ​​$\sum_{i=1}^k[\sigma(c_{neg_i}\cdot w^t)]c_{neg_i}$: This part relates to the _negative samples_.
        - k: num negative hyperparamater samples
        - cnegi​​: This is the vector representation of the i-th negative context word (a word that is _not_ actually in the context of w).
        - wt⋅cnegi​​: This is the dot product between the target word vector and the i-th negative context word vector.
        - σ(cnegi​​⋅wt): This is the sigmoid output, representing the probability that cnegi​​ is a context word for w. For negative samples, we want this probability to be close to 0.
        - The entire summation term contributes to adjusting wt in the direction that decreases its similarity with the negative context words cnegi​​.

**More on Negative sampling:**
For each positive pair (target word, context word), we create $k$ (hyperparameter) negative pairs by randomly selecting a context word with probability $P_\alpha(w)$ (where $\alpha$ is a hyperparameter, usually set to 0.75, increasing the probability of rare words). 
- The probability of selecting a word $w$ as a negative sample is given by: $$P_\alpha(w) = \frac{count(w)^\alpha}{\sum_{w' \in Vocabulary} count(w')^\alpha}$$where
- $count(w)$ is the frequency of word $w$ in the training corpus. 
- $\alpha$ is a hyperparameter (typically 0.75). 
- The exponent $\alpha < 1$ increases the probability of selecting rare words. 
- Reduces the computational cost by considering only a small number of negative examples instead of the entire vocabulary.


**Obersations:**
- Context words randomly sampled rfavouirng closer words with hyperparamter window size L
- L changes the utility of our embeddings:
	- Small window size = semantically similar with the same positions
	- larger window size = topical relatedness 
- Pre-trained word embeddings are the most popular represenation for learning algoriths 
	- be careful: bias may propagate throughout the system


**Connection to matrix factorizaiton:**
Skip-Gram with negative sampling model is connected to matrix
factorization of C[1] :
- Ci,j = PMI(i,j) – log k
- PMI of word i in context j
- k is the number of negative examples sampled
- We can use PPMI to avoid –infinite values when count(i, j)=0

https://transacl.org/ojs/index.php/tacl/article/view/570/124 
**Title:** Improving Distributional Similarity with Lessons Learned from Word Embeddings  
**Authors:** Omer Levy, Yoav Goldberg, Ido Dagan  
**Published in:** Transactions of the Association for Computational Linguistics (TACL), 2015  

This work reshaped understanding of word embeddings by highlighting the importance of hyperparameters and enabling fairer comparisons between methods.  
##### **Key Contributions:**  
-  The paper reveals that much of the performance gains attributed to neural word embeddings (e.g., Word2Vec, GloVe) stem from system design choices and hyperparameter optimisations, rather than the underlying algorithms.  
- The authors demonstrate that these optimizations (e.g., dynamic context windows, subsampling, negative sampling, and context distribution smoothing) can be applied to traditional count-based methods like PPMI and SVD, closing the performance gap between the two approaches.  
- When hyperparameters are properly tuned, count-based methods (PPMI, SVD) perform comparably to neural embeddings (SGNS, GloVe) on word similarity and analogy tasks.  
- Context distribution smoothing (a technique borrowed from Word2Vec) significantly improves PPMI by mitigating its bias toward rare word co-occurrences.  
- There is no consistent global advantage of neural embeddings over count-based methods when both are optimized.  
 - **Practical Recommendations**:  
	- Always use context distribution smoothing (cds=0.75) for PPMI/SVD.  
	- Avoid the traditional SVD setup (eig=1); symmetric variants (eig=0 or 0.5) perform better.  
	- SGNS is a robust baseline due to its efficiency and competitive performance.  
##### **Contradictions to Prior Work**:  
- Challenges claims that neural embeddings universally outperform count-based methods (e.g., Baroni et al., 2014), showing that differences often arise from untuned hyperparameters in traditional methods.  
- Finds that GloVe does not outperform SGNS when both are fairly compared, contrary to Pennington et al. (2014).  

#### Fast-Text
https://arxiv.org/pdf/1607.04606.pdf  (https://fasttext.cc)
A solution for learning word embeddings for languages with a rich morphological structure.

- computes the representation for char n-grams + < for word beginning and > for word endings.
- Words are then the sum of the embeddings of the char n-grams comprising it. 
- n is a hyperparamater that is dependant on the language and the task.
- It also shows general improvements for syntactic analogy tasks on rare words.

#### Glove
*Pennigton et al. “Glove: Global Vectors for Word Representation” (2014)
https://aclanthology.org/D14-1162.pdf 

Count-based model for learning word embeddings. Unlike the predictive methods like Skip-Gram and CBOW in Word2Vec, which learn embeddings by predicting context words or a target word, GloVe leverages the global co-occurrence statistics of words within a corpus.

Initialises embeddings based on the global co-occurence statistics between words from the term-term matrix.

**Ratio of Co-occurrence Probabilities**

The fundamental intuition behind GloVe is that the ratios of word-word co-occurrence probabilities have the potential to encode meaning. For example, consider two target words, "ice" and "steam," and two context words, "solid" and "gas."

- "ice" is expected to co-occur frequently with "solid" and infrequently with "gas."
- "steam" is expected to co-occur frequently with "gas" and infrequently with "solid."
- The ratio of co-occurrence probabilities $\frac{P(solid | ice)}{P(gas | ice)}$ should be large.
- The ratio of co-occurrence probabilities $\frac{P(solid | steam)}{P(gas | steam)}$ should be small.
- The ratio $\frac{P(solid | ice)}{P(solid | steam)}$ should be large.
- The ratio $\frac{P(gas | steam)}{P(gas | ice)}$ should be large.

GloVe aims to learn word vectors such that their dot product is related to the logarithm of these co-occurrence probabilities.

**Methodology:**

1.  **Constructing the Co-occurrence Matrix (X):**
    - GloVe first scans the entire corpus to build a large word-word co-occurrence matrix $X$, where $X_{ij}$ represents the number of times word $j$ appears in the context of word $i$
    - The context is typically defined by a symmetric window around the target word.
    - A weighting function $f(X_{ij})$ is often used to down-weight the contribution of very frequent co-occurrences, as these might be less informative. A common form for $f(x)$ is:
        $$f(x) = \begin{cases}
            (x/x_{max})^\alpha & \text{if } x < x_{max} \\
            1 & \text{otherwise}
        \end{cases}$$
        where $x_{max}$ and $\alpha$ are hyperparameters.

2.  **Defining the Loss Function:**
    - Learn two sets of word vectors: $w_i$ (word vector of word $i$) and $\tilde{w}_j$ (context word vector of word $j$).
    -  Minimise the following weighted least squares loss function:
        $$J = \sum_{i,j=1}^{V} f(X_{ij}) (w_i^T \tilde{w}_j + b_i + \tilde{b}_j - \log(X_{ij}))^2$$
        where:
        - $V$ is the size of the vocabulary.
        - $b_i$ and $\tilde{b}_j$ are bias terms associated with words $i$ and $j$, respectively.
        - The term $\log(X_{ij})$ comes from the idea of matching the dot product of word vectors to the logarithm of the co-occurrence counts.

3.  Train with SGD.

4.  **Final Embeddings:**
	- same as Word2Vec
    - After training, the final word embedding for a word $i$ is typically obtained by summing its word vector and its context word vector: $e_i = w_i + \tilde{w}_i$, or simply using $w_i$

**Advantages of GloVe:**

- **Leverages Global Statistics:** Directly using the co-occurrence matrix global relationships between words are captured, local context window methods might miss broader semantic connections.
- **Strong Empirical Performance:** Often competitive with or superior to Word2Vec models.

**Disadvantages:**
- **Computational Cost of Co-occurrence Matrix:** Building the co-occurrence matrix can be computationally expensive for very large corpora.
- **Less Flexibility with Context:** Unlike Word2Vec, where the context window can be adjusted during training, the co-occurrence statistics in GloVe are pre-computed based on a fixed window size.


#### Continuous Bag of Words model (CBOW)

The Continuous Bag of Words (CBOW) model employs a sliding window training technique. The window consists of a central target word and its surrounding context words (both forward and backward).

At each training step, the model predicts the probability distribution of the centre word given its context. The model parameters are then updated using Stochastic Gradient Descent (SGD).

CBOW is typically implemented as a fully connected feed-forward neural network with the following key hyperparameters:

- $N$: Word embedding size. This dimension also implicitly influences the effective context window size considered during training.

The network architecture involves:

- An input layer representing the context words.
- One or more hidden layers with a non-linear activation function, commonly Rectified Linear Unit (ReLU):
  $$\text{ReLU}(x) = \max(0, x)$$
- An output layer that produces a probability distribution over the entire vocabulary using the softmax function:
  $$\text{softmax}(z)_i = \frac{e^{z_i}}{\sum_{j=1}^{V} e^{z_j}}$$
  where $z$ is the output vector from the previous layer and $V$ is the vocabulary size.

The model is trained by minimizing the cross-entropy loss function, which measures the dissimilarity between the predicted probability distribution and the one-hot encoded representation of the actual center word. The cross-entropy loss $L$ for a single training example is given by:
$$L(y, \hat{y}) = - \sum_{i=1}^{V} y_i \log(\hat{y}_i)$$
where $y$ is the one-hot encoded target word and $\hat{y}$ is the predicted probability distribution.

The input to the model consists of the context words. The center word is represented as a one-hot encoded vector. The context word vector used as input to the neural network is typically the average of the one-hot encoded vectors of all the context words within the sliding window.

Thus, **word order within the context is not explicitly modelled**, similar to the Bag-of-Words (BoW) approach.

The weight matrices of the neural network learn the word embeddings:

1.  Each column of the first weight matrix, $W_1 \in \mathbb{R}^{N \times V}$, represents the input embedding vector of the corresponding word in the vocabulary (where $V$ is the vocabulary size).
2.  Each row of the second weight matrix, $W_2 \in \mathbb{R}^{V \times N}$, represents the output embedding vector of the corresponding word in the vocabulary.
3.  The final word embedding for each word is often taken as the average of its input embedding (from $W_1$) and the transpose of its output embedding (from $W_2^T$).


#### Other Methods

- **WordNet**: A manually curated lexical database that groups words into sets of synonyms (synsets), provides short, general definitions (glosses), and records various semantic relations between these synsets.
    - **Limitation**: WordNet is often incomplete for most real-world applications due to the vastness and dynamic nature of language.

- **First-Order Logic (FOL)** (Eisenstein 12.2): A formal system of symbolic logic used in mathematics, philosophy, linguistics, and computer science. It extends propositional logic by allowing quantification over objects and the use of predicates to express properties and relations.

    - **Proposition**: A declarative sentence that can be either true or false and is associated with a truth value.
    - **Denotation of a proposition**: The set of all equivalent forms of a proposition that share the same truth value.
        - Example: $[[8]] = [[4+4]] = [[3+5]]$ (all denote the truth value 'true' if interpreted as mathematical equalities).

    - **Boolean operators**: Logical connectives that combine propositions to form more complex propositions (e.g., and ($\land$), or ($\lor$), not ($\neg$), implication ($\implies$), equivalence ($\iff$)).

    - **Quantifiers**: Symbols that express the extent to which a predicate is true over a range of elements:
        - **Universal quantifier**: "For all" ($\forall$).
        - **Existential quantifier**: "There exists" ($\exists$).

    - **Constants, variables, and relations**: The basic building blocks of FOL:
        - **Constants**: Symbols that represent specific objects (e.g., Italy, Rome).
        - **Variables**: Symbols that can represent any object in the domain of discourse (e.g., $x$, $y$).
        - **Relations (Predicates)**: Symbols that express relationships between objects or properties of objects (e.g., Capital($x$, $y$), is\_a($x$, country)).

    - **Example of a relation represented as a set of tuples**:
        $$[[\text{Capital}]] = \{([\text{Italy}], [\text{Rome}]), ([\text{France}], [\text{Paris}]), ..., ([\text{Norway}], [\text{Oslo}])\}$$
        This relation represents the capital city of each country in the set.

    - **Inference and discovery of new facts**: First-order logic provides a formal framework for making logical inferences based on existing knowledge, allowing for the derivation and discovery of new facts that are logically entailed by the initial set of axioms and rules.

**Optimisation** (Negative sampling, hierarchical softmax)
**Evaluation** (Intrinsic/extrinsic tasks)
    