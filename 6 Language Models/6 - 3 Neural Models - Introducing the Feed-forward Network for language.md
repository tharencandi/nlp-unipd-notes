# Neural Models - Introducing the Feed-forward Network for Language

While n-gram models provide a foundational understanding of sequence probability estimation based on local word co-occurrence, they suffer from several key limitations:

* **Limited Generalisation:** N-gram models struggle to generalise to unseen word sequences, especially those with longer dependencies or involving less frequent combinations. They treat each n-gram as a discrete unit without inherent understanding of semantic similarity.
* **Context Modelling Bottleneck:** The fixed-length context window of n-grams restricts their ability to capture long-range dependencies within a text. Information beyond the preceding $n-1$ words is effectively ignored.
* **Sparsity Issues:** As $n$ increases, the number of possible n-grams grows exponentially, leading to severe data sparsity and unreliable probability estimates for many sequences.
* **Lack of Semantic Understanding:** N-gram models operate purely on surface-level co-occurrence statistics and lack any explicit representation of word meaning or semantic relationships.

Neural language models address these shortcomings by learning distributed representations of words (**shared embeddings**) and to model sequential dependencies.

These models offer significant advantages:

* **Improved Generalisation:** By learning continuous vector representations for words, neural networks can capture semantic similarities and generalise to novel word combinations based on their underlying meaning.
* **Enhanced Context Modelling:** Recurrent neural networks, in particular, are designed to process sequential data and maintain an internal state that can theoretically capture dependencies over arbitrarily long distances.
* **Mitigation of Sparsity:** Dense word embeddings provide a smoother representation space compared to the sparse counts of n-grams, allowing models to learn more robust probabilities even with limited data.
* **Implicit Semantic Understanding:** The learned embeddings encode semantic information, enabling neural language models to make predictions based not just on surface co-occurrence but also on the underlying meaning of words.

## Feed-forward Neural Language Models

### Idea

- Get a vector representation of the previous context
	- depends on *NN architecture*
- Generate a probability distribution for the next token
    • *model-agnostic*

- Most natural choice for NN architecture is recurrent neural network (RNN) but feed-forward neural network (FNN) and convolutional neural network (CNN) have also been exploited.

### General Structure
https://lena-voita.github.io/nlp_course.html

1. A neural network for context representation

	- Input tokens (e.g., “I saw a cat on a”) are converted into **word embeddings**.
	- These embeddings go into a **neural network** (e.g., Transformer or RNN).
	- The network outputs a **context vector** h, summarising the history.

2. A linear layer
	1. The vector h is passed through a **linear layer** to produce a vector of size equal to the vocabulary $|\mathcal{V}|$
3. Softmax
	1. transform into a **probability distribution** $P(w_{t+1} \mid \text{context})$.

![[Pasted image 20250414120937.png]]

## Inference
Same approximation as N-gram model:
$$P(w_t | w{1:t-1} \approx P(w_t|w_{t-N+1:t-1})$$
Where N-1 is our sliding our sliding window for past context.
and each word $w_t$ is a one-hot vector $x_t$ of size $|V|$.

**First Layer:**

- convert each one-hot vector in the (N-1)  windowed words to embeddings of size $d$.
- Concatenate (unspecified method) $N-1$ embeddings.
For N = 4:
$$e_t = [Ex_{t-3};Ex_{t-2};Ex_{t-1}]$$
where:

- $E \in d \times |V|$ is a learnable matrix with the word embeddings
- $x_{t-i} \in |V| \times 1$ are 1-hot representations of word $w_{t-i}$
- $e_t \in 3d \times 1$ is the concatenation of the embeddings of the \( N - 1 \) previous words

**Remaning layers**

$$h_t = g(We_t + b)$$

$$z_t = Uh_t$$

$$\hat{y}_t = z_t$$

where

- $W : d_h × 3d$ is a learnable matrix, $d_h$ the size of the second hidden vector representation
- $b : d_h × 1$ is a learnable vector
- $h_t : dh × 1$ is obtained through some activation function g
- $U : |V | × dh$ is a learnable matrix
- $zt , ŷt : |V | × 1$ scores and distribution (see next slide)
-
The vector $z_t$ can be thought of as a set of scores over |V |,also called logits: raw (non-normalised) predictions that a classification model generates

Passing these scores through the softmax function normalises them into a probability distribution

The element of $\hat{y}t$ with index $ind(w_t )$ is the probability that the next word is $w_t$ :
$$\hat{y}[ind(w_t)] = P(w_tw_{t-3:t-1})$$

## Training
The parameters of the model are θ = E , W , U.
The number of parameters is |V |, since d is a constant.

- Let $w_t$ be the word at pos $t$ in training.
	- the true distribution $y_t$ for word at t is a 1-ht vector of size $|V|$:
	- $y_t [ind(w_t )] = 1$
	- $y_t [k] = 0$ everywhere else
Apply cross-entropy loss for training the model:

$$L_{CE}(\hat{y}_t,y_t) = -\sum^{|V|}_{k=1}y_t[k]log\hat{y_t}[k]= -log\hat{y_t}[ind(w_t)]$$
$$L_{CE} (ŷ_t , y_t ) = − log P(w_t w_{t−N+1:t−1} )$$

- cross-entropy loss equals the negative log likelihood of the training data

- Discussion
	- Feedforward NLM learns word embeddings E simultaneously with training the network.
	- This is useful when the embedding should be customised for the task at hand, e.g. in sentiment analysis.
	- Alternatively, one can resort to freezing:
		- use pretrained word embeddings, for instance word2vec
		- hold E constant while training, and modify the remaining parameters in θ

Contrastive evaluation is used to test specific linguistic constructions in NLP.

- The task of subject object agreement we can compare:

$$P(is|..) \text{ with } P(are|...)$$

## Contextual generation

Add context to kick-start generation.

- The language model will produce

$$p(x | context)$$

This is the basis for solving many NLP tasks.

## Generation Strategies

Given a language model that produces a probability distribution given nothing or some context there are different strategies for sampling this distribution that have different effects. We can understand these strategies by first establishing qualities our generated text should posses.

There is a trade-off between:

- Coherence - the sensibility of the sentence
- Diversity - the uniqueness of the sentence

**Strategies:**

- Greedy - picking the most likely
	- Results in very coherence sentences but with little diversity
- random sampling
	- use the distribution as the probability for which to select
	- this overvalues diversity, as there are many more rare words with low probability that sum to a high probability.

- Top-k and Top-p (nucleus)
	- select the k most likely words, re-normalise and apply random sampling
	- this eliminates very rare words
	- this works effectively when the top k include the majority of the probability mass
	- if the distribution is flat, the topk represents only a small portion of the probability mass
- Top p
	- keep the top p percent of the probability mass
	- select the smallest set of words $V^(p)$ s.t
$$\sum_{w \in V^{p}} P(w|w_{<t}) \geq p$$
Temperature

- A tool to reshape the probability distribution according to the coherence - diversity trade-off

$$y = softmax(V/\tau)=\frac{exp(\frac{V_ih_t}{\tau})}{\sum_jexp(\frac{V_jh_t}{\tau})}$$

- τ =1 leaves y unchanged
- τ >1 flattens it
- τ <1 makes it skewed
