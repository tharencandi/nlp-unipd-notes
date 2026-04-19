Parsing is a fundamental task in NLP


"**Syntactic parsing** is the automatic analysis of [syntactic structure](https://en.wikipedia.org/wiki/Syntax "Syntax") of natural language, especially syntactic relations (in [dependency grammar](https://en.wikipedia.org/wiki/Dependency_grammar "Dependency grammar")) and labelling spans of constituents (in [constituency grammar](https://en.wikipedia.org/wiki/Constituency_grammar "Constituency grammar")).

Why?
To solve the problem of structural ambiguity.


**Constituents**
- a group of words that act as a single unit
- including "noun phrases"
	- The Broadway coppers love
	- noun phrases can be relocated but the internal ordering cannot.

We can construct a constituency tree of a given sentence using context free grammars.

but there is an inherent problem of **ambiguity**.
As a result, constituency trees can produce gramatically correct but semantically unreasonable parses.
	chomsky famous example
		[Colorless green ideas sleep furiously](https://en.wikipedia.org/wiki/Colorless_green_ideas_sleep_furiously "Colorless green ideas sleep furiously")

A constituency tree has words has leaf nodes
and syntax grammar categories ( NP, N, V, S) as internal nodes (CFG)

![[Pasted image 20250615191237.png]]

## Dependency Parser

- words can be leaf or internal nodes
- descendants enrich the head nodes. 
- encodes semantic information such as 
	- objects and subjects (who did the action specified by verb)
- edges can be labelled with a relation
	- clausal argument relations
	- nominal modifier relations
	- conjunctions

### Representation
each word 1 to n in sentence has edge (word, head, relation)
![[Pasted image 20250615191302.png]]
![[Pasted image 20250615191318.png]]
### Techniques

#### Graph-based
- combinatorial optimisation problem over a restricted set of dependency trees

Given sentence $x$ and set $Y(x)$ of candidate DepTrees. 
Find highest-scoring tree 
$$\hat{y} = argmaxscore_{y \in Y(x)}(x,y)$$
- choice of Y(x) and scoring function determines the effectivness and efficiency of the algorithm
#### Arc-factored Model

This is a general formulation that decomposes the scoring function to more managable subproblems. 

What is an arc:
- 

Score of the tree is the sum of the scores of its arcs.


$$\hat{y} = argmaxscore_{y \in Y(x)}\sum_{a \in y}score(x,a)$$
Under the arc-factored model, the highest-scoring dependency tree can be found in O(n3) time (n = sentence length)
 -> Maximum spanning tree over a directed graph with all dependency relations


we still havent defined a scoring function for an arc.


#### Trainsition-Based Approaches

graphs are too high complexity for large datasets.  We instead use a local classifier to build a single dependency tree iterativley, thus in linear time.

1. start with an empty tree
2. select highest probable transition and add to tree
3. repeat until terminal configuration is reeached

##### Arc-Standard Algorithm

Limitation: can only predict projective dependency trees.

projective tree:
- given a head and a dependant, there is a path to every between between h and d 
- Projective: "Yesterday Lucia at a pizza which was vegeterian"
- Not projective: "Lucia ate a pizza yesterday which was vegeterian"
![[Pasted image 20250609151421.png]]
![[Pasted image 20250609151435.png]]

**Algorithm** ->  in exam
arcstandard
## Arc-Standard Dependency Parsing Algorithm

A transition-based dependency parser incrementally builds a dependency tree using three components:

## Data Structures

- **Buffer**: holds the remaining input words  
  Initially: all words in the sentence  
- **Stack**: holds partially processed words  
  Initially: empty  
- **Arcs**: the growing set of dependency relations (edges)  
  Initially: empty

## Transitions

Let `s` be the top of the stack, and `s2` be the second-topmost element.

**SHIFT**  
Move the first word from the buffer onto the stack  
→ `stack.push(buffer.pop_front())`

**LEFT-ARC**  
Add an arc: `s → s2`, and remove `s2` from the stack  
→ `arcs.add(s → s2); stack.remove(s2)`

**RIGHT-ARC**  
Add an arc: `s2 → s`, and remove `s` from the stack  
→ `arcs.add(s2 → s); stack.pop()`

## Transition Validity

- **SHIFT** is valid if the buffer is **not empty**
- **LEFT-ARC** and **RIGHT-ARC** are valid if the stack contains **at least two items**

## Pseudocode

```python
def arc_standard_parse(words, classifier):
    buffer = list(words)
    stack = []
    arcs = set()

    while not (len(buffer) == 0 and len(stack) == 1):
        valid_transitions = get_valid_transitions(buffer, stack)
        action = classifier(buffer, stack, arcs, valid_transitions)

        if action == "SHIFT":
            stack.append(buffer.pop(0))
        elif action == "LEFT-ARC":
            head = stack[-1]
            dep = stack[-2]
            arcs.add((head, dep))
            stack.pop(-2)
        elif action == "RIGHT-ARC":
            head = stack[-2]
            dep = stack[-1]
            arcs.add((head, dep))
            stack.pop()

    return arcs
```

#### Valid transitions
- SH is valid if the buffer contains at least one word.
- LA and RA are valid if the stack contains at least two words. The number of transitions that the arc-standard algorithm takes to build a tree for a sentence with n words is 2n − 1.

#### Soundness
-  Every valid transition sequence that starts in the initial configuration and ends in some terminal configuration builds a projective dependency tree.
#### Completeness
- Every projective dependency tree can be built by some valid transition sequence that starts in the initial configuration and ends in some terminal configuration



[1] Chen et al. “A Fast and Accurate Dependency Parser using Neural
Networks” (https://www.aclweb.org/anthology/D14-1082)
The classifier can use the following features:

- the words in the buffer the words on the stack the partial dependency tree
- The classifier has been implemented as a feed forward neural network in [1] State-of-the-art performances in 2014

#### Chen & Manning Neural Classifier for Arc-Standard Parsing (2014)

Chen and Manning (2014) propose a **transition-based dependency parser** that replaces sparse indicator features with **dense, learned embeddings**, scoring transitions via a **feedforward neural network classifier**. This approach offers both **higher accuracy** and **significant speed gains** compared to prior parsers.

##### Key Idea
Use a **greedy neural network classifier** to decide the next transition (SHIFT, LEFT-ARC, RIGHT-ARC(label)) in the **Arc-Standard parsing system**.

###### Model Architecture

##### Inputs
From the current configuration (stack, buffer, arc set), extract:
- Word embeddings (Sw)
- POS tag embeddings (St)
- Dependency label embeddings (Sl)

##### Example feature elements:
- Top 3 elements on stack and buffer
- First/second left/right children of top two stack elements
- Left-of-left/right-of-right children
- POS tags and dependency labels of above

This gives:
- $n_w = 18$ word features
- $n_t = 18$ POS tag features
- $n_l = 12$ label features

Each feature has a fixed embedding dimension $d$ (e.g., 50).

#####  Feedforward Network
Hidden layer with **cube activation**: $g(x) = x^3$

- Input vector: concatenation of all feature embeddings
- Hidden layer:
  $$ h = \left(W_1^w x^w + W_1^t x^t + W_1^l x^l + b_1\right)^3 $$
- Output layer: softmax over all valid transitions
  $$ p = \text{softmax}(W_2 h) $$

#####  Motivation for Cube Activation
Allows modeling of 3-way feature interactions:
- Can approximate feature conjunctions like (POS of s1, POS of s2, POS of b1)
- Empirically outperforms tanh and sigmoid in UAS and LAS
##### Training

- **Objective**: Minimize cross-entropy loss + $L_2$ regularization
  $$ \mathcal{L}(\theta) = -\sum_i \log p_{t_i} + \frac{\lambda}{2} ||\theta||^2 $$
- **Data**: Training pairs $(c_i, t_i)$ from gold-standard transitions using a *shortest stack oracle*
- **Optimization**: Mini-batch AdaGrad
- **Pre-trained Embeddings**: Used for words; POS/label embeddings learned from scratch
##### Inference

- Greedy decoding
- At each step:
  1. Extract current config features
  2. Feed into network
  3. Pick highest-scoring valid transition
- **No beam search** (but possible to add)

##### Performance

| Parser        | UAS (PTB-CD) | LAS (PTB-CD) | Speed (sent/s) |
|---------------|--------------|--------------|----------------|
| Arc-standard  | 89.7         | 88.3         | 51             |
| Arc-eager     | 89.9         | 88.6         | 63             |
| MaltParser    | 89.9         | 88.5         | 560            |
| MSTParser     | 92.0         | 90.5         | 12             |
| **Chen+Manning** | **92.0**   | **90.7**     | **1013**        |

- Achieves **2% higher accuracy** than standard parsers
- Over **20× faster** than traditional feature-rich models
##### Analysis & Insights

- POS tag embeddings contribute most to performance
- Arc label embeddings have marginal additional benefit when POS is used
- Learned features match or exceed hand-crafted conjunctions (e.g., s1.t, rc1(s2).t)
- Visualizations show clustering of related POS tags and labels in embedding space (via t-SNE)


## Neural Approach to Dependency parsing
## Neural Dependency Parsing: BiLSTM and Biaffine Models

### [1] Kiperwasser & Goldberg (2016)  
**“Simple and Accurate Dependency Parsing Using Bidirectional LSTM Feature Representations”**  
<https://www.aclweb.org/anthology/Q16-1023>

### Key Idea

Use a **minimal set of core features** derived from **contextualised word representations** produced by a **BiLSTM encoder**, replacing the need for extensive manual feature engineering.

- Inputs: word, POS tag embeddings → concatenated → fed into BiLSTM
- Output: contextual vector $v_i$ for each word position $i$ in the sentence

---

### Transition-Based Variant

- Extract BiLSTM representations for:
  - Top 3 words on the **stack**
  - First word in the **buffer**
- Concatenate and feed into a **feedforward network** to score actions (SHIFT, LEFT-ARC, RIGHT-ARC)

---

### Graph-Based Variant

- Treat parsing as a **head–dependent scoring** problem
- For each possible arc $(h, d)$:
  - Compute score using BiLSTM representations
  - Predict the head for each word (maximum score)

#### Loss Function

Use a **margin-based hinge loss** to encourage the correct tree:

$$
\mathcal{L}(\theta) = \max\left(0, 1 + \max_{y \neq y^*} \text{score}(x, y) - \text{score}(x, y^*)\right)
$$

Where:
- $x$: sentence
- $y^*$: gold dependency tree
- $y$: any incorrect tree

---

## [2] Dozat & Manning (2017)  
**“Deep Biaffine Attention for Neural Dependency Parsing”**

### Key Idea

Use a **deep BiLSTM encoder** + **biaffine scoring mechanism** to model head–dependent relationships with greater precision.

### Architecture

1. **BiLSTM Encoder**  
   Produces a contextual vector $v_i$ for each word

2. **MLP Projections**
   Project each word vector into two roles:
   - As a potential **head**: $h_i = \text{MLP}_h(v_i)$
   - As a potential **dependent**: $d_i = \text{MLP}_d(v_i)$

3. **Biaffine Scoring**
   Compute an arc score between every head–dependent pair:

   $$
   s(h_i, d_j) = h_i^T U d_j + W^T (h_i \oplus d_j) + b
   $$

   - Combines bilinear and affine terms for richer interaction
   - Used to score both **arcs** and **labels**

---

## Summary of Comparative Performance

| Model                          | Type             | Performance (UAS/LAS) | Notes                    |
|-------------------------------|------------------|------------------------|--------------------------|
| Chen & Manning (2014)         | Transition-based | Worst                  | Feedforward + hand features |
| K&G Graph-based (2016)        | Graph-based      | Second worst           | BiLSTM, margin loss      |
| K&G Transition-based (2016)   | Transition-based | Second best            | BiLSTM, simpler scoring  |
| Dozat & Manning (2017)        | Graph-based      | Best                   | Biaffine scoring         |

---

## Takeaways

- **Kiperwasser & Goldberg** show that BiLSTM + minimal features is enough for both transition and graph-based parsing.
- **Dozat & Manning** improve the scoring function by specializing word vectors for head/dep roles and using biaffine attention.
- **Transition-based** parsers are fast and greedy, but may be less accurate.
- **Graph-based** parsers score all possible arcs, supporting global inference and typically achieving higher accuracy.
