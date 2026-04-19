### Motivation

Semantic Role Labeling (SRL) provides a **shallow semantic representation** of a sentence. It helps extract structured meaning from surface-level word sequences, allowing us to answer questions like *"Who did what to whom?"* — which aren't always easily inferred from raw text or even from syntactic parse trees.

For instance, if we encounter the sentence:

> "Company A acquired Company B"

We’d like to know whether this answers the question:

> "Was Company B acquired?"

This kind of inference requires identifying **the roles of entities** in events, rather than just relying on surface forms. SRL makes it possible by mapping words to semantic roles associated with verbs (predicates).

The utility of SRL lies in its ability to **generalize across surface variations** of how roles are expressed.

### Example: Role Equivalence Across Sentence Variants

All the following sentences describe the same core event, with the same roles:

- X Corporation bought the stock  
- They sold the stock to X Corporation  
- The stock was bought by X Corporation  
- The purchase of the stock by X Corporation  
- The stock purchase by X Corporation  

Despite the syntactic and lexical variation, in all cases:
- "X Corporation" is the **buyer**
- "the stock" is the **item purchased**

SRL systems aim to identify and label these roles consistently across such variations.

### Core Idea

SRL identifies:
- **Predicates** (usually verbs or event-denoting nouns)
- **Arguments** of those predicates (the participants in the event)
- **Semantic roles** of the arguments (e.g., agent, patient, theme, goal)

These roles are often drawn from **predefined inventories** such as:
- **PropBank**: which labels arguments with numbered roles (Arg0, Arg1, etc.) and adjuncts (e.g., ArgM-TMP for temporal)
- **FrameNet**: which provides frame-specific roles tied to conceptual frames

The aim is to extract a structured frame for each event in the sentence.

### Problem Definition

A Semantic Role Labeling system performs two main tasks:
1. **Predicate identification**: locate all predicates (typically verbs or verbal nouns)
2. **Argument labeling**: assign spans of text to semantic roles associated with each predicate

Consider this example:

> "Boyang wants Asha to give him a linguistics book."

The SRL system should output:

- (PREDICATE: *wants*, WANTER: *Boyang*, DESIRE: *Asha to give him a linguistics book*)  
- (PREDICATE: *give*, GIVER: *Asha*, RECIPIENT: *him*, GIFT: *a linguistics book*)

In this example, we see nested predicates: *"wants"* embeds another predicate *"give"*, which has its own set of arguments.

Each predicate brings its own expected semantic roles, though some roles (like **TIME**, **MANNER**, or **LOCATION**) are more generic and shared across predicates.

### Generalization of Roles

Can we define **generic roles** that apply across different predicates? In many cases, yes — especially for core thematic roles such as:

- **AGENT**: the intentional actor (often Arg0 in PropBank)
- **THEME** or **PATIENT**: the entity being acted upon
- **RECIPIENT**, **INSTRUMENT**, **GOAL**, etc.

Example:

> "Asha taught Boyang a lesson."  
> "Asha gave Boyang a lesson."

Though the verbs differ (*taught* vs. *gave*), both assign the same roles:
- **Asha** is the **agent** (the giver or teacher)
- **Boyang** is the **recipient**
- **a lesson** is the **theme** or **object transferred**

### Note on Syntax vs Semantics

Semantic roles **do not necessarily align with grammatical roles**. For example, in passive constructions:

> "The stock was bought by X Corporation."

Grammatically:
- "The stock" is the subject  
- "X Corporation" is part of a prepositional phrase

Semantically:
- "X Corporation" is still the **agent** (buyer)
- "The stock" is the **theme** (thing bought)

SRL’s value lies in making these distinctions clear and machine-interpretable.



## Semantic Role Inventories:

Semantic roles capture the abstract relationships between predicates and their arguments in an event. Different annotation frameworks define role sets in slightly different ways. 
### VerbNet Roles

VerbNet defines a set of **generalized roles** that apply across verbs, grounded in formal semantics. A few core roles:

- **AGENT**  
  The actor who initiates and intentionally carries out the event.  
  Exists independently of the event.  
  *e.g., "John" in "John opened the door."*

- **PATIENT**  
  The entity that undergoes a change of state, location, or condition.  
  Directly affected by the event and exists independently of it.  
  *e.g., "the door" in "John opened the door."*

- **RECIPIENT**  
  The animate destination of a transfer.  
  *e.g., "Mary" in "John gave the book to Mary."*

- **THEME**  
  An undergoer that is central to the event but doesn't control how the event unfolds.  
  Typically remains unchanged.  
  *e.g., "the book" in "John read the book."*

- **TOPIC**  
  The information content transferred in communicative events.  
  *e.g., "the news" in "John told her the news."*

VerbNet roles aim to generalize across many surface forms and lexical frames, enabling higher-level semantic inference.
### PropBank Roles

PropBank provides **verb-specific frame files**, each defining a set of **numbered arguments** (ARG0, ARG1, ...) and **adjunct modifiers** (ArgM-*). Unlike VerbNet, PropBank is designed for **shallow semantic parsing**.

#### Two core prototypes:

- **Proto-Agent**  
  - Typically volitional, sentient, causal
  - Often moves or initiates the event
  - Exists independently of the event  
  *e.g., "John" in "John broke the glass."*

- **Proto-Patient**  
  - Undergoes change of state
  - Affected by another participant
  - Often passive or stationary  
  *e.g., "the glass" in "John broke the glass."*

These map roughly onto:
- **ARG0**: usually the proto-agent  
- **ARG1**: usually the proto-patient  
- **ARG2+**: verb-specific roles (e.g., recipient, attribute, instrument)

###  Examples

**Verb: agree.01**
- ARG0: Agreer  
- ARG1: Proposition  
- ARG2: Other entity agreeing  

Example 1:  
`[Arg0 The group] agreed [Arg1 it wouldn’t make an offer].`  
Example 2:  
`[ArgM-TMP Usually] [Arg0 John] agrees [Arg2 with Mary] [Arg1 on everything].`

**Verb: fall.01**
- ARG1: Logical subject (thing falling)  
- ARG2: Amount fallen  
- ARG3: Start point  
- ARG4: End point  

Example 1:  
`[Arg1 Sales] fell [Arg4 to $25 million] [Arg3 from $27 million].`  
Example 2:  
`[Arg1 The average junk bond] fell [Arg2 by 4.2%].`

**Verb: increase**
Example 1:  
`[Arg0 Big Fruit Co.] increased [Arg1 the price of bananas].`  
Example 2:  
`[Arg1 The price of bananas] was increased again [Arg0 by Big Fruit Co.].`  
Example 3:  
`[Arg1 The price of bananas] increased [Arg2 5%].`

Across all variations, the agent and theme roles remain consistent.

---

### ArgM Modifiers (Adjuncts)

PropBank supports **modifiers** marked as ArgM-* labels. These represent information that modifies the core event but is not a required argument of the verb.

- **ArgM-TMP** (Temporal): *when?*  
  *e.g., "yesterday evening", "now"*

- **ArgM-LOC** (Location): *where?*  
  *e.g., "at the museum", "in San Francisco"*

- **ArgM-DIR** (Directional): *where to/from?*  
  *e.g., "down", "to Bangkok"*

- **ArgM-MNR** (Manner): *how?*  
  *e.g., "clearly", "with much enthusiasm"*

- **ArgM-PRP / ArgM-CAU** (Purpose/Cause): *why?*  
  *e.g., "because ...", "in response to the ruling"*

- **ArgM-REC** (Reciprocal): *reflexive actions*  
  *e.g., "themselves", "each other"*

- **ArgM-ADV** (Adverbial): other miscellaneous modifiers

---

### Summary

- **VerbNet** provides general semantic role categories across predicates (e.g., AGENT, THEME, RECIPIENT), suitable for abstract meaning representation.
- **PropBank** is verb-specific and syntactically shallow, with roles like ARG0–ARG4 and adjunct modifiers (ArgM-*).
- PropBank is widely used in SRL tasks due to its annotated corpora (e.g., OntoNotes).
- These role sets allow systems to move beyond syntactic structure toward meaning-based representations of events.


## FrameNet

FrameNet is a lexical-semantic resource that organizes meaning in terms of **semantic frames**—structured descriptions of events or situations along with their participants. Unlike PropBank, which defines roles on a per-verb basis, FrameNet aims to **generalize across verbs** by grouping them under shared frames.

### Motivation

PropBank arguments (e.g., ARG0, ARG1) are **verb-specific**. This makes them practical for training shallow parsers but less expressive when capturing **conceptual commonalities** across different verbs. FrameNet was designed to address this by associating multiple lexical units (verbs, nouns, adjectives) with a shared **semantic frame**.

### What is a Frame?

A **frame** is a conceptual schema that represents a particular type of event, object, or state, along with the roles (called **frame elements**) associated with it.

Example:  
- *Asha taught Boyang algebra*  
- *Boyang learned algebra from Asha*  

Both sentences evoke the **Education_Teaching** frame, even though different verbs are used (*taught* vs. *learned*) and grammatical structures vary.

### Frame Elements

Frame elements are the roles that define how entities participate in the event described by the frame. In the **Education_Teaching** frame, the elements include:
- **Instructor**
- **Student**
- **Subject**

These correspond to “Asha,” “Boyang,” and “algebra” in the examples above.

### FrameNet Structure

FrameNet contains:
- Over **1,000 frames**
- Each associated with a set of **lexical units** (words that can evoke the frame)
- A hierarchy of **frame-to-frame relationships**, such as:
  - **Inheritance** (e.g., COMMERCE_SELL inherits from GIVING)
  - **Perspective** (SELL vs. BUY frame is a matter of viewpoint)
  - **Causative relationships** (e.g., CAUSE_MOTION vs. MOTION)

Example:

The frames **COMMERCE_SELL** and **LENDING** both inherit from the more abstract **GIVING** frame, because they all involve a **giver**, a **recipient**, and a **thing transferred**, though the nuances of transfer differ.

- FrameNet defines **semantic frames** to capture shared conceptual structures across verbs and other lexical triggers.
- Frames are more **linguistically motivated** and **semantically coherent** than numbered roles.
- It provides a robust foundation for **deep semantic analysis**, semantic parsing, and tasks like **natural language inference** or **question answering**, where conceptual generalization is critical.


## Feature-Based Approaches

Feature-based Semantic Role Labeling is treated as a **multiclass classification problem**, where each span (or node) in a sentence must be labeled with a semantic role (e.g., ARG0, ARG1) or with a special **no-role class** if it does not correspond to any argument.

The standard pipeline is as follows:

- Compute the **parse tree** (constituency or dependency)
- For each **predicate** in the sentence:
  - For each **node** (e.g., NP, PP) in the tree:
    - Extract relevant **features** using the predicate and the tree
    - Apply a classifier to determine the appropriate role label (or no-role)

This process is repeated independently for each (predicate, node) pair.

## SRL as Classification

Each (predicate, argument) pair is represented by a **feature vector**. Common features include:

- **Predicate lemma** and its **part-of-speech (POS)** tag  
- Whether the predicate is in **active or passive voice**  
- **Phrase type** of the candidate span (e.g., NP, VP, PP)  
- **Head word** of the phrase and its POS  
- **Position relative to the predicate** (before or after)  
- **Syntactic production rule** from the first branching node above the predicate  
  *e.g., VP → VBD NP PP*

These features capture the local and global syntactic context necessary for classification.

Additional features include **path-based indicators** that describe the structural relationship between the candidate argument and the predicate.

- **Syntactic path** from the argument to the predicate in the parse tree  
  Example:  
  The path from *Asha* to the verb *taught* is:  
  `NNP ↑ NP ↑ S ↓ VP ↓ VBD`  
  This is consistent with *Asha* functioning as the subject (likely ARG0).

- **Dependency path** features may also be used as an alternative to or in addition to constituency paths.

## Global Consistency

PropBank imposes **structural constraints** on role assignments. For example:

- Each predicate should have only **one ARG0**, **one ARG1**, etc.
- Adjunct roles (e.g., ARG-TMP, ARG-LOC) can appear multiple times.

If the classifier produces **probabilities** over role labels for each candidate, these predictions can be reconciled using a **Viterbi-style decoding algorithm**, or more generally, by solving a **constrained optimization problem**.

This global inference ensures that role assignments are both **coherent** and **consistent** with PropBank's annotation scheme.




## Neural Approaches

Modern Semantic Role Labeling systems are predominantly based on **neural architectures**, which remove the need for hand-engineered features and allow the model to learn contextualized representations directly from raw input.

### Tagging Formulation: BIO Encoding

Neural SRL is often framed as a **sequence labeling task**, similar to Named Entity Recognition (NER). Each token in the input sentence is assigned a tag using **BIO encoding**:

- **B-ARGX**: beginning of a span for argument type X  
- **I-ARGX**: inside a span for argument type X  
- **O**: outside any argument span

Example:
Asha taught Boyang algebra  
B-ARG0 B-V B-ARG1 B-ARG2

This allows the model to recover both the **type** and **extent** of each argument.

### Input Representation

The typical input to the model consists of:

- The **full sentence**, e.g., “Asha taught Boyang algebra”
- A special delimiter `[SEP]`
- The **predicate** of interest, e.g., “taught”

This ensures the model is aware of which verb it should analyze the arguments for, especially when multiple predicates are present in a sentence.

### Neural Architecture

A standard architecture includes the following components:

1. **Sentence Encoder**  
   A contextual encoder processes the input sentence to produce token-level embeddings. This can be:
   - A BiLSTM (traditional approach)
   - A Transformer model (e.g., BERT)

2. **Predicate-Aware Representation**  
   For each token in the sentence, its contextual embedding is **concatenated with the representation of the predicate**. This allows the model to learn how the predicate influences the role of each word.

3. **Feedforward Network (FFN)**  
   The concatenated representation is passed through a feedforward layer:
   $$
   h_i = \text{FFN}([x_i; p])
   $$
   where $x_i$ is the contextualized embedding of token $i$ and $p$ is the embedding of the predicate.

4. **Softmax Classification**  
   The FFN output is passed through a softmax layer to produce a distribution over possible BIO tags:
   $$
   y_i = \text{softmax}(W h_i + b)
   $$

This architecture is applied to each token in the sentence, producing a BIO-tag sequence over the full input.

### Evaluation

The output BIO-tag sequence is evaluated in terms of **span-based F1 score**, similar to NER evaluation. A prediction is considered correct if:
- The predicted span matches the gold span exactly
- The predicted role label (e.g., ARG1) matches the gold label

This ensures that both **boundary detection** and **label classification** are jointly assessed.

### Benchmark Datasets

Neural SRL systems are typically trained and evaluated on the following benchmarks:

- **CoNLL-2005** Shared Task  
  - Based on PropBank-style annotations over the Wall Street Journal (WSJ) corpus  
  - Includes both in-domain (WSJ) and out-of-domain (Brown) sections

- **CoNLL-2012** Shared Task  
  - Based on OntoNotes 5.0  
  - Multi-genre corpus including newswire, broadcast, conversational speech  
  - Includes both coreference and SRL annotations

These benchmarks provide standardized training and evaluation splits for consistent comparison of SRL systems.
