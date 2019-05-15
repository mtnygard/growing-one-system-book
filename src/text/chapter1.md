---
title: Vague Definitions
stylesheet: tufte.css
...

# What We Are Building

Open sourcerors since ancient times advise, "scratch your own itch." Build that
which is useful to you and use it. Be your own first customer. Then you know it
can be used by at least one person and you understand that person's needs.
That's the plan here.

One of my most common engagements is an architecture review. These days most of
them also relate to breaking big rocks into smaller rocks. In other days, the
focus might have been to reduce TCO, improve stability, break down walls between
groups, or just find performance problems. Whatever the ultimate aim, each
effort has some similarities. Six to twelve times a year, I need to enter a new
complex environment, understand the existing landscape, and find points of
leverage. I will have somewhere between one day and several weeks to assimilate
knowledge about the current systems in place, and I'm usually learning from
people who've been immersed in it for years. We call it "knowledge transfer"
which sounds very orderly, like a row of neatly organized boxes waiting to be
loaded into one's cortex. Orderly it is not.

Rather than discussing every issue at the highest level of abstraction, then
unpacking each one to the next level, and so on, the real work is fractal. We
dive deep in certain areas then surface back to the high level. I leave
"breadcrumbs" for myself to return to other areas for later exploration. We
shift gears from abstract architecture concerns to talk about authentication and
authorization, or monitoring, or database schema design. We swing from
discussing the implementation style of a runtime component into delivery
pipelines. Does it sound chaotic and disorganized? Sometimes it is!

As the receiver of the information, my task is to learn and remember. The
information streams, with eddies and tributaries, and I must snare and organize
the morsels that swim past. My hosts usually have some drawings or documents to
supply the top-level structure. With luck, they've been updated in the same
decade. Even when talking through these, however, people think of other things,
offer historical details, or jump ahead to their most painful problems. The
meeting agenda is more of a guideline than a law.

One more dimension complicates matters. The people may be wrong. After all, what
they each share with me is their own understanding of the system. There are
times when  key people hold incoherent or incomplete beliefs. Overlay two
partially filled-in maps and they may disagree even if the landmarks align.

Ultimately, it's about integrating facts into a somewhat coherent model of the
system, even when those facts arrive in fragments and may contradict each other.
Most of the time I carry the model in a collection of documents, diagrams, and
neurons, each with a partial, interlocking representation. Later, I interrogate
that model to understand how the system-wide qualities are handled. I look for
weak points, cut sets, immutable characteristics, fixed points, and points of
leverage with high return.

This kind of system has been on my mind since the mid-2000's. I wrote an early
prototype as a collection of Eclipse plugins, but honestly even I didn't get a
lot of value out of it. (Mainly, I think it was too graphical, not textual
enough.) I've noodled on the current incarnation, off and on, since about 2016.
Even so, there is a vast gulf between vague daydreams and building something. We
have to sacrifice the infinite space of possibilities to picking *one* thing to
build. Oh, the pain of giving up all the things we choose not to build!

## Architecture Knowledge

At first, I may just learn that something called "LP" exists. That is a fact,
even if it isn't a very useful one. Still, if it has a name, it's worth
recording. So I'd like to enter a fact that says "there exists a component
called LP". Later, I'll learn that "LP" is another name for the "Loan Processor"
component. For now, let us say only that a component is an entity with a name
and a meaningful boundary.

Some components are more easily seen than others. A Linux container is surely a
component. A single virtual machine, likewise. But several instances of that
container may be used to implement the Loan Processor. So components may contain
other components. Components certainly invoke other components, either inside a
single process or across process boundaries. Is the Loan Processor just a single
container? Or is it all the containers that run the same code? Or should we say
it is the containers with their code, the database with its schema, the load
balancers with their configuration, the firewalls with their rules, and so
on...?

We will use an ecumenical approach. The system is about learning. Time spent
arguing with the dev teams about what constitutes a component could be spent
better on exploring more parts of the environment.

"What is architecture?" A question for the ages! Ruth Malan has a [great
page](http://www.bredemeyer.com/whatis.htm) with many useful (and a few
humorous) definitions. One useful definition is "it's the stuff that is hard to
change." Certainly true, but most easily seen in hindsight. [Dana
Bredemeyer](http://bredemeyer.com), a colleague of Ruth's, describes
architecture decisions as "those that must be made from a system perspective to
achieve system outcomes (capabilities and properties of the system)." I often
think of it as the set of decisions about patterns of interaction among
components.

For our purposes, architecture knowledge will begin with components and their
relationships. Later, we may find opportunities to express the desired qualities
in the system, but that is not a primary goal.

## Visual from Text

Diagrams serve us well as tools for discussion and aids to memory. We're visual
creatures, with something like half of all neural tissue involved in vision one
way or another. Two thirds of our waking neural activity relates to vision
according to [S.B. Sells and Richard S.
Fixott](https://doi.org/10.1016/0002-9394(57)90012-0). Technical discussion
without a whiteboard is like using Morse code for poetry... you can get the idea
across but it take a long time and loses the impact. So pictures are essential.

However, when the river of knowledge is flowing past you, it's impossible to
halt discussion while you mouse around in Visio, OmniGraffle, or an EA tool.
Given enough mobile phone pictures of whiteboards, like freeze-frames of an
action scene, you might be able to reconstruct something later, but I find that
time spent pushing polygons could be used better for almost anything else.

So we have a paradox. Diagrams are valuable, but time consuming to create. Quite
a few people, myself included, have decided that the way to resolve this paradox
is to treat diagrams as an output rather than a primary artifact. We'd prefer to
generate diagrams from other representations---often just plain text with a thin
DSL. Such text works well with our development tools and processes. It can be
included in version control, with diffs and comments, and it can be published
from a build pipeline. Generated diagrams may suffer in the aesthetic
department, but that's an acceptable tradeoff.

Some examples:

- [Simon Brown](http://codingthearchitecture.com/)'s [C4
  Model](https://c4model.com/) via [Structurizr](https://structurizr.com/)
- [PlantUML](http://plantuml.com)
- [Web Sequence Diagrams](https://www.websequencediagrams.com/)

Of course, the grandparent of all text-to-diagram tools is AT&T's quirky, and
somewhat over-extended, [Graphviz](http://graphviz.org). Early on, Graphviz
demonstrated that textual input was valuable precisely because it could be the
_output_ of other tools. We didn't need a different diagramming tool for every
kind of language or toolchain if we could simply output DOT from a precarious
pile of Perl scripts. Even better, if the diagrams' input comes from other
tools' output, then we have at least a chance of keeping the visuals up to date
with reality.

So our system should be able to create diagrams from facts. That demands a lot
more detail about how to project facts onto pictures, which I'm just going to
wave my hands over and claim we'll "do something reasonable." (A trademark
phrase from Dave Gillespie, one of my earliest CS instructors.)

A non-goal would be to create diagrams _directly_ from text. I'd rather see text
input feed a model, with generated diagrams as projections of the model.
Structurizr does something much like this, by running code to create an
in-memory representation of the model. That model is the basis for output.

## Modes of Use

For capturing facts, this system ought to be reachable from different devices at
different times. I'd also like to pull knowledge and diagrams out via other
tools or applications. That pushes me toward a web-based solution. (It won't
come as a surprise that I decided that before picking a title for this book!)
The system should have a highly-usable user interface and an API.

What does highly-usable mean? This question comes up pretty often when we
discuss architectural priorities. Among the canonical set of [architecture
qualities](https://github.com/mtnygard/architecture-qualities) I use (from
"Software Architecture in Practice, 3rd ed.", by Bass, Clements, and Kazman), we
find "usability." What a subjective term! Usability depends on who the users
are. It's much more about "fitness for purpose" rather than just having large,
friendly buttons separated by copious whitespace. A system to be used very
infrequently mainly by novices should have exactly those friendly buttons and
whitespace. But a trading application for a fixed-income desk is just the
opposite. There the users want maximum information density and clicking through
a GUI is the opposite of usable.

Who are the users here and what do they value? At first blush, it's just me. I
value speed of entry and high mnemonic value. (I keep a lot of information in
systems and tools. I call them my exo-cortex because I have a terribly
inconsistent memory. Some days I can’t remember what I ate for lunch, but
somehow I still recall how to start a machine language program on a C-64 and
Merlin's cantrip from "Excalibur". It frustrates the hell out of me, but I've
developed techniques to compensate.) As an example, I keep a lot of my personal
notes and tasks in text files with Emacs' [org-mode](https://orgmode.org/)
following a setup generously documented by [Bernt
Hansen](http://doc.norang.ca/org-mode.html). When I recognize the need to record
a to-do item, I alt-tab to Emacs and with one chord and a key, I can type the
todo note. With two more keystrokes, I'm done and back to what I was doing
before. The whole procedure takes half a second and only one "Emacs claw" (for
the Control-Alt-R chord that kicks off the "remember" sequence.)

So, a first quality attribute scenario.

Perf-1: "When online, a user can enter a single fact via the GUI in under one
second."

Sounds good, what other quality ... what's that? Oh, right! I haven't described
a quality attribute scenario.

## Quality Attribute Scenarios

A "quality" is one of the [architecture
qualities](https://github.com/mtnygard/architecture-qualities) from "Software
Architecture in Practice." Each quality is desirable, but sometimes they come
into conflict with each other. There can be only one top priority, and we must
sometimes sacrifice a bit of one quality to get a bit of another.

Qualities don't come in quanta. How do we know *how much* we sacrificed? For
that matter, how do we know if we've even achieved any of the qualities? After
all, we could totally screw up and deliver none of them.

Try this as an exercise: gather the stakeholders in a room, teach them the list
of qualities, and ask them to make a strict ranking. It won't take very long
before someone says, "Yes, but what *exactly* does 'performance' mean?" That
leads us to decompose qualities into quality attributes. Nest the attributes
under the qualities to build a "quality attribute tree." For example,

- Performance
  - UI response time
  - Transactions per second
  - Daily active users
  - ...
- Security
  - User data confidentiality
  - User data integrity
  - ...
- Usability
  - Easy user access
  - ...

Here we see some quality attributes that can easily come into conflict. "Easy
user access" and "user data confidentiality" pull the system in opposite
directions. Which one wins? That is a choice that you must make based on your
context, constraints, risk posture, etc.

Now, the pedant in our meeting will turn to the next question, "What *exactly*
does 'easy user access' mean?"[^derail] Now we define a quality attribute
scenario (QAS.) These have four parts: in a *context*, a *stimulus* affects a
*component*, which *responds*.

In the scenario "Perf-1", these parts are:

- Context: when online
- Stimulus: a user can enter a single fact
- Component: via the GUI
- Response: in under one second

This is quite concrete and measurable. Indeed, we should be able to objectively
verify whether each QAS is met or not met.

Once we break the qualities down into QAS's, the top-level tension betweens
qualities, such as security and usability, can sometimes be resolved without
sacrifice. We may have a QAS under "easy user access" which requires a mobile
phone number for self-service password reset and another QAS under "user data
confidentiality" which says user data may not be revealed without password
verification or 2FA.

We will use quality attribute scenarios often in this book.

[^derail]: This is an ideal strategy to derail any meeting whose outcome you
want to prevent. Simply ask for ever-more-precise definitions until the clock
runs out.

## Confidentiality

Even though this is mostly a single-user system, the *data* belongs to different
companies. There should never be a situation where data from different clients
gets co-mingled. No query shall ever return facts from different clients. No
diagram shall ever include components from different clients. Facts will always
be added in the context of a client.

By implication, then, the system has to have some representation of that
context. "Client" or "project" would be natural ways to view it, but I sense a
potential problem. Neither of those concepts are really isomorphic to the
coverage of an NDA. I can imagine a hierarchy of projects performed for a single
client, where one NDA would cover all. The problem is that I could equally
imagine a hierarchy of clients---perhaps to model a multinational company and
local subsidiaries. Does every client and every project define its own
confidentiality boundary? Are those nested? Should I be able to query across
child projects or child clients?

Suddenly, our system has grown quite a bit and will require an entire
administration interface to manage these hierarchies. How much value does that
add for the user? Zero. In fact, it *subtracts* value from the system!

The first error was using the idea "client" as the representation for a
different idea. We got fooled by nouns. (This will be a recurring theme. We
often get fooled by nouns.) Because we have a noun for "client" that somewhat
related to confidentiality and keeping knowledge separate, we grabbed onto that
noun and started modeling it. But the concept of "client" is bigger than we
need. It drags in a lot of baggage around hierarchies, multinational
corporations, cross-company visibility, and so on. Ultimately, any noun we use
for a concept in an information system is a metaphor for a whole complex of
interrelated concepts. It takes mental effort to break those concepts apart and
select the smallest, most independent one available. But it is worthwhile work.
Smaller concepts also tend to be more general and can be composed or re-composed
for different contexts.

For instance, once we build a model of organizations and their hierarchies, we
will be faced with some other structure that tries to cut across that. Like a
consortium of companies that jointly create a system to share some, but not all,
of their data. Now the organization model has to become more complex, with ideas
of "friendly" access to some facts but not others.

Or if we choose "project" as the primary dimension for confidentiality, then
we'll encounter a product-oriented company. So we probably overload the term
"project" to also apply to "products".

You can see how this one decision starts to drag other decisions into scope. I
think of this as weaving an irrelevant dimension into our system. It becomes
indivisible from the rest of the system. Every contingent decision restricts the
generality of our system.

{blurb} Don't use a "bigger" noun than required to represent a concept. {/blurb}

What we want is just separate fact bases. That doesn't require any concept of
client or project. We can leave those notions and their mappings to the user. Or
we can decide to implement some higher level constructs in the future. For now,
we keep them separate to keep our options open.

All we need to do is invent a new name for these separate fact bases. Naming is
hard, to be sure, but it is also one of the architect's superpowers. We'll talk
much more about naming later.

For the purpose of confidentiality, let's call each fact base a "World" and
write a quality attribute scenario about it.

Sec-1: "Under all circumstances, no output shall include facts from more than
one World."

That QAS touches output only, so it leaves us with room to make decisions about
appropriate solutions. It doesn't mandate isolated storage or isolated
processing. That might not be sufficient protection for every client's IP
protection requirements, so we may need to add stronger scenarios in the future.

## Wrapping Up

At this point, we have only the barest definition of this system. We know who
the main user constituency is and their primary needs. We know that fact entry
will be via text---though we have yet to define the format of that text---and
that diagrams will be created from the facts.

Next, it's time to actually get something up and running. Or at least shambling.

+------------+-------------+-------------------+-----------------------------------------------------+
| ID         | Quality     | Attribute         | Scenario                                            |
+============+=============+===================+=====================================================+
| Perf-1     | Performance | GUI Response Time | When online, a user can enter a single fact via the GUI in under one second. |
+------------+-------------+-------------------+-----------------------------------------------------+
| Sec-1      | Security    | Confidentiality   | Under all circumstances, no output shall include facts from more than one World. |
+------------+-------------+-------------------+-----------------------------------------------------+

: Quality Attribute Scenarios

