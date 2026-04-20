# Encoder-Decoder Models

**Motivation for variable length input/output:**

- Input length does not equal output length
- Applications: machine translation, summarisation

Encoder-Decoder is a general structure for LLM models and can be built from any of the other models we have seen (RNN, LSTM, Transformers).

## Encoder-Decoder Architecture

A general architecture that learns to produce context, and generate output sequences based given context.

- The encoder given an input sequence will produce a hidden state
  $$x_1,...x_n \rightarrow h1_,..,h_n$$

- This hidden state will be compressed into a contextual/compressed representation.
$$h_1,...,h_n\rightarrow c$$

- This representation can be decoded to a state of an any chosen length.
$$c\rightarrow h_1,...,h_m$$

## Translation with encoder decoders
This formulation is particularly useful for translation, and was first used for this task.

We will look at the translation task from an RRN encoder-decoder

$$p(y |x ) = p(y_1 |x )p(y_2 |y_1 , x )p(y_3 |y_1 , y_2 , x ) \rightarrow p(y_m |y_1 , . . . , y_{m−1} , x )$$

By using a separator token $<s>$ we can discriminate the end of the input sentence and where we start generating.

1. compute c based on text before $<s>$
2. start generate y_t based on $y_{<t}$ and c
3. avoid polluting c:

	- do not update c during generation so that yt is conditioned on the same c vector.

$$h_t^d = g(\hat{y}_{t−1} , h_{t−1}, c)$$

$$c = h_n^e$$
$$h_0^d = c$$

$$\hat{y}_t = softmax (h_t^d )$$

### Training

- input example is a pair of sentences separated by $<s>$
- training is standard with teacher forcing.
