# Sequence Modelling - RNNs and LSTMs

**Sequence-based architectures and associated tasks**

## What is Sequence Modelling?

- Input/Output types
- Text as sequential data

## Recurrent Neural Language Models (RNN LMs)

Uses recurrence to model sequences (transduction) s.t the hidden state is a summary of the input. trained via BPTT which uses shared weights.

See Jurafsky chapter 9.1 for definition and training of recurrent neural networks.

### Inference

RNN languages process the input one word at a time and do next token prediction at each time step:

- the current word is used
- previous hidden state is used

RNNs can model the probability distribution:
$$P(w_t|w_{1:t-1})$$ without the $N-1$ window approximation of FFNNs

In principle the hidden state can represent information from all preceding words but the information retrained tapers with time steps. In reality, only local information is used.

### Model Definition

$$e_t= Ex_t$$ $$h_t= g(Uh_{t−1} + We_t )$$
$$\hat{y}_t= softmax (Vh_t )$$

where:

- $d_a$
	- the size of the hidden vectors
-  $x_t : |V | × 1$
	- 1-hot representation of word wt
- $E : d × |V |$
	- learnable matrix with the word embeddings
- $U, W : d × d$
	- learnable matrices
-  $h_t : d × 1$
	- the hidden vector at step $t$
- $V : |V | × d$
	- learnable matrix
-  $ŷt : |V | × 1$
	- probability distribution

**weight tying**:

- since both E and V are word embeddings , we can use one matrix E and $E^T$ instead of two.

$V_{a_t}$ records the logits (unormalised scores) over the vocabulary given context of $a_t$.

softmax of logits is $\hat{y_t}$ is the estimated distribution.

For each word $w \in |V|$:
$$\hat{y}_t[ind(w)]=P(w_{t+1} = w|w_{1:t})$$

### Training

- The number of parameters of the model is $O(|V|)$
- We apple cross-entropy loss to minimise the error of predicting the next true word from time-step $t$.
$$L_{CE}(\hat{y_t},y_t) = -\sum_wy_t[w]\times log( \hat{y_t}[w]) = -log(\hat{y_t}[w_{t+1}])$$
We apply teacher forcing at each time step:

- use the correct previous sequence of tokens
- Disadvantage: model is never exposed to prediction mistakes and cannot recover from inference time errors.

### Issues
RNNs suffer from the vanishing gradient problem:

- Past events have weights that decrease exponentially with the distance from actual word wt .
- Gated recurrent units (GRU) and long-short term memory (LSTM) neural networks are better in capturing long distance relations.

## Other RNN Models

### Bidirectional RNNs

Combines two independent RNNs

1. the input is processed from the start to the end
2. from the end to the start.

We then concatenate the two representations computed by the
networks into a single vector

$$h_t = [h_t^f;h_t^b]$$

## Long Short-Term Memory Networks (LSTM)

RNN are great at using **local context information**, modelling transduction with a windows pattern. RNNs fail to exploit long distance information.

LSTMs are designed to learn what to remember via a gating mechanism.
For each time step t

- hidden state $h_t$
- context vector $c_t$

Both $h_t$ and $c_t$ are dependent on gates

- forget gate
- add gate -> for context
- output gate -> for hidden state

Let
$$a = [a_1 , a_2 ; . . . , a_n ] \in \Re^n$$ $$b = [b_1 , b_2 ; . . . , b_n ] ∈ \Re^n$$ Then
$$a \odot b = [a_1 · b_1 , a_2 · b_2 , . . . , a_n · b_n ] \in \Re^n$$

### Gate definitions

1. Forget Gate
$$f_t = \sigma(U_f h_{t−1} + W_f x_t )$$

$$k_t = c_{t−1} \odot f_t$$

	- $k_t$ is the previous context with some information removed;

2. Add gate

$$g_t = tanh(U_g h_{t−1} + W_g x_t )$$
$$i_t = \sigma(U_i h_{t−1} + W_i x_t )$$
$$j_t = g_t ⊙ i_t$$

	- $j_t$ is the information from the previous hidden state that will  be added to the context

	- the new context is $ct = j_t + k_t$

3. Output Gate
$$o_t = \sigma(U_o h_{t−1} + W_o x_t )$$
$$h_t = o_t \odot tanh(c_t)$$
