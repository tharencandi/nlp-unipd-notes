
Language consists of collocated, structured, coherent groups of sentence. 

Coherent structured groups of sentences are a discourse.

Coherence is the relationship between sentences that makes discources meaningful. Coherences relations structure coherence discourses.

Analysing coherence is useful for many downstream tasks:
- quality of a text e.g essay grading
- summarisation
- mental health issue detection (incoherence in speech)

There are two main types of coherence:
1. local coherence

	1. Two adjacent sentences connected by a coherence relation.
		- e.g reason relation 
		- Jane took a train from paris to Istanbul. She had to attend a conference.
	2. topical
		- nearby sentences that are about the same topic
		- use similar vocabulary to discuss the topic.
	3. Entity-based coherence 
		- tracks salient entities (ones that stand out when we recall a sentence) across a discourse.
		- salient entities are likley to be pronominalised, and appear in priminent syntactic positions (sibject or object)
		- transitions between sentences that maintain the same salient entities are considered more coherence in *centering theory*.
		- 
	 
2. global coherence
	- There are particular conventional discourse structures
	- academic articles share Intro, related work, experiments, conclusions
	- stories follow conventional plotlines or motifs or tropes.


	- Models a set of typical characters (e.g. Hero, Villain,...) and events (Villain commits kidnapping)
	- Argumentation Mining: 
		- Analysing people’s argumentation computationally
	- Various datasets annotate the components of a persuasive argument [3, page 547]: 
		- a main claim (1)
		- premises (corresponding to the satellite clauses, see 2 and 3 below) connected by argumentative relations (support -both 2 and 3 support 1-, attack)
	- Example:
		- (1) Museums and art galleries provide a better understanding about arts than Internet. 
		- (2) In most museums and art galleries, de- tailed descriptions in terms of the background, history and author are provided. 
		- (3) Seeing an artwork online is not the same as watching it with our own eyes.

	- Persuasiveness: 
		- A persuasive essay will have only a single main claim, with premises spread throughout the text, without the local coherence we see in coherence relations.
		- Three components for a good argument:
			- pathos (appealing to the emotions of the listener)
			- ethos (appealing to the speaker’s personal character)
			- logos (the logical logos structure of the argument).
		- Logos: 
			- algorithms for this task tend to mimic the ones regarding local coherence (with the support/attack relations)
		- pathos and ethos:
			- detected through a set of features that intercept:
				- reciprocity (people return favours), 
				- social proof (people follow others’ choices)
				- authority (people are influenced by those with power)
				- scarcity (people value things that are scarce).
	

## Coherence Relations 

We use Rhetorical Structure Theory (RST) to reason about coherence relations.

RST specifies the relation between a *sattelite* and a *nucleus*. where
- Satellites do not stand on their worn
- Nucleus is a main sentences 
- there can be two nuclei

Some relations:
- reason
	- "Jane took a train from paris to istanbuk. she had to attend a conference"
- elaboration
	- the satellite gives additional information or detail 
	- "Dorothy was from Kansas. She lived in the midst of the great Kansas prairies."
- evidence
	- Satellite has the goal of convincing the reader to accept the information in the nucleus. 
	- "Kevin must be here. His car is parked outside."
- attribution
	- Satellite gives the source of attribution for what is reported in the nuclus.
	- "Analysts estimated that sales at U.S stores declined."

We can build a graph of local coherence realtions.
- text spans in the leaves are *elementary disource units (EDU)*
- Satellite EDUs are connected to nucleus EDU

![[Pasted image 20250615205936.png]]


## Coherence Relation Corporas


###  RST Discourse TreeBank

uses RST.

Task:  segement the text into EDUs and identiy relations between them

RST Disource Treebank is the largest aailable discourse courpus 
- First Elementary Discourse units are identified, then the relations between them is annotated
- 385 English language documents selected from the Penn Treebank, with full RST parses for each one, using a large set of 78 distinct relations
- Extended to Spanish, German, Basque, Dutch and Brazilian Portuguese 

### Penn Discourse TreeBank PDTB

Penn Discourse TreeBank (PDTB)  annotations are based on discourse connectives, words that signal discourse relations
- first, discourse connectives (because, although, when, since, or as a result) are identified
- then the connected sentences are marked with the relation  (sometimes also adjacent sentences that are not linked by discourse connectives)
- 18,000 explicit and 16,000 implicit relations; only pairwise annotations, no global tree structure
- Example: Arg1 $[$Jewelry displays in department stores were often cluttered and uninspired. And the merchandise was, well, fake.$]$ As a result, Arg2 $[$marketers of faux gems steadily lost space in department stores to more fashionable rivals—cosmetics makers.$]$
- Example: $[$In July, the Environmental Protection Agency imposed a gradual ban on virtually all uses of asbestos.$]$ (implicit=as a result) $[$By 1997, all uses of cancer-causing asbestos will be outlawed.$]$


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