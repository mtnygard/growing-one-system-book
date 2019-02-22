# The Walking Skeleton

A "walking skeleton" does nothing, but it does nothing in a useful way. The skeleton puts all the pieces in place, with calls that go from end to end, even though it delivers no real functionality. The bones of the skeleton give us a place to begin building functionality, while staying continuously integrated and deployable.

In previous eras, a walking skeleton was permitted to perambulate your dev box. These days, I prefer to also include a build pipeline and deployment. The metaphor gets a bit strained, since we have a walking skeleton of our delivery pipeline that deploys a walking skeleton of the production environment. Maybe I should say the "anemic necromancer" raises the walking skeleton into production. On the other hand, development is production, so I'll just call the whole thing the walking skeleton.

{aside}

## Development is Production

For a long time, developers were like the cobbler's children. When we built tools that other people used to do their jobs, we would treat those tools as serious business. We'd put them into production environments and protect them. An outage for an internal tool, say a content management system for merchants, got treated as a serious problem that needed to be fixed. If the tool was down for any length of time, people could not do their jobs.

So, a content management tool is a production-grade system that a group of users need to do their jobs.

What part of that is *not* true for source control, build, testing, or deployment tools?

Development tools are production-grade systems that a group of users need to do their jobs. If we want to get starchy about it, we could make a case that development tools are *more* critical than content management. The cost of idle developers is higher than the cost of idle merchants. And, if content goes stale, then at least old content remains visible. Imagine being unable to fix a critical bug in your revenue-generating system because your build tool is down. The cost mounts quickly!

Historically, I was sometimes reluctant to put development tools under production-level protection, because it meant handing control over to an Operations group. Or worse, internal IT, who would try to centralize us all on one ancient PVCS installation. These days, though, we more often see a team dedicated to creating and operating the "ecosystem tools" who are much closer to development.

{/aside}

A potential downside of the walking skeleton is that we risk front-loading decisions that we don't yet need to make. Tomorrow we will know more about this project than we do today. That means today is the most ignorant I will ever be about this decision. Put that way, procrastination sounds like the smart approach! Sadly, while procrastination helps us avoid making ignorant decisions, it doesn't help us reduce that ignorance. We must decide, act, and reflect to learn what the original decision should have been.

Faced with this paradox, I choose to make decisions with an eye toward minimizing the cost of being wrong. That is, I would like to make the cost of changing or reversing one of these decisions bearable.

## Make descisions orthogonal, not contingent

A contingent decision is one which is contrained by earlier choices. For example, if we chose to use "company" as the entity to represent a confidentiality boundary, then decisions about how to represent multiple related systems within a company are constrained.(Either we lump everything into one "company" or we create an idea of "friend" interfaces between companies.)

In this case, I don't want to unnecessarily couple decisions about the test tools to deployment tools, or deployment to the target platform. There may be places where I choose to relax this rule, but only when the gain is large enough to offset future restrictions.

Unfortunately, many of the tools out there bring their own contingent decisions along with them. For instance, it would make zero sense to use AWS CloudFormation to build environments in Azure. If you treat it purely as a technical challenge, like writing the Game of Life in Mondrian, I'm sure you can find a way to run enough scripts and SSH to make it work, but you're really not going with the grain of the tool. But that's what I mean by a contingent decision: picking CloudFormation as a deployment tool makes some further choices easy and others will be hard or impossible.

Contingent decisions drastically increase the cost of changing a decision. "But if we do X, then we also have to do Y and Z," is the sound of a contingent decision exploding your cost of change. It feels like pulling one thread only to find that you're dragging a bunch of anchors along behind you.

## Observe the Spectrum of Change

As designers and developers, we make decisions about what to embody as architecture, code, and data based on known requirements and our experience and intuition.

We pick some kinds of changes and say they are so likely that we should represent the current choice as data in the system. For instance, who are the users? You can imagine a system where the user base is so fixed that there's no data representing the user or users. Consider a single-user application like a word processor before the web. Today, a word processor keeps data to represent the user for various collaboration features.

Another system might implicitly indicate there is just one community of users. So there's no data that represents an organization of users... the organization is implicit. On the other hand, if you're building a SaaS system, you expect whole communities of users to come and go. (Hopefully, more come than go!) So you make a community into data because you expect them to change rapidly.

If you are build a SaaS system for a small, fixed market you might decide that the population won't change very often. In that case, you might represent a population of users in the architecture via instancing. (Though I must also caution that every "instanced" company I've seen has eventually made a huge effort to reach true multitenancy, almost always due to the high operating cost of instancing.)

So data is at the high-energy end of the spectrum, where we expect constant change. Next would be decisions that are contemplated in code but only made concrete in configuration. These aren't quite as easy to change as data. Furthermore, we expect that only one answer to any given configuration choice is operative at a time. That's in contrast to data where there can be multiple choices active simultaneously.

Below configuration are decisions represented explicitly in code. Constructs like policy objects, strategy patterns, and plugins all indicate our belief that the answer to a particular decision will change rapidly. We know it is likely to change, so we localize the current answer to a single class or function. This is the origin of the "Single Responsibility Principle."

Farther down the spectrum, we have cross-cutting behavior in a single system. Logging, authentication, and persistence are the typical examples here. Would it be meaningful to say push these up into a higher level like configuration? What about data?

Then we have those things which are so implicit to the service or application that they aren't even represented. Everybody has a story about when they had to make one of these explicit for the first time. It may be adding a native app to a Web architecture, or going from single-currency, single-language to multinational.

Next we run into things that we expect to change very rarely. These are cross-cutting behavior across multiple systems. Authentication services and schemas often land at this level.

The farther toward the "red" end of the spectrum we push a concern, the more tectonic it will be to change it.

No particular decision falls naturally at one level or another. We just have experience and intuition about which kinds of changes happen with greatest frequency. That intuition isn't always right.

If we make an effort to turn everything into data, we will arrive at rules engines and logic programming. That doesn't usually end up with the end-user control we think. It turns out we need programmers to think through changes to rules in a rules engine because thinking in that way is kind of what makes a programmer. Instead of democratizing the changes, we would have made them even more esoteric!

The most decisions we energy-boost to that level, the more it costs. And at some point you generalize enough that all you've done is create a new programming language. If everything about your application is data, you've written an interpreter and recursed one level higher. Now you still have to decide how to encode everything in that new language.

With these two maxims in mind, it's time to make some choices about where this will live and how to build it.

## Documenting Architecture Decisions

A certain wise man once sang "If you choose not to decide, you still have made a choice." Behind that choice is a lot of context. When you decide (or choose not to decide) you have all kinds of context in your head: the current state of the system, the company, skills present in your team, roadblocks in the organization, details of technologies in use and under consideration, and so on. A decision which is right for your situation may look strange or even wrong to people later or who lack your current understanding. On the other hand, you might have only some of the facts and later information may cause you to re-evaluate a choice.

The reasoning behind a decision is important and I've found it useful to document the decision itself, in a format called an "Architecture Decision Record" or ADR. An ADR consists of 4 parts:

1. The current context.
2. The decision made in that context.
3. The consequences of that decision.
4. The status of the decision itself. (Proposed, accepted, superceded, rejected.)

Save the persuasive writing for English classes and project pitches. Each part here states a series of facts. Bullets are fine, but try to use active voice sentences so readers know who is doing what. (That's especially important in the decision section.)

Once proposed, an ADR can be changed which a team discusses and makes the actual decision. After that, however, it should stay the same. It may get out of date with respect to the system, but we fully expect that. In fact, future decisions might alter or reverse part of an old decision. It's totally normal to see an ADR about adding a framework, followed some time later by another ADR about removing the very same framework. By recording the decisions, future team members can catch up on years of evolution in an hour or two. The old ADRs will explain something that the "as-built" documentation can't: *why* the system looks the way it does.

A system that has evolved over time won't look like it would with a clean-sheet rewrite. That's OK! A "lived-in" look can be cozy and familiar. I describe it as a system that shows its history. *Here* is the spot where we cut out that framework, but you can still see a wrapping interface we used. Over *there* is where the old GUI technology connected to the domain layer. That's why we have all these domain objects with the visitor pattern. (And by the way, you should read ADR 32, about removing the vestiges of the visitor.)

Some projects even record their decision to use architecture decision records. It's like bootstrapping via ADR 1. ADR 1 explains what an ADR is, frequently with a link to my [original blog post](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions) about the technique. This meta-ADR serves the same purpose as the regular ones. When someone who wasn't part of the original decision wants to understand the project, they can read ADR 1 to learn the technique and why the team chose to adopt it.

I'm using [Nat Pryce's](https://github.com/npryce) [adr-tools](https://github.com/npryce/adr-tools) automation to keep my format consistent, which gives us ADR 1 as soon as we run `adr init`. It's visible in the source repository for the real system, but I'm also including it here in the book for clarity and ease of reading.

{aside, class: discussion}
# 1. Record architecture decisions

Date: 2019-02-22

## Status

Accepted

## Context

We need to record the architectural decisions made on this project.

## Decision

We will use Architecture Decision Records, as [described by Michael Nygard](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions).

## Consequences

See Michael Nygard's article, linked above. For a lightweight ADR toolset, see Nat Pryce's [adr-tools](https://github.com/npryce/adr-tools).
{/aside}

## Infrastructure and Superstructure

Where will this system run? How shall we build it? Where do we want to land on the spectrum from infrastructure to platform? It's time to make some decisions. I may regret some of these later, but let's get started and see what needs to be modified later.

{aside, class: discussion}
# 2. Use AWS

Date: 2019-02-22

## Status

Accepted

## Context

The system should be available from multiple devices, with the same record of facts.

A desktop application would require some kind of synchronization via files, perhaps in Dropbox, OneDrive, GDrive, or the like. File locking and version conflicts are a concern.

A web application with a database handles the synchronization. However, a web application requires some place to run. In 2019, we can assume use of a cloud platform, but must decide which one to use.

The development team knows AWS the best. This could be a motive to pick Azure or GCP, if the dev team's learning is an objective.

This system will have a small number of users and operate at low scale. Requests will be very intermittent.

The operator would like to keep the monthly cost footprint down.

Cloud providers offer proprietary services with non-standard APIs. These can supply a lot of functionality, at the expense of lock-in on those services.

Embracing vendor services results in a large number of contingent decisions.

Wrapping vendor services is costly to implement and results in "lowest common denominator" functionality.

## Decision

We will build the system on AWS.

Furthermore, we will embrace vendor services without attempting to wrap them or isolate ourselves from them.

## Consequences

The dev team won't learn a new cloud platform.

The reader will learn how to build a complete system with AWS.

We will need to choose which AWS compute, storage, and networking services to use. Some of these choices will have serious cost implications.

We have the option to use AWS Cognito for user management and access control.

Build and deployment tools have excellent support for AWS, so we expect to have greater options with those.
{/aside}

So now that we have the "where" identified, we also need to talk about "what" and "how"

{aside, class: discussion}
# 3. Rich front end with API

Date: 2019-02-22

## Status

Accepted

## Context

We need to define the basic architecture of the system.

The GUI must be responsive. This implies at least some asynchronous behavior on the page, and probably means optimistic GUI updates.

Server-side page rendering for form submission is slow and *deeply* unfashionable now.

Excellent tools exist to define and implement HTTP based APIs.

## Decision

We will build the system as a back end API server with a rich front end. It may or may not be a single-page app, but page loads should be minimized in the important flows (i.e., when capturing information.)

We will create source modules that match this structure:

1. `api` for the back end service
2. `ui` for the front end code

## Consequences

We have an enormous array of frameworks and libraries to choose from. No matter what we pick, at least one person will think it's the dumbest choice in the world.

We must also decide how information will be passed between the front and back ends.

We have an open question about how to serve static assets and where they should live in the source tree.

We have an open question about testing, specifically how much integration testing is required.
{/aside}

{aside, class: discussion}
# 4. Clojure and ClojureScript

Date: 2019-02-22

## Status

Accepted

## Context

Viable choices for back end implementation language, based on the dev team's skills include:

- Ruby (with Rails, naturally)
- Go
- Python
- Rust
- Java
- Scala
- Clojure
- Elixir

 Candidate choices for the front end include:

- ClojureScript
- Typescript
- Elm

The dev team has little experience with vanilla Javascript.

Virtually any combination of these languages can implement the constructs of ADR 3.

Any choice of languages will be unfamiliar to some readers, though some choices will be more foreign than others.

The dev team's most recent experience is with Clojure and ClojureScript.

## Decision

We will use Clojure for the API, and ClojureScript for the UI.

## Consequences

Code will require more explanatory text due to the unfamiliar syntax.

Where possible, we can use isomorphic code between back-end and front-end.
{/aside}