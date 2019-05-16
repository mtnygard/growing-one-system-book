---
title: Growing One System
...


<section>

Let's build something together. In fact, let's build a real system running in
production, with users and all. We will do it incrementally, in the cloud, with
continuous delivery. And the whole process will be written down to show the
twists, turns, and dead ends. Finally, just to make it even more visible and
(potentially) embarrassing, let's put that historical record online
incrementally too.

</section>

## Why Read This Book

If you're interested in seeing a continuously-deployed, microservice-based,
end-to-end system you might enjoy this book.

If you are curious about Clojure development, I'll be using that language quite
a bit, so you might enjoy this book.

If you're interested in making and documenting architecture decisions
incrementally, you might enjoy this book.

Finally, if you're interested in a system to create and query fact based
systems, you might enjoy this book.

## Why Write This Book

I'm inspired here by Jesse Liberty's "Clouds to Code" which did the same thing
for a C++ system in the 1990's. I admired Jesse's transparency as he worked
through the book and system together. Some of the early decisions worked out
well, but some of them didn't. He courageously left all of them in the book,
without trying to gloss over any of the dead-ends or bad choices. Meanwhile,
readers learned his thought process. I hope to achieve the same thing here:
share my thought process as best I can. The "why" of a decision is much more
interesting than the "what."

Two other influences on this book are the online book projects, [Crafting
Interpreters](http://craftinginterpreters.com/) by Bob Nystrom and [Writing an
OS in Rust](https://os.phil-opp.com/) by Phil Opperman. Each of these in
currently being published one chapter at a time, with every line of code shown.
Bob and Phil are both excellent writers and I've enjoyed following these
projects and coding along one installment at a time. Somehow, even the wait
between chapters makes me appreciate each new piece more. Binge-watching may be
good for entertainment but probably not so much for knowledge retention. Every
time a new chapter comes out, I need to review the previous work, so it
naturally creates a periodic reinforcement.

One place where this project differs from Bob and Phil is that they both have
clear roadmaps. Their goal is to teach, with the project as a vehicle for that
teaching. They've also each done enough design to know where they are going. I'm
going out on a limb a bit here by including the design in the book itself. A
typical installment will have some retrospective, architecture, design, coding,
and operations work. That means I will make mistakes, some serious and some
risible. Feedback welcome. "Pull requests welcome" as they say. And I mean that
in the encouraging way, not the "code or GTFO" way!

Finally, a third factor. Putting this out in the open will apply some pressure
to keep going and _finish_ the thing. My virtual workshop holds dozens of
half-baked projects. It's a good thing they don't take up space in my house.
(Nevermind that partially assembled RepRap over there. Or that stack of
Raspberry Pis that will be put to good use _any day now_.) A deadline does
wonders for my focus. An audience, even more so!

## My Commitments to You

Dear reader, I commit to be open and intellectually honest in this process. I
will not erase mistakes from the record, nor from previous chapters. Dead ends
will remain dead ends. I will assume that your feedback and criticism comes from
a place of generous contribution and positive intent. I may revise the prose of
previous chapters, especially where your feedback tells me that I've skipped
something in technical presentation. I may improve the clarity or sharpen the
text to make it more useful to the next reader.

## Reporting Issues and Keeping Updated

I hope you will find the process interesting rather than self-indulgent. Feel
free to [tweet at me](https://twitter.com/mtnygard) or post an issue on Github.
If, by some chance, you also find the system itself interesting, I would be
delighted to hear about that too. Since my target user is mainly just me, I
expect focus group testing to be pretty easy to arrange. On the other hand,
myopia can set in quickly. Let me know where you see problems, edge cases, or
howlers in the design. Please head to the [project
repository](https://github.com/mtnygard/growing-one-system) and report an issue.
You just might get incorporated into the next chapter!

   - [Vague Definitions](01-definitions.html)
   - [The Walking Skeleton](02-walking-skeleton.html)
