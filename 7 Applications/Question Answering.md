# Question Answering

So far we have focused on various aspects of NLP that can be used as building blocks for further downstream tasks. One such application of these techniques is Question Answering.

At its core Question Answering are systems that are designed to automatically provide an answer for a question asked in natural language.

## General QA system overview

User question -> Question Analysis -> Search of Documents -> Extraction of answer -> Answer

## Types of QA

There is a taxonomy of types of question answering systems within the literature.

1. Factoids
2. Why
3. How
4. Request for summaries

QA systems can be built across closed or open domains.

- This has a large impact on the systems.
- Closed domains are usually much easier, as the questions and answers can be statically generated and a similarity function can be used for real time inference (knowledge base of question-answers)

### Sub-tasks

1. Source - extracting the necessary context.
	1. sets of documents to compose the corpus
	2. a single document
	3. knowledge base
	4. non linguistic datatypes
2. Answer - generating the answer
	1. fact
	2. explanation
	3. document
	4. sentence/paragraph extract or paraphrase
	5. image
	6. another question
3. Reading comprehension
4. Visual QA
5. Information retrieval
6. Community Question answering

## Case Study: SIRI as a QA System

1. **Automatic Speech Recognition (ASR)**
   Converts human speech into raw text. This component is optimized for short utterances, including questions, commands, or dictations.

2. **Natural Language Processing (NLP)**
   Performs syntactic analysis to translate raw transcriptions into structured text using techniques such as:

   - Part-of-speech tagging
   - Noun phrase chunking
   - Dependency and constituency parsing

3. **Intent and Question Analysis**
   Analyses the parsed text to detect:

   - User commands and actions (e.g., “Set my alarm”)
   - Information-seeking questions requiring retrieval

4. **Information Retrieval and API Access**
   SIRI determines whether it can answer a question internally or whether it must delegate it to an external service.

   - If internal capabilities are insufficient, it forwards the query to more general QA systems like **WolframAlpha**.
   - This is particularly used for open-domain factual queries.

5. **Text Generation**
   Takes structured data returned from external services (e.g., weather APIs) and converts it into natural language output.

   - Example: `"sunny", 25°C` → “The weather will be sunny tomorrow.”

6. **Text-to-Speech (TTS)**
   Transforms the generated text into synthesized spoken language, completing the pipeline.

## Corpora for Reading Comprehension

Several large-scale datasets have been developed for training and evaluating reading comprehension systems, including **CNN/DailyMail**, **CBT** (Children's Book Test), and **SQuAD** (Stanford Question Answering Dataset).

These datasets share common assumptions:

- The context passage is read on the fly and is unknown during training
- The answer is contained within the context as a single word or continuous span
- The task requires extracting relevant information rather than generating new text

## Language Models as Knowledge Bases

Large language models can serve as knowledge bases for answering factoid questions—questions that can be answered with a simple template or direct fact. For example, "Who wrote Pride and Prejudice?" can be answered with "Jane Austen."

However, this approach faces a significant challenge: **hallucination**. Language models may generate plausible-sounding but factually incorrect answers. This risk can be somewhat mitigated by ensuring that the relevant factual information was included in the model's training data, though this is not a complete solution.

### Introduction to Retrieval-Augmented Generation (RAG)

Since it is not feasible for all needed information to be present during training (due to prohibitive retraining costs), a more practical approach is to augment the retrieval capabilities of an LLM by automatically injecting relevant context into the query using a templated prompt. This technique is known as **Retrieval-Augmented Generation (RAG)**.

To retrieve relevant information, we leverage information retrieval techniques, which we'll explore next.

### Information Retrieval (IR)

- given query order list of documents by relevancy
- represent terms in documents by TF-IDF
- relevancy is TF-IDF frequency
- represent the query and document with a vector size of vocab and tf-idf representations for each do

$$score(q,d) = cos(q,d) = \frac{q}{|q|} . \frac{d}{|d|}$$

- BM25 TF-IDF extension
  - weights the contribution of term and controls importance of documents normalisation
$$score(D,Q) = \sum^n_{i=1}IDF(q_i). \frac{f(q_i,D).(k_1+1)}{f(q_i,D)+k_1.(1-b+b.\frac{|D|}{avgdl})}$$

- $f(qi,D)$ =frequency of $q_i$ in D
- $|D|$=num. of words in D
- $avgdl $= average document length
- $k1, b$ are hyperparameters $(k1={1.2,...,2.0}; b=0.75)$

- The above works when word forms in query are present in documents but this is not always the case
-  a simple quasi fix is to augment the query with synonyms but this has limits
- a more robust approach would be to use word embeddings

#### Neural Models

- use NN with a single encoder, self-attention sees tokens of the query and the document
- build repre sensitive to the meaning of both query and document

1. encoide context document and question
2. read question then attend to context
3. joint representation to gen answer
	1. attention mapping from joint rep
	2. classify over set of candidate answers

What about for reading comprehension?

- query encoding
- each token of document encoding
- representation r of the document d = weighted sum of token vectors. weights = models attention
- joint document query embedding is a non linear combination
- G(q,d) = tanh(W_1r(d) + W_2r(q))

## Sliding window for span-based QA
only use information within a sliding window
find the sliding window through the maximal BoW similarity between answer and window

Logistic Reression SQuAD baseline

- features from the candidates
  - lengths, bigram freq, word freq, span POS tags, lexical features, dep tree path features
  - use features for final prediction
Neural approach

- FastQA
	- basic features indicate whether a token in a passage appears in the question
	- weight features with similarity of the context and query

![[Pasted image 20250615203953.png]]

- Attention over attention

![[Pasted image 20250615204032.png]]

## Multi-step Reasoning

Some QA problems require multiple pieces of evidence, spread across different parts of the context. Multi-step (or multi-hop) reasoning allows models to **incrementally attend** to relevant parts of memory, chaining information step by step.

The model accesses external memory $\mathbf{m} = \{m_1, \dots, m_N\}$ (e.g., sentences, passages) and refines its attention over several steps before producing an answer.

**Intuition: When More Reasoning is Needed**

Often, **the need for additional reasoning becomes clear only during inference**. Here's an illustrative example:

> **Context**
> John went to the hallway.
> John put down the football.

> **Question**
> Where is the football?

To answer this, the model must:

1. **Step 1**: Attend to the mention of “football” (probably in the second sentence).
2. **Step 2**: Trace who had it and where they were (i.e., attend to John's location in the first sentence).
3. **Step 3**: Infer: the football is now in the hallway.

### Formal Model (from lecture)

1. **First step (hop)**: attend to the most relevant memory cell given the input question $x$:
   $$
   o_1 = O_1(x, \mathbf{m}) = \arg\max_{i=1,\dots,N} s_O(x, m_i)
   $$

2. **Second step**: use both the original question and the previously selected sentence to find a second relevant sentence:
   $$
   o_2 = O_2(x, \mathbf{m}) = \arg\max_{i=1,\dots,N} s_O([x, m_{o_1}], m_i)
   $$

3. **Final step**: extract the answer $w$ by scoring all candidate outputs $W$ using a representation built from $x$, $m_{o_1}$, and $m_{o_2}$:
   $$
   r = \arg\max_{w \in W} s_R([x, m_{o_1}, m_{o_2}], w)
   $$

This formulation allows the model to simulate **chained reasoning**, where each step's attention is conditioned on prior selections.

### When to Stop Reasoning?

In multi-step QA, we must decide **when to stop retrieving or attending*.
There are three main strategies for stopping:

1. **Fixed Number of Steps**

   - The model always performs a pre-set number of reasoning hops (e.g., 2 or 3).
   - Simple, but inflexible — some questions are under-reasoned or over-reasoned.

2. **Special Stop Symbol**

   - Memory includes a synthetic token like `[STOP]`.
   - If the model attends to `[STOP]`, it signals that reasoning is complete.

3. **Learned Stopping Mechanism**

   - A small classifier or gating function is trained to predict whether more steps are needed:
     $$
     p_{\text{stop}} = \sigma(W h_t + b)
     $$

   - The model decides at each step whether to continue or terminate.

### Dataset

- **HotpotQA** (2018) is designed for multi-hop QA.
- It contains questions that explicitly require reasoning across multiple documents.
- Supervision includes both supporting facts and intermediate steps, making it a great benchmark for testing reasoning depth and stop-prediction mechanisms.
