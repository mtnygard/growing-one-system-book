# What We Are Building

Open sourcerors since ancient times advise, "scratch your own itch." Build that which is useful to you and use it. Be your own first customer. Then you know it can be used by at least one person and you understand that person's needs. That's the plan here.

One of my most common engagements is an architecture review. These days most of them also relate to breaking big rocks into smaller rocks. In other days, the focus might have been to reduce TCO, improve stability, break down walls between groups, or just find performance problems. Whatever the ultimate aim, each effort has some similarities. Six to twelve times a year, I need to enter a new complex environment, understand the existing landscape, and find points of leverage. I will have somewhere between one day and several weeks to assimilate knowledge about the current systems in place, and I'm usually learning from people who've been immersed in it for years. We call it "knowledge transfer" which sounds very orderly, like a row of neatly organized boxes waiting to be loaded into one's cortex. Orderly it is not.

Rather than discussing every issue at the highest level of abstraction, then unpacking each one to the next level, and so on, the real work is fractal. We dive deep in certain areas then surface back to the high level. I leave "breadcrumbs" for myself to return to other areas for later exploration. We shift gears from abstract architecture concerns to talk about authentication and authorization, or monitoring, or database schema design. We swing from discussing the implementation style of a runtime component into delivery pipelines. Does it sound chaotic and disorganized? Sometimes it is!

As the receiver of the information, my task is to learn and remember. The information streams, with eddies and tributaries, and I must snare and organize the morsels that swim past. My hosts usually have some drawings or documents to supply the top-level structure. With luck, they've been updated in the same decade. Even when talking through these, however, people think of other things, offer historical details, or jump ahead to their most painful problems. The meeting agenda is more of a guideline than a law.

One more dimension complicates matters. The people may be wrong. After all, what they each share with me is their own understanding of the system. There are times when  key people hold incoherent or incomplete beliefs. Overlay two partially filled-in maps and they may disagree even if the landmarks align.

Ultimately, it's about integrating facts into a somewhat coherent model of the system, even when those facts arrive in fragments and may contradict each other. Most of the time I carry the model in a collection of documents, diagrams, and neurons, each with a partial, interlocking representation. Later, I interrogate that model to understand how the system-wide qualities are handled. I look for weak points, cut sets, immutable characteristics, fixed points, and points of leverage with high return.

## Visual from Text

Diagrams serve us well as tools for discussion and aids to memory. We're visual creatures, with something like half of all neural tissue involved in vision one way or another. Two thirds of our waking neural activity relates to vision according to [S.B. Sells and Richard S. Fixott](https://doi.org/10.1016/0002-9394(57)90012-0). Technical discussion without a whiteboard is like using Morse code for poetry... you can get the idea across but it take a long time and loses the impact. So pictures are essential.

However, when the river of knowledge is flowing past you, it's impossible to halt discussion while you mouse around in Visio, OmniGraffle, or an EA tool. Given enough mobile phone pictures of whiteboards, like freeze-frames of an action scene, you might be able to reconstruct something later, but I find that time spent pushing polygons could be used better for almost anything else.

So we have a paradox. Diagrams are supremely valuable, but time consuming to create. Quite a few people, myself included, have decided that the way to resolve this paradox is to treat diagrams as an output rather than a primary artifact. We'd prefer to generate diagrams from other representations---often just plain text with a thin DSL. Such text works well with our development tools and processes. It can be included in version control, with diffs and comments, and it can be published from a build pipeline. Generated diagrams may suffer in the aesthetic department, but that's an acceptable tradeoff.

Some examples:

- [Simon Brown](http://codingthearchitecture.com/)'s [C4 Model](https://c4model.com/) via [Structurizr](https://structurizr.com/)
- [PlantUML](http://plantuml.com)
- [Web Sequence Diagrams](https://www.websequencediagrams.com/)

Of course, the grandparent of all text-to-diagram tools is AT&T's quirky, and somewhat over-extended, [Graphviz](http://graphviz.org). Early on, Graphviz demonstrated that textual input was valuable precisely because it could be the _output_ of other tools. We didn't need a different diagramming tool for every kind of language or toolchain if we could simply output DOT from a precarious pile of Perl scripts. Even better, if the diagrams' input comes from other tools' output, then we have at least a chance of keeping the visuals up to date with reality.

So our system should be able to create diagrams from facts. That demands a lot more detail about how to project facts onto pictures, which detail I'm just going to wave my hands over and claim we'll "do something reasonable." (A trademark phrase from Dave Gillespie, one of my earliest CS instructors.)

## Modes of Use

For capturing facts, this system ought to be reachable from different devices at different times. I'd also like to pull knowledge and diagrams out via other tools or applications. That pushes me toward a web-based solution. (It won't come as a surprise that I decided that before picking a title for this book!) The system should have a highly-usable user interface and an API.

What does highly-usable mean? This question comes up pretty often when we discuss architectural priorities. Among the canonical set of [architecture qualities](https://github.com/mtnygard/architecture-qualities) I use (from "Software Architecture in Practice, 3rd ed.", by Bass, Clements, and Kazman), we find "usability." What a subjective term! Usability depends on who the users are. It's much more about "fitness for purpose" rather than just having large, friendly buttons separated by copious whitespace. A system to be used very infrequently mainly by novices should have exactly those friendly buttons and whitespace. But a trading application for a fixed-income desk is just the opposite. There the users want maximum information density and clicking through a GUI is the opposite of usable.

Who are the users here and what do they value? At first blush, it's just me. I value speed of entry and high mnemonic value. (I keep a lot of information in systems and tools. I call them my exo-cortex because I have a terribly inconsistent memory. Some days I can’t remember what I ate for lunch, but somehow I still recall how to start a machine language program on a C-64 and Merlin's cantrip from "Excalibur". It frustrates the hell out of me, but I've developed techniques to compensate.) As an example, I keep a lot of my personal notes and tasks in text files with Emacs' [org-mode](https://orgmode.org/) following a setup generously documented by [Bernt Hansen](http://doc.norang.ca/org-mode.html). When I recognize the need to record a to-do item, I alt-tab to Emacs and with one chord and a key, I can type the todo note. With two more keystrokes, I'm done and back to what I was doing before. The whole procedure takes half a second and only one "Emacs claw" (for the Control-Alt-R chord that kicks off the "remember" sequence.)

So, a first quality attribute scenario.

Perf-1: "When online, a user can enter a single fact via the GUI in under one second."

Sounds good, what other quality ... what's that? Oh, right! I haven't described a quality attribute scenario.

{aside}

## Quality Attribute Scenarios

A "quality" is one of the [architecture qualities](https://github.com/mtnygard/architecture-qualities) from "Software Architecture in Practice." Each quality is desirable, but sometimes they come into conflict with each other. There can be only one top priority, and we must sometimes sacrifice a bit of one quality to get a bit of another.

Qualities don't come in quanta. How do we know *how much* we sacrificed? For that matter, how do we know if we've even achieved any of the qualities? After all, we could totally screw up and deliver none of them.

Try this as an exercise: gather the stakeholders in a room, teach them the list of qualities, and ask them to make a strict ranking. It won't take very long before someone says, "Yes, but what *exactly* does 'performance' mean?" That leads us to decompose qualities into quality attributes. Nest the attributes under the qualities to build a "quality attribute tree." For example,

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

Here we see some quality attributes that can easily come into conflict. "Easy user access" and "user data confidentiality" pull the system in opposite directions. Which one wins? That is a choice that you must make based on your context, constraints, risk posture, etc.

Now, the pedant in our meeting will turn to the next question, "What *exactly* does 'easy user access' mean?"[^derail] Now we define a quality attribute scenario (QAS.) These have four parts: in a *context*, a *stimulus* affects a *component*, which *responds*.

In the scenario "Perf-1", these parts are:

- Context: when online
- Stimulus: a user can enter a single fact
- Component: via the GUI
- Response: in under one second

This is quite concrete and measurable. Indeed, we should be able to objectively verify whether each QAS is met or not met.

Once we break the qualities down into QAS's, the top-level tension betweens qualities, such as security and usability, can sometimes be resolved without sacrifice. We may have a QAS under "easy user access" which requires a mobile phone number for self-service password reset and another QAS under "user data confidentiality" which says user data may not be revealed without password verification or 2FA.

We will use quality attribute scenarios often in this book.

[^derail]: This is an ideal strategy to derail any meeting whose outcome you want to prevent. Simply ask for ever-more-precise definitions until the clock runs out.

{/aside}


## Wrapping Up

At this point, we have only the barest definition of this system. We know who the main user constituency is and their primary needs. However, we don't have much detailed understanding of the problem space or how to solve it. We will explore that next.


{caption: Quality Attribute Scenarios}
|============|============|============|============|
| ID         | Quality    | Attribute  | Scenario   |
|============|============|============|============|
| Perf-1     | Performance | GUI Response Time | When online, a user can enter a single fact via the GUI in under one second. |
|------------|------------|------------|------------|
