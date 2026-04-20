# Sentence and Document Embeddings

We have so far looked at how we can make word/token embeddings. Which is a powerful tool for a variety NLP downstream tasks and is also useful as input for training LLM models.

But how should we deal with larger entities of text (sentences, documents)?

The resolution of word embeddings cannot capture all relevant meaning when words are structured in sentences, phrases, paragraphs, whole documents.

There are a plethora of downstream tasks that require more powerful representations.

## Sentence embeddings

### Weighted Average
For word embeddings of size k, for each of the n words in a sentence, we can apply a  function on such vectors.
$$f(W) = s$$
$$W : n \times k; s : 1 \times k$$
The most simple is a weighted average function$$f(w_1,...,w_n) = \frac{1}{n} = \sum_iw_i$$
However - the meaning of a sentence is a *non-trivial* combination of the meaning of words, dependent on **order**. This representation cannot capture this meaning.

### BERT for sentence embeddings

We have looked at BERT as a language model. The architecture has a dual purpose to produce sentence embeddings. Both the masked token prediction  and sentence embedding goals are trained separately.

- Sentence embeddings are trained with BERT by predicting whether a two given sentences are adjacent or randomly sampled.

Input structure
$$\{<CLS>,sentence_1,{<SEP>},sentence_2,<SEP>\}$$

Where the $<CLS>$ token can be used as a sentence embedding

see also [[6 - 7 BERT and Masked LLMs#NSP - Next Sentence Prediction - Sentence embeddings with BERT|Sentence embeddings with BERT]]

### Auto-Encoders for sentence embeddings

Dai et Al - Semi-supervised Sequence learning

- An Encoder-Decoder RNN to reproduce the input sentence as output.
- reproduce sentence through a squeezed/compressed hidden representation minising information loss (standard autoencoder goal)
- Unsupervised data allows for large dataset use.
	- increased performance on sentiment analysis, text classification

This idea has been extended to LSTM encoder-decoders by Kiros et all with **Skip-thought vectors**

#### Skip thought vectors
Trained on BookCorpus Dataset/
goal: reproduce the previous AND next sentence

- this biases the model to learn sentence meaning within context of neighbouring sentences. Which is a good assumption for extracting the meaning of a sentence.

he encoder builds a representation for one sentence; a pair of
sentences is represented as: $[ |u-v|; u⊗v ]$

Skip thought vectors can also be used to transfer word presentations from one model to another - which deals with an important problem. certain nouns may be under or over represented in different training corpuss, which result in different meanings.

- learn a mapping from a word in word2vec space to a word in an encoders vocabulary space.
$$f : V_{w2v} \rightarrow V_{sk}; f(v) = Wv$$

where

$$V_{w2v} >>V_{sk}$$

Explain more:

### SimCSE - Simple Contrastive Learning of Sentence Embeddings

Supervised approach:
Given a batch of examples, that is pairs $(x,x^+)$ minimise the following
$$L_{align} = E_{(x,x^+)\in pos} ||f(x)-f(x^+)||^2$$

- This pushes together semantically related examples through the process of alignment
- For better distribution. Check unformity or push apart unrelated sentences.
- Gao et al. “SimCSE: Simple Contrastive Learning of Sentence Embeddings

#### Supervised approach

 1. Wieting et al. “Towards Universal Paraphrastic Sentence Embeddings”

	- use sentences in *Entailment* as positive labels
	- use contradicting sentence as hard negatives (to push apart)
		- the use of hard negatives improves 84.9 - > 86.2
	-

		- use the data from the Paraphrase Database (about 3,033,753 phrase pairs) to train a number of models
		- averaging word vectors still perform better than LSTM with this approach - why?

Reimers et al. “Sentence-BERT: Sentence Embeddings using Siamese BERT-Networks”
**Sentence-BERT (SBERT)**
![[Pasted image 20250615204134.png]]

- siamese network - shared weights for Sentence A and Sentence B BERT Models
- pool mean output of all vectors
- triplet loss
	- why?
	- Triplet loss: max(||sa − sp || − ||sa − sn|| + ϵ, 0) (left) or mean square error (right)

2. machine translation for automatic generation of sentence pairing
	1. if parallel data is available, pair sentence in target with translation
	2. if no parallel data: translate then translate back

#### Unsupervised approach

- with any supervised learning approach how biggest limitation is the training dataset. Thus an unsupervised SimCSE has been devised
Selecting positive paris:

- note that it is not inherently about different words, but rather different embeddings so we can exploit the architecture of an encoder to generate different but similar embeddings
- split data into batches
- obtain positive pairs by passing input sentence to pre-trained encoder twice with independently sampled dropout masks
- Dropout = data augmentation
- negative pairs are formed by mismatching positive pairs (given to pairs take one from one and one from another)
results

- STS dataset - sentence similarity, spearman correlation
- evalaute different dropout probabilities.
- f p = 0.1 yields best performance

## Document Embeddings

For a number of tasks, such as topic modelling, representations of objects beyond the sentence level are required.

Unlike sentence embeddings, where we care about detailed semantics. A majority of tasks that require document level analysis typically only need to capture *aboutness*.

### BoW

- express a document as a weighted combination of word vectors
	- down-weighing stop words
- using different combinations of n-grams

### Compositional Approach
Hermann et al. “Multilingual Models for Compositional Distributed Semantics”
https://www.aclweb.org/anthology/P14-1006.pdf

Multi level approach for document representations

- extends the distributional hypothesis to multilingual data and joint-space embeddings.
- by recursively applying the composition and objective function (Equation 2) to compose sentences into documents.
- This is achieved by first computing semantic representations for each sentence in a document. Next, these representations are used as inputs in a higher-level CVM, computing a semantic representation of a document
- This recursive approach integrates document level representations into the learning process. We can thus use corpora of parallel documents— regardless of whether they are sentence aligned or not—to propagate a semantic signal back to the individual words.

![[Pasted image 20250606150957.png]]

## Paragraph embeddings
Dai et al. “Document Embedding with Paragraph Vectors”https://arxiv.org/pdf/1507.07998.pdf
Quoc V. Le et al. “Distributed Representations of Sentences and Documents https://arxiv.org/pdf/1405.4053
Paragraph vector∗∗ is an extension of a language model with an
additional element to keep info on the full context

- Used to give context to the next-word prediction task
- Such information becomes the representation of the document
- use paragraph matrices, with an averaging or concatenation process, for final classification.
- another approach
- https://www.aclweb.org/anthology/2020.acl-main.30.pdf
- (Mekala et al., “Contextualized Weak Supervision for Text Classification”)
