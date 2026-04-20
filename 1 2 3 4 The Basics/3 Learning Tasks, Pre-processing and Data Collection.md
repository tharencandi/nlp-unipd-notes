# Learning Tasks, Pre-processing and Data Collection

**Motivation:** Building data corpus for supervised learning tasks requires a deep understanding of the problem.

## Defining a Learning Task

*ML revision - no need to go into detail.*

A supervised learning task is defined as finding the function f:

$f = X \rightarrow Y$, where

- $X$ is the input (natural language domain)
- $Y$ is
	- $\{0,1\}$ binary
	- $\{0,..,N\}$ multi-class
	- Real number regression
	- $\{0,1\}^m$  (mult-ilabel)
- There is some *true* distribution of $P(x,y)$ - but it is impossible to know.

## Annotation

- automatic label procedures
	- reviews with ratings for sentiment
	- exploiting forum moderators for hate speech detection

- manual annotation; metadata; hybrid via *campaigns*
	- campaigns are expressive of P(x,y), replaceable, scalable

## Data Collection

- ensure no bias (or be aware of bias)
- data source via domain and time can induce bias  (e.g twitters user base)
- Distribution rights

**Bias in collection**

- self driving car are more likely to detect *white* pedestrians
- CV screening biased against women

 **in annotation**

 - Designers can have wrong assumptions.
	 - e.g stake in high risk care management task under assumption paitents who attend healthcare more are sicker (ignores socio-economic factors)
 **Implicit Bias**

 - e.g image classifier learn to recongise background instead of animal (because bird is always in sky)
	 - dataset is too narrow

## Annotation Procedure

- multiple experts or users
	- multiple experts are costly
	- crowdsourcing alternative
	- software solutions (inception, anafora,MTurk, custom,)
- analysed together to extract golden labels
- need **full theoretical knowledge** relevant for problem
- consider **scalability v expressiveness trade-off**

1. Formalise instructions for task

	-  to ensure replicability be clear;unambiguous

2. setup annotation schema and perform **pilot annotation**

	- test, review and modify instructions
	- create **golden labels** to quantitatively check the performance of annotators

3. start campaign
	1. multiple annotators per example
	2. gold label is majority assignment

## Inter-Annotator Agreement

Used to **measure the quality** of labels in annotation tasks — especially when multiple annotators are involved.

### 1. Raw Agreement

A simple measure of agreement between annotators.

- Assumes:
    - All annotations are equally difficult.
    - All labels are equally important.
- **Limitation**: Does **not** account for agreement that may happen **by chance**.

### 2. Cohen’s Kappa

**corrects raw agreement** by accounting for agreement by **chance**.

Let annotators be $A$ and $B$, and let $y_i$ be the possible labels:

- $P_o$: Observed agreement (i.e. how often $A$ and $B$ actually agree).
- $P_e$: Expected agreement by chance, based on the distribution of each annotator's labels.
- **Observed Agreement**:
  $$P_o = \sum_i P(A = B = y_i) = \frac{\sum_i \text{count}(A = B = y_i)}{\text{total annotations}}$$

- **Expected Agreement**:
  $$P_e = \sum_i P(A=y_i) \cdot P(B=y_i)$$

- **Cohen's Kappa**:
  $$\kappa = \frac{P_o - P_e}{1 - P_e}$$

**Interpretation:**

- $\kappa = 1$: Perfect agreement.
- $\kappa = 0$: Agreement is what would be expected by chance.
- $\kappa < 0$: Agreement is worse than chance (i.e. systematic disagreement).

### Variants

- $P_e = P(A=s)P(B=s) + P(A=t)P(B=t)$
- Variants of $P_e$ formula: $P_e$ independent of $A$, $B$; which are replaced by their average
- For >2 annotators: multi-kappa measure (based on agreement on pairs)
- Weighting each disagreement type differently: Krippendorf's alpha
