#Import Libraries
from __future__ import division
import nltk
from nltk.book import *
from nltk import bigrams

#Word Sense Disambiguation
'''
In word sense disambiguation we want to work out which sense of a word was intended in a given context.
Consider the ambiguous words serve and dish

In a sentence containing the phrase: he served the dish, you can detect that both serve
and dish are being used with their food meanings

As another example of this contextual effect, consider the word by, which has several
meanings, for example, the book by Chesterton (agentive—Chesterton was the author
of the book); the cup by the stove (locative—the stove is where the cup is); and submit
by Friday (temporal—Friday is the time of the submitting). Observe in (3) that the
meaning of the italicized word helps us interpret the meaning of by.

a. The lost children were found by the searchers (agentive)
b. The lost children were found by the mountain (locative)
c. The lost children were found by the afternoon (temporal)

'''

#Pronoun Resolution
'''
A deeper kind of language understanding is to work out “who did what to whom,” i.e.,
to detect the subjects and objects of verbs.

In the sentence the thieves stole the paintings, it is
easy to tell who performed the stealing action. Consider three possible following sentences in (4),

a. The thieves stole the paintings. They were subsequently sold.
b. The thieves stole the paintings. They were subsequently caught.
c. The thieves stole the paintings. They were subsequently found.

Answering this question involves finding the antecedent of the pronoun they, either
thieves or paintings. Computational techniques for tackling this problem include:

Anaphora resolution—identifying what a pronoun or noun phrase refers to and
Semantic role labeling—identifying how a noun phrase relates to the verb (as agent, patient, instrument, and so on).

'''

#Generating Language Output
'''
If we can automatically solve such problems of language understanding, we will be able to move on to tasks that involve
generating language output, such as question answering and machine translation. In the first case, a machine should be able to
answer a user’s questions relating to collection of texts:

a. Text: ... The thieves stole the paintings. They were subsequently sold. ...
b. Human: Who or what was sold?
c. Machine: The paintings.

'''

#Machine Translation
'''
We can explore them with the help of NLTK’s “babelizer” (which is
automatically loaded when you import this chapter’s materials using from nltk.book import *).
'''

#Spoken Dialogue Systems
'''
In the history of artificial intelligence, the chief measure of intelligence has been a linguistic
one, namely the Turing Test: can a dialogue system, responding to a user’s text input, perform so naturally
that we cannot distinguish it from a human-generated response? In contrast, today’s commercial dialogue systems
are very limited, but still perform useful functions in narrowly defined domains, as we see here:

S: How may I help you?
U: When is Saving Private Ryan playing?
S: For what theater?
U: The Paramount theater.
S: Saving Private Ryan is not playing at the Paramount theater, but
it’s playing at the Madison theater at 3:00, 5:30, 8:00, and 10:30.

You could not ask this system to provide driving instructions or details of nearby restaurants
unless the required information had already been stored and suitable questionanswer
pairs had been incorporated into the language processing system.

Do you know when Saving Private Ryan is playing?, a system might unhelpfully respond with a cold Yes. However, the developers
of commercial dialogue systems use contextual assumptions and business logic to ensure that the different ways in which a
user might express requests or provide information are handled in a way that makes sense for the particular application. So,
if you type When is ..., or I want to know when ..., or Can you tell me when ..., simple rules will always yield screening times.

'''

# #Nltk Chatbots -- Very simple
# nltk.chat.chatbots()

#Textual Entailment
'''
The challenge of language understanding has been brought into focus in recent years
by a public “shared task” called Recognizing Textual Entailment (RTE). The basic
scenario is simple. Suppose you want to find evidence to support the hypothesis: Sandra
Goudie was defeated by Max Purnell, and that you have another short text that seems
to be relevant, for example, Sandra Goudie was first elected to Parliament in the 2002
elections, narrowly winning the seat of Coromandel by defeating Labour candidate Max
Purnell and pushing incumbent Green MP Jeanette Fitzsimons into third place. Does the
text provide enough evidence for you to accept the hypothesis? In this particular case,
the answer will be “No.” You can draw this conclusion easily, but it is very hard to
come up with automated methods for making the right decision.
'''

#Excersize
# print("Monty Python"[6:12])
# print(["Monty", "Python"][1])

# # print(sent1[2][2])
#
# r = range(10,20)
# print(r)
# print(range(10, 20, 2))
# print(range(20, 10, -2))
#
# print(sorted(set([w.lower() for w in text1])))
# print(sorted([w.lower() for w in set(text1)]))