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

> ## 1. Record architecture decisions
> 
> Date: 2019-02-22
> 
> ### Status
> 
> Accepted
> 
> ### Context
> 
> We need to record the architectural decisions made on this project.
> 
> ### Decision
> 
> We will use Architecture Decision Records, as [described by Michael Nygard](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).
> 
> ### Consequences
> 
> See Michael Nygard's article, linked above. For a lightweight ADR toolset, see Nat Pryce's [adr-tools](https://github.com/npryce/adr-tools).

### Infrastructure and Superstructure

Where will this system run? How shall we build it? Where do we want to land on
the spectrum from infrastructure to platform? It's time to make some decisions.
I may regret some of these later, but let's get started and see what needs to be
modified later.

> ## 2. Use AWS
> 
> Date: 2019-02-22
> 
> ### Status
> 
> Accepted
> 
> ### Context
> 
> The system should be available from multiple devices, with the same record of facts.
> 
> A desktop application would require some kind of synchronization via files, perhaps in Dropbox, OneDrive, GDrive, or the like. File locking and version conflicts are a concern.
> 
> A web application with a database handles the synchronization. However, a web application requires some place to run. In 2019, we can assume use of a cloud platform, but must decide which one to use.
> 
> The development team knows AWS the best. This could be a motive to pick Azure or GCP, if the dev team's learning is an objective.
> 
> This system will have a small number of users and operate at low scale. Requests will be very intermittent.
> 
> The operator would like to keep the monthly cost footprint down.
> 
> Cloud providers offer proprietary services with non-standard APIs. These can supply a lot of functionality, at the expense of lock-in on those services.
> 
> Embracing vendor services results in a large number of contingent decisions.
> 
> Wrapping vendor services is costly to implement and results in "lowest common denominator" functionality.
> 
> ### Decision
> 
> We will build the system on AWS.
> 
> Furthermore, we will embrace vendor services without attempting to wrap them or isolate ourselves from them.
> 
> ### Consequences
> 
> The dev team won't learn a new cloud platform.
> 
> The reader will learn how to build a complete system with AWS.
> 
> We will need to choose which AWS compute, storage, and networking services to use. Some of these choices will have serious cost implications.
> 
> We have the option to use AWS Cognito for user management and access control.
> 
> Build and deployment tools have excellent support for AWS, so we expect to have greater options with those.

So now that we have the "where" identified, we also need to talk about "what"
and "how"

> ## 3. Rich front end with API
> 
> Date: 2019-02-22
> 
> ### Status
> 
> Accepted
> 
> ### Context
> 
> We need to define the basic architecture of the system.
> 
> The GUI must be responsive. This implies at least some asynchronous behavior on the page, and probably means optimistic GUI updates.
> 
> Server-side page rendering for form submission is slow and *deeply* unfashionable now.
> 
> Excellent tools exist to define and implement HTTP based APIs.
> 
> ### Decision
> 
> We will build the system as a back end API server with a rich front end. It may or may not be a single-page app, but page loads should be minimized in the important flows (i.e., when capturing information.)
> 
> We will create source modules that match this structure:
> 
> 1. `api` for the back end service
> 2. `ui` for the front end code
> 
> ### Consequences
> 
> We have an enormous array of frameworks and libraries to choose from. No matter what we pick, at least one person will think it's the dumbest choice in the world.
> 
> We must also decide how information will be passed between the front and back ends.
> 
> We have an open question about how to serve static assets and where they should live in the source tree.
> 
> We have an open question about testing, specifically how much integration testing is required.

As you can see in the next ADR, it's totally fine to make decisions based on the skills and knowledge in the current team. In fact, that's one of the most important and under-documented parts of decision-making.

If your organization mandates particular languages or frameworks, note that in the context as well. The rules often change and you don't want some future team to blame you for sticking to JDK 1.8 ten five years after its end-of-life!

> ## 4. Clojure and ClojureScript
> 
> Date: 2019-02-22
> 
> ### Status
> 
> Accepted
> 
> ### Context
> 
> Viable choices for back end implementation language, based on the dev team's skills include:
> 
> - Ruby (with Rails, naturally)
> - Go
> - Python
> - Rust
> - Java
> - Scala
> - Clojure
> - Elixir
> 
>  Candidate choices for the front end include:
> 
> - ClojureScript
> - Typescript
> - Elm
> 
> The dev team has little experience with vanilla Javascript.
> 
> Virtually any combination of these languages can implement the constructs of ADR 3.
> 
> Any choice of languages will be unfamiliar to some readers, though some choices will be more foreign than others.
> 
> The dev team's most recent experience is with Clojure and ClojureScript.
> 
> ### Decision
> 
> We will use Clojure for the API, and ClojureScript for the UI.
> 
> ### Consequences
> 
> Code will require more explanatory text due to the unfamiliar syntax.
> 
> Where possible, we can use isomorphic code between back-end and front-end.

With these decisions in place, we can zoom in on the front end to see how we [want to build it](04-reframe-for-front-end.html).
