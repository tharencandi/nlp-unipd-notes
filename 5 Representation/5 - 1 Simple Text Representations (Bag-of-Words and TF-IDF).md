Most machine learning algorithms require input data in **vector form**. Text, being unstructured, must first be transformed into a numerical format before being used in models.

The following representation methods are also known as *sparse representations* whilst [[5 - 3 Word Embeddings |word embeddings]] are also known as *dense representations*
## Bag of Words (BoW)

A simple and widely used method for converting text into numerical vectors.
- **Idea**: Represent each document by counting how many times each word appears.
- **Vocabulary**: A set (dictionary) of all unique words across the entire corpus.
- **Vector**: Each document is represented as a vector indexed by the vocabulary.
### Binary BoW

- Only records **presence or absence** of words in a document.
- Value is 1 if the word appears, 0 otherwise.

| Word     | Document A | Document B |
| -------- | ---------- | ---------- |
| machine  | 1          | 0          |
| learning | 1          | 1          |
| vector   | 0          | 1          |

## Weighted Variants of BoW

BoW can be enhanced by adjusting the way we **weight** the terms.
### Term Weight Variants:

|Variant|Description|
|---|---|
|**Binary**|1 if the term exists, 0 otherwise|
|**Raw Count**|Counts the number of occurrences of each word|
|**Term Frequency**|$tf(t, d) = \frac{\text{count}(t, d)}{\text{total terms in } d}$|
|**Log Norm**|$tf(t, d) = 1 + \log(\text{count}(t, d))$|
|**Double Norm**|$tf(t, d) = 0.5 + 0.5 \cdot \frac{\text{count}(t, d)}{\text{max count in } d}$|

## N-Grams

An **N-gram** is a contiguous sequence of $n$ items (typically words) from a given text.

- N-grams allow capture of **word order** and **local context**.
- For example, in the sentence:  
“**machine learning is fun**”:

|N|N-grams|
|---|---|
|1 (Unigrams)|machine, learning, is, fun|
|2 (Bigrams)|machine learning, learning is, is fun|
|3 (Trigrams)|machine learning is, learning is fun|


- **N-grams** are often used alongside or instead of BoW.
- As $n$ increases, **context** improves but **sparsity** and dimensionality increase.

## Summary: Choosing a Representation

| Method      | Captures Frequency | Captures Context | Sparse? | Notes                             |
| ----------- | ------------------ | ---------------- | ------- | --------------------------------- |
| BoW         | Yes                | No               | Yes     | Easy to implement                 |
| Binary BoW  | No                 | No               | Yes     | Good for short texts              |
| TF variants | Yes                | No               | Yes     | More nuanced than raw BoW         |
| N-Grams     | Yes                | Yes              | Yes     | Useful for syntax/sentiment tasks |

### TF-IDF

Motivation:
- **downweight frequent but uninformative words** (e.g., "the," "a," "is") that appear across many documents, while highlighting words that are more specific to a particular document. This reduces the impact of *stop words*, and is useful for Information Retrieval document relevance ranking (see [[Information Retrieval and Retrieval-Augmented Generation (RAG)#Search Engines]])

Calculation:
- The TF-IDF score for a term $t$ in a document $d$ is the product of its Term Frequency (TF) and its Inverse Document Frequency (IDF).
    * **Term Frequency ($tf_{t,d}$):** This measures how frequently a term $t$ appears in a document $d$. Most simply raw count
        $$tf_{t,d} = \text{number of times term } t \text{ appears in document } d$$
        Or
        * Binary: $1$ if term $t$ appears in document $d$, $0$ otherwise.
        * Logarithmic: $1 + \log(\text{raw count})$.
        * Augmented frequency: $0.5 + 0.5 \times \frac{\text{raw count}}{\text{maximum raw count in document}}$.
    * **Inverse Document Frequency ($idf_{t}$):** This measures how rare or common a term $t$ is across the entire corpus. It's designed to penalise terms that appear in many documents. The standard formula is:
        $$idf_{t} = \log\left(\frac{N}{\text{df}_t}\right)$$
        where:
        * $N$ is the total number of documents in the corpus.
        * $\text{df}_t$ (document frequency) is the number of documents in the corpus that contain the term $t$.
        A common variant adds 1 to the denominator to avoid division by zero for terms not in the corpus and to smooth the values:
        $$idf_{t} = \log\left(\frac{N}{1 + \text{df}_t}\right) + 1$$
    * **TF-IDF Score:** The final TF-IDF score is simply the product:
        $$\text{tf-idf}_{t,d} = tf_{t,d} \times idf_{t}$$
        A high TF-IDF score indicates that a term is frequent within a specific document but rare across the entire corpus, suggesting it's a good indicator of that document's content.