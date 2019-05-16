---
title: Documenting Architecture Decisions
...

<section>

A certain wise man once sang "If you choose not to decide, you still have made a
choice." Behind that choice is a lot of context. When you decide (or choose not
to decide) you have all kinds of context in your head: the current state of the
system, the company, skills present in your team, roadblocks in the
organization, details of technologies in use and under consideration, and so on.
A decision which is right for your situation may look strange or even wrong to
people later or who lack your current understanding. On the other hand, you
might have only some of the facts and later information may cause you to
re-evaluate a choice.

</section>

## Explain Rationales

The reasoning behind a decision is important and I've found it useful to
document the decision itself, in a format called an "Architecture Decision
Record" or ADR. An ADR consists of 4 parts:

1. The current context.
2. The decision made in that context.
3. The consequences of that decision.
4. The status of the decision itself. (Proposed, accepted, superceded,
   rejected.)

Save the persuasive writing for English classes and project pitches. Each part
here states a series of facts. Bullets are fine, but try to use active voice
sentences so readers know who is doing what. (That's especially important in the
decision section.)

Once proposed, an ADR can be changed which a team discusses and makes the actual
decision. After that, however, it should stay the same. It may get out of date
with respect to the system, but we fully expect that. In fact, future decisions
might alter or reverse part of an old decision. It's totally normal to see an
ADR about adding a framework, followed some time later by another ADR about
removing the very same framework. By recording the decisions, future team
members can catch up on years of evolution in an hour or two. The old ADRs will
explain something that the "as-built" documentation can't: *why* the system
looks the way it does.

A system that has evolved over time won't look like it would with a clean-sheet
rewrite. That's OK! A "lived-in" look can be cozy and familiar. I describe it as
a system that shows its history. *Here* is the spot where we cut out that
framework, but you can still see a wrapping interface we used. Over *there* is
where the old GUI technology connected to the domain layer. That's why we have
all these domain objects with the visitor pattern. (And by the way, you should
read ADR 32, about removing the vestiges of the visitor.)

Some projects even record their decision to use architecture decision records.
It's like bootstrapping via ADR 1. ADR 1 explains what an ADR is, frequently
with a link to my [original blog
post](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions)
about the technique. This meta-ADR serves the same purpose as the regular ones.
When someone who wasn't part of the original decision wants to understand the
project, they can read ADR 1 to learn the technique and why the team chose to
adopt it.[^adr-tools]

[^adr-tools]: {-}
    I'm using [Nat Pryce's](https://github.com/npryce) [adr-tools](https://github.com/npryce/adr-tools) automation to keep my format consistent, which gives us ADR 1 as soon as we run `adr init`. It's visible in the source repository for the real system, but I'm also including it here in the book for clarity and ease of reading.

!! bin/show-rev-file-lines.sh doc/adr/0001-record-architecture-decisions.md HEAD 1 $ | bin/indent-markdown.sh | bin/quote.sh

### Infrastructure and Superstructure

Where will this system run? How shall we build it? Where do we want to land on
the spectrum from infrastructure to platform? It's time to make some decisions.
I may regret some of these later, but let's get started and see what needs to be
modified later.

!! bin/adr.sh 0002-use-aws.md 

So now that we have the "where" identified, we also need to talk about "what"
and "how"

!! bin/adr.sh 0003-rich-front-end-with-api.md

As you can see in the next ADR, it's totally fine to make decisions based on the skills and knowledge in the current team. In fact, that's one of the most important and under-documented parts of decision-making.

If your organization mandates particular languages or frameworks, note that in the context as well. The rules often change and you don't want some future team to blame you for sticking to JDK 1.8 ten five years after its end-of-life!

!! bin/adr.sh 0004-clojure-and-clojurescript.md

With these decisions in place, we can zoom in on the front end to see how we [want to build it](04-reframe-for-front-end.html).