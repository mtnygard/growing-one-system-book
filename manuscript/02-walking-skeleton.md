---
title: The Walking Skeleton
...

<section>

A "walking skeleton" does nothing, but it does nothing in a useful way. The
skeleton puts all the pieces in place, with calls that go from end to end, even
though it delivers no real functionality. The bones of the skeleton give us a
place to begin building functionality, while staying continuously integrated and
deployable.

In previous eras, a walking skeleton was permitted to perambulate your dev box.
These days, I prefer to also include a build pipeline and deployment. The
metaphor gets a bit strained, since we have a walking skeleton of our delivery
pipeline that deploys a walking skeleton of the production environment. Maybe I
should say the "anemic necromancer" raises the walking skeleton into production.
On the other hand, development is production, so I'll just call the whole thing
the walking skeleton.

A potential downside of the walking skeleton is that we risk front-loading
decisions that we don't yet need to make. Tomorrow we will know more about this
project than we do today. That means today is the most ignorant I will ever be
about this decision. Put that way, procrastination sounds like the smart
approach! Sadly, while procrastination helps us avoid making ignorant decisions,
it doesn't help us reduce that ignorance. We must decide, act, and reflect to
learn what the original decision should have been.

Faced with this paradox, I choose to make decisions with an eye toward
minimizing the cost of being wrong. That is, I would like to make the cost of
changing or reversing one of these decisions bearable.

</section>

## Make descisions orthogonal, not contingent

A contingent decision is one which is contrained by earlier choices. For
example, if we chose to use "company" as the entity to represent a
confidentiality boundary, then decisions about how to represent multiple related
systems within a company are constrained.(Either we lump everything into one
"company" or we create an idea of "friend" interfaces between companies.)

In this case, I don't want to unnecessarily couple decisions about the test
tools to deployment tools, or deployment to the target platform. There may be
places where I choose to relax this rule, but only when the gain is large enough
to offset future restrictions.

Unfortunately, many of the tools out there bring their own contingent decisions
along with them. For instance, it would make zero sense to use AWS
CloudFormation to build environments in Azure. If you treat it purely as a
technical challenge, like writing the Game of Life in Mondrian, I'm sure you can
find a way to run enough scripts and SSH to make it work, but you're really not
going with the grain of the tool. But that's what I mean by a contingent
decision: picking CloudFormation as a deployment tool makes some further choices
easy and others will be hard or impossible.

Contingent decisions drastically increase the cost of changing a decision. "But
if we do X, then we also have to do Y and Z," is the sound of a contingent
decision exploding your cost of change. It feels like pulling one thread only to
find that you're dragging a bunch of anchors along behind you.

## Observe the Spectrum of Change

As designers and developers, we make decisions about what to embody as
architecture, code, and data based on known requirements and our experience and
intuition.

We pick some kinds of changes and say they are so likely that we should
represent the current choice as data in the system. For instance, who are the
users? You can imagine a system where the user base is so fixed that there's no
data representing the user or users. Consider a single-user application like a
word processor before the web. Today, a word processor keeps data to represent
the user for various collaboration features.

Another system might implicitly indicate there is just one community of users.
So there's no data that represents an organization of users... the organization
is implicit. On the other hand, if you're building a SaaS system, you expect
whole communities of users to come and go. (Hopefully, more come than go!) So
you make a community into data because you expect them to change rapidly.

If you are build a SaaS system for a small, fixed market you might decide that
the population won't change very often. In that case, you might represent a
population of users in the architecture via instancing. (Though I must also
caution that every "instanced" company I've seen has eventually made a huge
effort to reach true multitenancy, almost always due to the high operating cost
of instancing.)

So data is at the high-energy end of the spectrum, where we expect constant
change. Next would be decisions that are contemplated in code but only made
concrete in configuration. These aren't quite as easy to change as data.
Furthermore, we expect that only one answer to any given configuration choice is
operative at a time. That's in contrast to data where there can be multiple
choices active simultaneously.

Below configuration are decisions represented explicitly in code. Constructs
like policy objects, strategy patterns, and plugins all indicate our belief that
the answer to a particular decision will change rapidly. We know it is likely to
change, so we localize the current answer to a single class or function. This is
the origin of the "Single Responsibility Principle."

Farther down the spectrum, we have cross-cutting behavior in a single system.
Logging, authentication, and persistence are the typical examples here. Would it
be meaningful to say push these up into a higher level like configuration? What
about data?

Then we have those things which are so implicit to the service or application
that they aren't even represented. Everybody has a story about when they had to
make one of these explicit for the first time. It may be adding a native app to
a Web architecture, or going from single-currency, single-language to
multinational.

Next we run into things that we expect to change very rarely. These are
cross-cutting behavior across multiple systems. Authentication services and
schemas often land at this level.

The farther toward the "red" end of the spectrum we push a concern, the more
tectonic it will be to change it.

No particular decision falls naturally at one level or another. We just have
experience and intuition about which kinds of changes happen with greatest
frequency. That intuition isn't always right.

If we make an effort to turn everything into data, we will arrive at rules
engines and logic programming. That doesn't usually end up with the end-user
control we think. It turns out we need programmers to think through changes to
rules in a rules engine because thinking in that way is kind of what makes a
programmer. Instead of democratizing the changes, we would have made them even
more esoteric!

The most decisions we energy-boost to that level, the more it costs. And at some
point you generalize enough that all you've done is create a new programming
language. If everything about your application is data, you've written an
interpreter and recursed one level higher. Now you still have to decide how to
encode everything in that new language.

With these two maxims in mind, it's time to make some [choices](03-documenting-architecture-decisions.html) about where this
will live and [how to build it](04-reframe-for-front-end.html).
