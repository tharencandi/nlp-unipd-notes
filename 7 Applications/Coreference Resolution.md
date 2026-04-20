# Coreference Resolution

(Chapter 23 of book)

An important component of language processing is knowing who is being talked about in a text. Consider the following passage:

*"**Victoria Chen**, CFO of Megabucks Banking, saw **her** pay jump to $2.3 million, as **the 38-year-old** became the company’s president. It is widely known that **she** came to Megabucks from rival Lotsabucks."*

- Each bold phrase refers to Victoria Chen (two or more *corefer*)
- Victoria Chen, her are *mentions* or *referring expressions*
- Discourse entity referred to is the *referent*

Language is interpreted through a ***discourse model***. Built incrementally when interpreting a text that contains representations of entities referred to, associated properties, and relations among entities.

The first mention of an entity is an *evocation*; the entity is *evoked* into the model. Subsequent mentions the representation is *accessed* from the model, this subsequent mention is an *anaphora* as it *corefers* to a previous mention called the *antecedent*.

Coreference is an important component of NLP, and is useful for many downstream tasks:

- A dialogue system that has just told the user "There is a 2pm flight on United and a 4pm one on Cathay Pacific" must know which flight the user means by "I'll take the second one".
- A question answering system that uses Wikipedia to answer a question about Marie Curie must know who she was in the sentence "She was born in Warsaw".
- A machine translation system translating from a language like Spanish, in which pronouns can be dropped, must use coreference from the previous sentence to decide whether the Spanish sentence '"Me encanta el conocimiento", dice.' should be translated as '"I love knowledge", he says', or '"I love knowledge", she says'.

Summary:

- Antecedents of a mention: each mention before the current one
- Pronominal anaphora resolution: finding the antecedents of a pronoun
- Entity linking: resolving references with respect to a knowledge base entity (e.g. wikipedia)

## Types of Referring Expressions

### Indefinite Noun Phrases:

- Marked with the determiner "a" (or "an"), quantifiers such as "some", or even the determiner "this".
- Generally introduces entities that are new to the hearer into the discourse context.

	1. Mrs. Martin was so very kind as to send Mrs. Goddard **a beautiful goose**.
	2. He had gone round one day to bring her **some walnuts**.
	3. I saw **this beautiful cauliflower** today.

### Definite Noun Phrases:

- Refers to an entity that is identifiable to the hearer (e.g., via NPs that use the English article "the").
- An entity can be identifiable because it has been mentioned previously, thus already represented in the discourse model:
    - (23.7) It concerns a white stallion which I have sold to an officer. But **the pedigree of the white stallion** was not fully established.
- Alternatively, an entity can be identifiable because it's in the hearer’s beliefs about the world, or the uniqueness of the object is implied by the description itself, evoking a representation of the referent:
    - (23.8) I read about it in **the New York Times**.
    - (23.9) Have you seen **the car keys**?
- These last uses are common; over half of definite NPs in newswire texts are non-anaphoric, often as a first mention of an entity (Poesio and Vieira 1998, Bean and Riloff 1999).

### Pronouns:

- Another form of definite reference, used for entities that are extremely salient in the discourse:
    - (23.10) Emma smiled and chatted as cheerfully as **she** could.
- **Cataphora:** Pronouns can be mentioned before their referents:
    - (23.11) Even before **she** saw **it**, Dorothy had been thinking about the Emerald City every day.
- **Bound Pronouns:** Appear in quantified contexts where they are considered to be bound.

## Linguistic Properties of the Coreference Relation

### Number Agreement:

- Referring expressions and their referents must generally agree in number; English "she/her/he/him/his/it" are singular, "we/us/they/them" are plural, and "you" is unspecified for number.
- A plural antecedent like "the chefs" cannot generally corefer with a singular anaphor like "she".
- Algorithms cannot enforce number agreement too strictly due to exceptions:
    - Semantically plural entities can be referred to by either "it" or "they":
        - (23.31) IBM announced a new machine translation product yesterday. **They** have been working on it for 20 years.
    - **Singular "they"** has become much more common, used for singular individuals, often gender-neutral. This usage is quite old, part of English for many centuries.

### Person Agreement:

- English distinguishes between first, second, and third person, and a pronoun’s antecedent must agree with the pronoun in person.
- A third person pronoun (he, she, they, him, her, them, his, her, their) must have a third person antecedent (one of the above or any other noun phrase).
- Phenomena like quotation can cause exceptions; in this example "I", "my", and "she" are coreferent:
    - (23.32) “**I** voted for Nader because he was most aligned with **my** values,” **she** said.

### Gender or Noun Class Agreement:

- In many languages, all nouns have grammatical gender or noun class, and pronouns generally agree with the grammatical gender of their antecedent.
- In English, this occurs only with third-person singular pronouns, which distinguish between male (he, him, his), female (she, her), and nonpersonal (it) grammatical genders.
- Non-binary pronouns like "ze" or "hir" may also occur in more recent texts.
- Knowing which gender to associate with a name in text can be complex, and may require world knowledge:
    - (23.33) Maryam has a theorem. **She** is exciting. (she=Maryam, not the theorem)
    - (23.34) Maryam has a theorem. **It** is exciting. (it=the theorem, not Maryam)

### Binding Theory Constraints:

- The binding theory refers to syntactic constraints on the relations between a mention and an antecedent in the same sentence (Chomsky, 1981).
- Reflexive pronouns like "himself" and "herself" corefer with the subject of the most immediate clause that contains them:
    - (23.35) Janet bought **herself** a bottle of fish sauce. $[herself=Janet]$
- Nonreflexives cannot corefer with this subject:
    - (23.36) Janet bought **her** a bottle of fish sauce. $[her \neq Janet]$

### Recency:

- Entities introduced in recent utterances tend to be more salient than those introduced from utterances further back.
- (23.37) The doctor found an old map in the captain’s chest. Jim found an even older map hidden on the shelf. **It** described an island. (Here, "it" is more likely to refer to Jim’s map than the doctor’s map.)

### Grammatical Role:

- Entities mentioned in subject position are more salient than those in object position, which are in turn more salient than those mentioned in oblique positions.
- The preferred referent for the pronoun "he" varies with the subject:
    - (23.38) Billy Bones went to the bar with Jim Hawkins. **He** called for a glass of rum. $[ he = Billy ]$
    - (23.39) Jim Hawkins went to the bar with Billy Bones. **He** called for a glass of rum. $[ he = Jim ]$

### Verb Semantics:

- Some verbs semantically emphasize one of their arguments, biasing the interpretation of subsequent pronouns.
- (23.40) John telephoned Bill. **He** lost the laptop. (He typically resolves to John.)
- (23.41) John criticized Bill. **He** lost the laptop. (He typically resolves to Bill.)
- This may be partly due to the link between implicit causality and saliency: the implicit cause of a "criticizing" event is its object, whereas the implicit cause of a "telephoning" event is its subject. The entity which is the implicit cause may be more salient.

### Selectional Restrictions:

- Many other kinds of semantic knowledge can play a role in referent preference.
- The selectional restrictions that a verb places on its arguments can help eliminate referents:
    - (23.42) I ate the soup in my new bowl after cooking **it** for hours. (There are two possible referents for "it": "the soup" and "the bowl". The verb "eat", however, requires its direct object to denote something edible, ruling out "bowl" as a possible referent.)

## Complications

Coreference resolution faces several challenges due to the varied behaviour of pronouns in natural language:

**Non-Referential Pronouns:** Pronouns do not always refer to specific entities. Consider these examples:

- "They told me that I was too ugly for show business, but I didn't believe **[it]**." (Here "it" refers to the entire proposition, not an entity.)
- "Elisa saw Berthold get angry, and I saw **[it]** too." ("it" again refers to the event, not a concrete referent.)

**Generic Referents:** Some pronouns have generic, non-specific referents:

- "On the moon, **[you]** have to carry **[your]** own oxygen." (The pronoun "you" refers to people in general, not a specific individual.)
- "A poor carpenter blames **[her]** tools." (Generic reference to any carpenter.)

**Expletive Pronouns:** In some cases, pronouns do not refer to anything at all:

- "**It's** raining." (Expletive "it" with no referent.)
- "You can make **[it]** in showbiz." (Idiomatic usage where "it" has no clear antecedent.)

**Disambiguation Challenge:** Distinguishing between these different uses of pronouns is critical. For example:

- "You can make **[it]** in showbiz." (idiomatic, non-referential)
- "You can make **[it]** in advance." (referential, likely referring to a specific object)

One approach to this disambiguation is checking the distributional statistics of similar pronouns in the same context. For instance, examining whether substituting "them" for "it" yields sensible sentences can help:

- "You can make **[them]** in advance." (✓ sensible)
- "You can make **[them]** in showbiz." (✗ nonsensical)

## Coreference Learning Task

Input: Raw text
Goal: detect mentions and link them into clusters.

example:

"Victoria Chen, CFO of Megabucks Banking, saw her pay jump to $2.3 million, as the 38-year-old also became the company’s president. It is widely known that she came to Megabucks from rival Lotsabucks."

1. {Victoria Chen, her, the 38-year-old, She}
2. {Megabucks Banking, the company, Megabucks}
3. {Lotsabucks}

This involves dealing with:

- pronominal anaphora (her)
- filtering out non-referential pronouns (it is widely known)
- definite noun phrases (“the 38-year-old”)
- Megabucks ≡ Megabucks Banking

## Evaluation
B3: given mention $i$, let $R$ be the reference (gold) set that includes $i$, and $H$ the hypothesis (prediction) set that includes $i$.

$$Precision = \frac{H \cap R}{H}$$

$$Recall = \frac{H \cap R}{R}$$
$$F_1 = 2\frac{Prec Rec}{Prec + Rec}$$

Example:

- R={Victoria Chen, her, the 38-year-old, She}
- H={Victoria Chen, her, the 38-year-old, Megabucks, Lotsabucks}
- Prec = 3/5
- Rec = 3/4

## Datasets

- OntoNotes: Chinese and English coreference datasets
  - roughly one million words each, consisting of newswire, magazine articles, broadcast news, broadcast conversations, web data and conversational speech data.
  - 300,000 words of annotated Arabic newswire
  - it does not label singletons (making the task easier)
- The ARRAU corpus contains 350,000 words of English
  - includes singletons
  - diverse genres like dialog and fiction

## Algorithms

Coreference can be broken into a two step task:

1. identifying spans that mention entities
2. clustering those spans.

### Mention Identification

This phase involves pinpointing all the text segments that refer to an entity. A common approach, as seen in models like "End-to-end neural coreference resolution" by Lee et al., often combines this with the clustering step.

**Heuristics for Mention Identification:**

-   **Initial Consideration:**
  - all noun phrases (NPs) and named entities are considered as potential mentions. Sometimes, even all n-grams (sequences of n words) are included to ensure comprehensive capture.
-   **Filtering:**
  - Once potential mentions are identified, certain types are filtered out, such as:
	    -  Nested NPs with the same head (e.g., "Apple CEO [Tim Cook]," where "Tim Cook" is the head and "Apple CEO" is nested).
	    -   Numerical entities that don't refer to a distinct entity.
	    -   Non-referential pronouns (e.g., the "it" in "It is raining").
-   **Importance of Recall:** It's crucial to be generous during mention identification. Any entity not identified in this phase (a **false negative**) cannot be recovered later. Therefore, systems usually aim for high recall, extracting all NPs, possessive pronouns, and named entities.
-   **Integrated Approach:** It's also possible to consider all possible spans (n-grams) from the outset and perform mention identification and mention clustering simultaneously, often seen in end-to-end neural models.

### Mention clustering

Deals with non referential pronouns

Two types of approaches
• Mention based models:
• Each pair of mentions is scored independently
• A Clustering algorithms clusters mentions together
• Fastest approach but
• May lead to incoherent results:
{Hillary Clinton ← Clinton ← Mr Clinton}
• Entity based models:
• The whole group of mentions is scored together
• In general more accurate
• Slowest, since we need to consider all possible groupings

#### Mention Pair Models

Mention pair models operate by annotating pairs of mentions with a binary label:

- 1 if they corefer
- -1 otherwise.

**Positive Examples:** For each mention in position *j*, the most recently occurring coreferent mention *i* is found, and the pair (*i*, *j*) is assigned a label of 1.

**Negative Examples:** For each entity *k* such that *i* < *k* < *j*, the pair (*k*, *j*) is assigned a label of -1 (assuming *k* is not coreferent with *j*).

**Example:**

-   c1 = {Apple Inc$_{1:2}$, the firm$_{27:28}$}
-   c2 = {Apple Inc Chief Executive Tim Cook$_{1:6}$, he$_{17}$, Cook$_{33}$, his$_{36}$}
-   c3 = {China$_{10}$, the firm′s biggest growth market$_{27:32}$, the country$_{40:41}$}

-   **Positive Pairs:** (Apple Inc, the firm), (his, Cook), ...
-   **Negative Pairs:** (Cook, the firm), (his, Apple Inc), ...

Any supervised classification algorithm, such as logistic regression, can be applied once a suitable representation for the mentions and their features is defined.

**Types of Mentions and Their Characteristics:**

1. **Proper Nouns:** Often corefer with other proper nouns (e.g., "$[Tim Cook]$" and "$[Cook]$").

    -   **Head Match Idea:** Match the syntactic head words of the reference with the referent (e.g., the root of the dependency subtree covering the name).
    -   For sequences of proper nouns, the head word is typically the final token (e.g., "Cook" in "Tim Cook").
    -   **Limitations:** This approach does not always work (e.g., "Nobu San" where "San" is the head but "Nobu" is the informative part; "Virginia Tech" where "Virginia" is more informative than "Tech").
    -   Common features include exact match, head match, and string inclusion.

2. **Nominals:** Any noun phrase that is not a pronoun or a proper noun (e.g., "the firm’s biggest growth market" referring to "China").

    -   These are generally more difficult to resolve as they often require external world knowledge to establish coreference.

**Features for Machine Learning Systems:**

-   **Mention Features:** These describe individual mentions.
    -   **POS (Part-of-Speech):** Whether the mention is a pronoun, a nominal, or a proper noun.
    -   **Number of Tokens:** Longer mentions are less likely to refer to a single, previously mentioned antecedent.
    -   **Lexical Features:** Such as the first, last, and head word of the mention.
    -   **Morphosyntactic Features:** Gender, number, and dependency ancestors (relationships in the syntactic parse tree).

-   **Mention Pair Features:** These describe the relationship between two mentions.
    -   **Combinations of Mention Features:** Features derived from comparing the individual mention features (e.g., if their POS categories match).
    -   **Distance:** The number of tokens between the two mentions in the text.
    -   **String Matching:** A score indicating the type of string match (e.g., exact match, suffix match, substring match).
    -   **Binary Features:**
        -   **Nested Mentions:** Whether one mention is syntactically contained within the other.
        -   **Compatibility:** Whether gender and number attributes are compatible between the two mentions.
        -   **Same Speaker:** Whether both mentions are attributed to the same speaker in a dialogue.
    -   **Gazetteers:** Whether the pair of mentions are listed together in a pre-compiled list or knowledge base (e.g., "USA" and "United States of America").
    -   **Lexical Semantics:** Whether the head words of the mentions are synonyms according to a dictionary or a knowledge base, or other dictionary/knowledge-base based similarity measures.

### Coreference Clustering Strategies ---

Once a classifier is trained to determine if two mentions corefer, it can function as a "distance" metric for a clustering algorithm.

For each mention `i` in a document, the classifier evaluates its relationship with all receding mentions. Here are two common strategies for linking mentions:

- **Closest-First Clustering:**
	- Works backward from mention `i-1` down to mention `1`. The very first antecedent encountered with a coreference probability greater than 0.5 is immediately linked to mention `i`. This method is efficient as it stops searching once a suitable antecedent is found.
- **Best-First Clustering:**
	- More exhaustive. Evaluates *all* `i-1` preceding mentions as potential antecedents for mention `i`. The preceding mention with the highest coreference probability (the "best" match) is then chosen as the antecedent for `i`. This can be more accurate but is also computationally more intensive.

After a series of these pairwise linking decisions, the **transitive closure** of the pairwise relationships is taken to form the final coreference clusters. This means if mention A corefers with B, and B corefers with C, then A, B, and C are all considered part of the same cluster, even if A and C were not directly linked by the classifier.

### Entity-Based Models

In entity-based models, all possible mentions are scored together to form coherent entities, rather than relying solely on pairwise scores. The goal is to find the entity partition `z` that maximizes a global score:

$$max_z\sum_{e=1}\psi_E({i:z_i = e})$$

-   Where $\psi_E$ is a scoring function applied to all mentions *i* that are assigned to entity *e*. This function evaluates the coherence and quality of the entire cluster.

To reduce the high computational complexity of considering all possible groupings, **incremental search strategies** are commonly employed:

-   When a new mention is encountered in a text, it is considered for assignment to all clusters that have already been formed.
-   The mention is added to an existing cluster only if it is compatible with *all* the elements already present in that cluster, ensuring cluster coherence.

-   **Mitigating Early Mistakes:** Since early decisions can have a cascading effect, leading to mistakes that are difficult to correct later, **beam search** is often used.
    -   Instead of committing to a single best decision at each step, beam search maintains a set of the *k* best solutions (a "beam").
    -   For instance, if faced with the choice of adding a mention to an existing cluster or starting a new cluster for it, beam search explores both possibilities, keeping the most promising paths. This allows the model to recover from locally suboptimal decisions and find a better global solution.

### End-to-End Models

**Neural End-to-End Coreference Algorithms:** These modern approaches consider all possible text spans (up to a predefined maximum length) within a document as potential mentions.

-   For every pair of spans (*i*, *j*), a score *s*(*i*, *j*) is computed, which is higher if spans *i* and *j* corefer.
-   This score *s*(*i*, *j*) is typically a function of three components:
    -   *s*(*i*, *j*) = *f*(*m*(*i*), *m*(*j*), *c*(*i*, *j*))
    -   *m*(*x*) represents the probability or likelihood that span *x* is a mention.
    -   *c*(*i*, *j*) represents the probability or likelihood that span *j* is the antecedent of span *i*.

-   **Span Representation:** Each span is typically represented by a rich embedding that captures its semantic and syntactic information. This embedding is often a concatenation of:

    1.  The embedding of the first word in the span.
    2.  The embedding of the last word in the span.
    3.  A weighted sum (embedding) of the most important words within the span, as determined by an attention mechanism.

-   **Antecedent Compatibility (c(i,j) input):** The input to the *c*(*i*, *j*) component includes:
    -   The individual representations of span *i* and span *j*.
    -   A combined representation that captures the interaction or relationship between the two spans.

-   **Score Normalisation:** The coreference scores *s*(*i*, *j*) for each potential antecedent *j* of a given span *i* are typically normalised (e.g., using a softmax function) to obtain probabilities that sum to 1, representing the likelihood of *j* being the antecedent for *i* among all candidates.

$$ \frac{exp(s(i,j))}{\sum_jexp(s(i,j))} $$

#### Span Representation
To compute *m*() and *c*() (mention probability and antecedent compatibility), we need to effectively represent a span.

-   **Encoding:** A pre-trained encoder like BERT is used to generate contextual embeddings for all words in the document.
-   **Span Embedding Components:** A span's representation is constructed by concatenating three key embeddings:

    1.  `h_START(i)`: The embedding of the first word in span *i*.
    2.  `h_END(i)`: The embedding of the last word in span *i*.
    3.  `h_ATT(i)`: The embedding of the most "important" words in the span. This is computed as the sum of attention-weighted embeddings of all the words within the span, where an attention mechanism learns which words are most salient.

-   Thus, a span *i* combines the representation of these three token-level embeddings:
    `g_i = [h_START(i) ; h_END(i) ; h_ATT(i)]`

![[Pasted image 20250615202433.png]]

-   **Example:** Consider the computation of antecedents for the span "the company". The model would calculate scores `s("the company", j)` for all preceding spans *j*.
-   **No Antecedent ($\epsilon$):** The model also considers a special "null" antecedent, $\epsilon$, which represents the case where the current span does not corefer with any preceding mention (i.e., it's a new entity).

![[Pasted image 20250615202454.png]]

Given all the normalised scores, an antecedent is selected for each mention. Finally, a **transitive closure** of all these selected antecedent-mention pairs is performed to derive the final coreference clusters.
