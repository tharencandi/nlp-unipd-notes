# Discourse Coherence

Language is not simply a collection of isolated sentences. Rather, it consists of structured, coherent groups of sentences that form meaningful units called **discourses**. **Coherence** is the relationship between sentences that makes these discourses comprehensible and unified. Coherence relations are the structural elements that hold discourses together.

Analysing coherence is useful for many downstream NLP tasks:

- Assessing text quality (e.g., essay grading)
- Summarisation
- Mental health issue detection (where speech incoherence can be a diagnostic signal)

## Types of Coherence

There are two main types of coherence:

### 1. Local Coherence

Local coherence operates at the level of adjacent or nearby sentences:

  **a. Coherence Relations**

  Two adjacent sentences are connected by a coherence relation. For example, a reason relation might connect: "Jane took a train from Paris to Istanbul. She had to attend a conference."

  **b. Topical Coherence**

  Nearby sentences are about the same topic and use similar vocabulary to discuss it.

  **c. Entity-Based Coherence**

  This approach tracks salient entities (ones that stand out when we recall a sentence) across a discourse. Salient entities are likely to be pronominalised and appear in prominent syntactic positions (subject or object). Transitions between sentences that maintain the same salient entities are considered more coherent in *centering theory*.

### 2. Global Coherence

Global coherence concerns the overall structure and organisation of longer texts. Different genres follow particular conventional discourse structures:

- **Academic articles** typically follow a predictable pattern: Introduction, Related Work, Experiments, Conclusions
- **Stories** often follow conventional plotlines, motifs, or tropes
- **Narrative frameworks** model typical characters (e.g., Hero, Villain) and events (e.g., Villain commits kidnapping)

#### Argumentation Mining

Argumentation mining involves analysing people's argumentation computationally. Various datasets annotate the components of a persuasive argument, typically including:

- A **main claim**: the central thesis being argued
- **Premises**: supporting statements (corresponding to satellite clauses) connected by argumentative relations:
  - **Support**: premises that strengthen the main claim (both premises 2 and 3 below support claim 1)
  - **Attack**: premises that counter opposing views

**Example:**

1. Museums and art galleries provide a better understanding about arts than the Internet.
2. In most museums and art galleries, detailed descriptions in terms of the background, history and author are provided.
3. Seeing an artwork online is not the same as watching it with our own eyes.

#### Persuasiveness

A persuasive essay typically has a single main claim with premises spread throughout the text, which may lack the tight local coherence we see in other coherence relations. Classical rhetoric identifies three components for a good argument:

- **Pathos**: appealing to the emotions of the listener
- **Ethos**: appealing to the speaker's personal character and credibility
- **Logos**: the logical structure of the argument

Computational approaches to these components vary:

- **Logos**: Algorithms for this task tend to mimic those used for local coherence analysis, focusing on support/attack relations between premises and claims.
- **Pathos and Ethos**: These are typically detected through features that capture persuasive principles:
  - **Reciprocity** (people return favours)
  - **Social proof** (people follow others' choices)
  - **Authority** (people are influenced by those with power)
  - **Scarcity** (people value things that are scarce)

## Coherence Relations

We use Rhetorical Structure Theory (RST) to reason about coherence relations.

RST specifies the relation between a *satellite* and a *nucleus*, where:

- Satellites do not stand on their own
- Nucleus is a main sentence
- there can be two nuclei

Some relations:

- reason
  - "Jane took a train from Paris to Istanbul. She had to attend a conference."
- elaboration
  - the satellite gives additional information or detail
  - "Dorothy was from Kansas. She lived in the midst of the great Kansas prairies."
- evidence
  - Satellite has the goal of convincing the reader to accept the information in the nucleus.
  - "Kevin must be here. His car is parked outside."
- attribution
  - Satellite gives the source of attribution for what is reported in the nucleus.
  - "Analysts estimated that sales at U.S stores declined."

We can build a graph of local coherence relations.

- text spans in the leaves are *elementary discourse units (EDU)*
- Satellite EDUs are connected to nucleus EDU

![[Pasted image 20250615205936.png]]

## Coherence Relation Corpora

###  RST Discourse TreeBank

uses RST.

Task:  segment the text into EDUs and identify relations between them

RST Discourse Treebank is the largest available discourse corpus

- First Elementary Discourse units are identified, then the relations between them is annotated
- 385 English language documents selected from the Penn Treebank, with full RST parses for each one, using a large set of 78 distinct relations
- Extended to Spanish, German, Basque, Dutch and Brazilian Portuguese

### Penn Discourse Treebank (PDTB)

Penn Discourse Treebank (PDTB)  annotations are based on discourse connectives, words that signal discourse relations

- first, discourse connectives (because, although, when, since, or as a result) are identified
- then the connected sentences are marked with the relation  (sometimes also adjacent sentences that are not linked by discourse connectives)
- 18,000 explicit and 16,000 implicit relations; only pairwise annotations, no global tree structure
- Example: Arg1 [Jewelry displays in department stores were often cluttered and uninspired. And the merchandise was, well, fake.] As a result, Arg2 [marketers of faux gems steadily lost space in department stores to more fashionable rivals—cosmetics makers.]
- Example: [In July, the Environmental Protection Agency imposed a gradual ban on virtually all uses of asbestos.] (implicit=as a result) [By 1997, all uses of cancer-causing asbestos will be outlawed.]

## RST Discourse Parsing

1. EDU (elementary discourse unit) segmentation

  - determine the boundaries of each EDU
  - traditionally you rune  a syntactic parser, and post-process the output
  - modern: train a token-level binary classifier with EDU gold labels that specify if a token ends an EDU.

2. Build the discourse tree
  1. used Arc-Standard algorithm for parsing.
  2. build representation for each span

    - train a parser to choose correct shift and reduce from training set.
    - shift() - pushes first EDU into the queue onto stack to create a single node subtree
    - reduce() - merge top two subtrees on the stack with a relation and establish a direction of the edge.

![[Pasted image 20250615210918.png]]

More advanced:
Use two biLSTM encoders to represent the EDU

- the first to represent each word inside the EDU
- the second builds an EDU embedding
- use a FFN with EDU and EDU word representations of the top-3 subtrees on the stack and the first EDU in the queue and classify shift or reduce

## PDTB discourse parsing

1. Find the discourse connectives (disambiguating them from non-discourse uses)
2. Find the two spans for each connective
3. Label the relationship between these spans
4. Assign a relation between every adjacent pair of sentences

  - Treated as a multiclass classification task
  - represent each of the two spans by BERT embeddings of the $[CLS]$ token
  - pass this through a single layer feedforward network and then a softmax classification
