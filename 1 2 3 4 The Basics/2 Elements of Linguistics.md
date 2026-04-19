Core linguistic terminology and concepts that will be used in the course.
# Levels of Linguistics

Overview from Lecture 2. These definitions will continue to come up in later sections..

Form → Meaning Pipeline
## Phonology
- **Definition**: Study of the sound systems of language.
- **NLP Applications**:
  - Automatic Speech Recognition (ASR)
  - Text-to-Speech (TTS)
  - Phonetic analysis for dialect identification, speaker recognition, etc.
- **Note**: Crucial for tasks that involve converting between textual and spoken forms.

## Morphology
- **Definition**: Study of the internal structure of words.
- **Core Concepts**:
  - **Morpheme**: The smallest unit of meaning.
  - **Derivational Morphology**: Creates new words (e.g., parse → parser)
  - **Inflectional Morphology**: Adds grammatical context (e.g., walk → walked)
- **Language Typology**:
  - Isolating languages (e.g., English)
  - Synthetic languages (e.g., Serbian)
- **NLP Techniques**:
  - [[4 Text-Processing#Tokenisation|Tokenisation]]
  - [[4 Text-Processing#Lemmatisation|Lemmatisation]]
  - [[4 Text-Processing#Stemming|Stemming]]
  - Finite-State Automata used for rule-based morphological analysis

## Syntax
- **Definition**: Study of how words combine to form sentences.
- **Tools & Techniques**:
  - **POS Tagging**: Assigning part-of-speech tags (e.g., Penn Treebank tagset)
  - **Constituency and Dependency Parsing**: Understanding sentence structure and grammatical relations
  - **Phrase Structures**: Identify syntactic heads and phrase categories
- **NLP Use Cases**:
  - Grammatical analysis
  - Machine translation
  - Parsing input from noisy or ill-formed text

## Semantics
- **Definition**: Study of meaning in language.
- **Key Concepts**:
  - **Lexeme**: Group of word forms sharing core meaning
  - **Lemma**: Canonical form of a lexeme
  - **Ambiguity**: A lemma with multiple meanings
  - **Lexical Relations**:
	  - Homonymy
		  - same spelling (different word) different meaning (bat v bat)
	  - Polysemy
		  - same word multiple meanings (foot of a person foot of a mountain)
	  - Synonymy
		  - different words same meaning
	  - Antonymy
		  - opposite meanings
	  - Hyponymy
		  - A more specific than B
	  - Hypernymy
		  - A more general than B
- **NLP Applications**:
  - Word sense disambiguation
  - Semantic role labeling (SRL)
  - Machine translation

### More on Semantics...
- We have seen synonymity
- Words are related in different ways
- Propositional meaning equivalence: if replacing one word with another, the truth condition of any sentence does not change
- Hypernymy (supertype, i.e. color -> green), antonymy (opposite meaning)
- Co-participation in an event: coffee and cup
- semantic field: house (door, roof, kitchen, family, bed)
- semantic frame: a set of words that denote perspectives in an event (buyer, seller)
- connotation: a set of words referring to the same emotion (positive, i.e. happy) 
	- valence - the pleasantness of the stimulus (satisfied, annoyed) 
	- arousal - the intensity of emotion (excited, calm) 
	- dominance - how submissive (anger, boredom)

## Pragmatics
- **Definition**: Study of meaning in context.
- **Key Elements**:
  - **Speech Acts**: Communicative functions like requesting, informing
  - **Discourse**: Explanations, elaborations, contrasts
  - **Coreference Resolution**: Determining entities referred to by pronouns
  - **Sentiment & Intent Analysis**: Extracting opinions, user goals

## Utility of Linguistics in NLP

### Traditional vs Neural NLP
- **Traditional NLP**:
  - Heavily reliant on linguistic models and rule-based systems
- **Neural NLP**:
  - Often end-to-end, but linguistic knowledge is valuable for:
    - Interoperability analysis
    - Working with low-resource languages
    - Interpreting errors and debugging model behavior

---

## Tags
- #NLP #Linguistics #Morphology #Phonology #Syntax #Semantics #Pragmatics #Parsing

---

### References
- Course Slides by Giovanni Da San Martino: NLP-elements-of-linguistics.pdf
