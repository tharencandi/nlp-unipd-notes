Different stages of the text processing pipeline. **not all stages are always used it depends on your task**.
# Tokenisation 
- set of symbols -> sequence of words/tokens
- language specific 
	- rule based for easily parsable languages (not always the case)
- NLTK tokeniser, Spacy 
- **subword tokenisation**
	-  reduced vocab size (e.g football -> foot, ball)
	- most common for LLMS
#### BPE Tokeniser
- inside words in conjunction with end-of-word marker ( __ )
```
k = hyperparamater
vocab = [char_1, char_2,..,char_k] of corpus
while len(vocab) != k:
	select A,B most frequently adjacent in Vocab
	add AB to vocab
	replace adjacent A,B in corpus with AB
```
- **WordPiece (BERT)** replace selection process with $f(A,B)/f(A)f(B)$
# Normalisation
What tokens should be merged, or kept apart (e.g great v Great)?
Text normalisation removed irrelevant distinctions for *downstream applications*.
These set of irrelevant distinctions are **application dependant** but can include:
- abbreviations, contractions (e.g isn't -> is not)
- standardisation of numbers and dates (e.g 1,000 -> 1000)
- expressive lengthening (e.g cooool -> cool)
- spelling variations (e.g normalisation -> normalisation)

(binary supervised) Learning task perspective 
- we want to reduce feature space to minimise the *curse of dimensionality* and increase *generalisation*
	- without eliminating linguistically meaningful distinctions
- all tokens are features; discriminative features depend on imbalance of feature between classes
- solution: normalise via stemming, and lemmatising (MUTUALLY EXCLUSIVE)
## Stemming
slicing words to remove affixes. used heavily in Information Retreival (IR)
**Linguistically problematic**: 
- can produce words that are not in the language and words with different meanings
	- arguing -> argu
	- caring -> car
- Porter and Snowball (rule-based) stemmer 
- statistical stemmers for low-resource languages
## Lemmatisation
Lemmatisation returns the canonical form of a word, the *lemma* after:
- identifying intended part of speech (POS)
- meaning of the word based on context
More resource-intensive

# Other Text Processing Tasks
## Language Identification

used for spell checking, tokenisation, and  acronym expansion. 
Statistical techniques 
	- functional word frequency
	- N-gram language models
	- distance measures via mutual information
	- see python langdetect, apache OpenNLP LanguageDetector
# Spell checking
correct grammatical mistakes via *approximate string matching algorithms*
	- levenshtien distance 
	- contextual information?
	- incomplete dictionary
python: TextBlob, fixxywuzzy
# Punctuation
punctuation needs to be isolated and treated as separate words
- sentence boundaries
- identifying some aspects of meaning (?, !, ")
- python: string.punctuation, nltk.punkt
- Special characters**: https://github.com/NeelShah18/emot


