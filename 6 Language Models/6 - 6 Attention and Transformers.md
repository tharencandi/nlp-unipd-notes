# Attention and Transformers

The transformer is the standard architecture for building large language models.

## Attention is All You Need

(attention modified LSTM)

### High-Level overview

Attention can be thought of as a way to build contextual representations of a tokens meaning by attending to and integrating information from surrounding tokens, such that the model can learn how tokens relate to each other over large spans (*contextual embeddings*).

- Attention could be used to analyse what the neural network consider important to solve a task
- Ex. what input words are important when generating one translated output word
- What words are indicative of a positive/negative sentiment
- Attention could be defined hierarchically, for example to encode a document given its sentences
- Hard Attention (focuses on one element,possibly favouring interpretability)

### Theory

- Attention [1] is a mechanism developed to overcome the issues of the RNNs
- In practice it is a block of a NN
- It is the main component of a novel class of Neural Networks Architectures, the Transformers [2]
- Attention mimics the retrieval of a value vi for a query q based on a key (address) ki in a database (memory)
$$attention(q, k, v ) = \sum_i similarity (q, k_i )v_i$$

- Simplified it is the weighed sum $a_i = \sum a_{ij}x_j$
	- $a_{ij}$ - how much x should contribute to $a_i$
[1] Bahdanau et al. “Neural Machine Translation by Jointly Learning to Align and Translate”
[2] Vaswani et al. “Attention Is All You Need”

### The Attention Head
Intuitively, attention constructs a summary vector of all words that is weighted to the relevance of our task, with a query vector q that represents the task indicator.

- **Query**: The current element being compared to the preceding inputs
 - **Key**: the preceding input being compared to the current element
 - **Value**: a value associated with the key that gets weighted and summed to compute the final output for the current element.

$$attention(q, k, v ) = \sum_i similarity (q, k_i )v_i$$

- To capture these roles we use three matrices:
	- $q_i = x_iW^Q$
	- $k_i=x_iW^K$
	- $v_i=x_iW^V$

- q can be learnt as a parameter of the network
$$score(x_i,x_j) = \frac{q_i \cdot k_j}{\sqrt{d_k}}$$
$$\alpha_{i,j}=\sum_{j\leq i}\alpha_{i,j}v_j$$
$$head_i = \sum_{j \leq i}\alpha{i,j}v_j$$
$$a_i = head_iW^O$$

### Attention applied to Encoder-Decoders

Instead of one single context vector $c$ that summarises the information of the encoder, let $c$ depend on the previous state of the decoder:

$$c_i = f(h_1^e...h_n^e,h^d_{i-1})$$
In the decoding phase
$$h^d_i = g(\hat{y_{i-1}},h^d_{i-1},c_i)$$

- the hidden state of the decoding phase depends on a **different context for each token**.
- it allows each $\hat{y}_i$ to focus on each encoder state (different parts of the input sentence) via the custom $c_i$ .
- Attention assumes that all hidden states are explicitly available
- Many-to-many relationship between output and input-hidden states
	- Long term relationship can be exploited

$$attention(q,k,v) = \sum_isim(q,k_i)v_i$$
such that

- $sim(q,k_i) = q^Tk_i$
- $sim(q,k_i) = q^TWk_i$
	- weights W learned
	- q and k do not have to be in same space
- $sim(q,k_i) = w^T_q tanh(W[q;k_i]$

## Transformers

### Transformer - Encoder

Transformers are designed to process whole sentences **in parallel** by exploiting the computational model of GPUs (decoder is still sequential).

The transformer applies positional encoding to the input embedding based on sin and cosine functions.

Transformers use *scaled* attention, such that (query, key) = pairs of input words.

- Normalisation is used to avoid low gradient areas of the softmax function

$$Attention(Q,K,V) = softmax (\frac{QK^T}{\sqrt{dk}})V$$

A single head of attention:

- The Attention system creates an embedding such that each word attends to every other word.

Multi-Head attention (N heads)

- multiple attention matrices are computed with different initial conditions and then combined.
- each head captured different relations.
- $A$ separate attention heads that reside in parallel layers at the same depth in a model
	- each with its own set of parameters that allows the head to model different aspects of the relationships among inputs.
	- each head i in a self-attention layer has its own set of key, query and value matrices to project the inputs into separate key, value, and query embeddings for each head.

For each attention head, the attention embedded is added with the positional sentence embddings and normalised which

1. bias the representation to be similar to the input
2. avoids small gradients

## Transformer - Decoder

The decoder unit uses **masked attention** which forces some values not to used in computation. i.e only consider previous words to predict next work, by setting discarded entries to -inf in the attention matrix.

$$maskedAttention(Q,K,V) = softmax(\frac{Q^TK+M}{\sqrt{d_k}})V$$

In multi-head decoder attention blocks the queries are

- the previous outputs in the prediction phase
- the gold labels during training

## Pre-training

- same as Feed-forward Neural Language models
- require a lot of data (transformers tend to be much larger in size)
- how to avoid toxic and private info, how to get more data?

## Fine tuning

After pre-training fine tuning an LLM is the processes of training on a specific task or domain with new data.
Fine tuning tends to be done with frozen layers such that training is a less expensive operation.
