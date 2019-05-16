---
title: Front to Back
...

<section>
Let's start with the front end of the walking skeleton.[^mix]  It will be a ClojureScript application, per ADR 4. Like every other front end language, ClojureScript compiles into JavaScript.
It plays reasonably well with the NPM ecosystem, so we can take advantage of the
many packages that exist out there. Right up front, though, I have to say that
my personal practice is to be parsimonious with dependencies. I like to keep my
dependency tree narrow and shallow. In part, that comes from a history of
frustration with [dependency
breakage](https://www.theregister.co.uk/2016/03/23/npm_left_pad_chaos/) in a
deep tree. The probability that a breaking change appears somewhere in the span
of my dependencies seems to go up much faster than linearly with the number of
libraries I use. Even without breaking changes, we've also seen untrustworthy
maintainers become a
[problem](https://github.com/dominictarr/event-stream/issues/116).

[^mix]: {-}
  Mixing these metaphors creates some odd imagery.

</section>

## When Do I Add a Dependency?

So there will certainly be times that I add code to my application in order to
avoid adding a library. That even extends to copy-and-paste from open source
libraries, if the part I need is small and the library is large.

Despite that, it would be foolhardy to eschew the millions of lines of code that
I can integrate with a simple `yarn add` command. There is a serious tension
here between the desire to go faster now by adding libraries versus the desire
to _keep_ going faster later by avoiding them. It's a kind of trade-off that we
don't talk about often enough. I don't have a hard and fast rule to offer.
Instead, each library is its own case. My decision on each one will hinge on a
few factors:

1. How much value do I get from the module? Note that this is not asking how
   much it offers, but how much I will use. A large module from which
   I use only one function is a big burden in future cost.
2. Is it well encapsulated? How much does it distort my application? For
   example, can I simply add an attribute to an element to get "copy to
   clipboard?" If so, then there's very little distortion to my application. On
   the other hand, some modules are frameworks rather than libraries.
3. How well do I understand the module? I am not an expert in JavaScript so
   there's a cost to digging through the module's code. (Naturally, there's a
   benefit too... after all, digging through code is how one _becomes_ an
   expert!) I need to balance the cost of grokking one module versus an
   alternative. Fortunately for me, the Node ecosystem is vast enough that
   almost every module has an alternative or three.

What's the difference between a library and a framework? A library is something
that my code calls[^lib], but my code is still in control of the overall flow,
as shown in figure 1. A framework is something that I may start up, but then it
takes over the control flow and calls my code. With a framework, my code is at
the leaves of the call tree, as in figure 2.[^framework]

[^lib]: {-}
  ![Libraries are something I call](images/library.png)
  With a library, the library functions are the leaves of the call tree.

[^framework]: {-}
  ![A framework calls me](images/framework.png)
  A framework "takes over" the top level and calls back into my code. Of course, my code may also call other parts of the framework.

Typical of human language, the edges of the two concepts blur into each other.
There are libraries that use callbacks, and frameworks that have library
functions to call. We apply the terms based on how the most important
interactions flow.

For this application, I've picked a framework that will be the basis for
everything in the front end.

## Framing the Front End

Lately, I've been working with a ClojureScript framework called
[Re-frame](https://github.com/Day8/re-frame). Re-frame is a framework that
provides an out-of-the-box architecture for an SPA.

An out-of-the-box architecture is where the framework itself makes important
decisions about the components you will build and their expected patterns of
interaction. Probably the most famous out-of-the-box architecture is Ruby on
Rails. When you sit down with the source to a Rails project, you already know
where to find the source code, visual assets, how to run tests, how to set up
the database, and so on. You know how to run that application. And when you do
run the application, you know what components to expect (controllers, models,
helpers, views, and view fragments) and how they get called.

At Relevance, when it was a Rails shop, developers could rotate from project to
project on a daily basis, because each project had enough in common that you
could be "not dangerous" right away. Individual projects may deviate from the
out-of-the-box architecture, but that means you just need to learn the deltas
rather than a whole new architecture from scratch.

Likewise, when building on an out-of-the-box architecture, many of your early
decisions about code structure and runtime interactions have ready defaults. You
can choose to deviate later when you know more, but the early structure allows
you to get moving so you _can_ learn where the app needs to deviate.

Re-frame builds on top of [React](http://reactjs.org) and uses the "shadow DOM"[^shadow] it provides. A Re-frame application follows an event loop that almost looks like a game engine:

1. Dispatch events
2. Invoke event handlers, passing each the current state of the world. Each
   event handler returns a map of "effects" that it wants to be applied to the
   world.
3. Invoke effect handlers, passing each the effects declared by the event
   handlers.
4. Query the application state, according to subscriptions from views.
5. Invoke view functions to return components and data.
6. Render the components into the shadow DOM.

[^shadow]: {-}
    The shadow DOM is just an object tree in memory whose nodes are in 1:1 correspondence with the real DOM. Updating the shadow DOM is faster than the real one because it doesn't trigger expensive layout and rendering operations in the browser. After a rendering cycle, all the changes to the shadow DOM are applied to the real DOM in a batch.

The main parts we write are the event handlers, effect handlers, queries,
and views. That's what makes Re-frame a framework. It owns the flow of control
and our code plugs in at the leaves of the call tree.

Something that takes a bit of getting used to in Re-frame applications: most of
what we write are pure functions. Take the event handlers for example. They
don't really _do_ anything. As pure functions, they just take in data and return
data, but they don't have any side effects. In most application frameworks your
event handlers are the main engine of change. Not in Re-frame. Here the event
handlers specify in data what some other functions will apply to the world
later.

For example, suppose my UI has a button that says "log in." In the good old days
of vanilla JavaScript, you might put an `onClick` handler on that button that
does an XHR directly to the back end. Easy enough to code, but hard to test,
hard to deal with asynchrony, and hard to keep track of logic and constraints.
In a Re-frame app, we might do this:

``` clojure
[:button.btn-default {:on-click (fn [event] (re-frame/dispatch [:begin-login])}]
```

We'll deal with most of the syntax later. For now, just notice that we attach a
function to the `onClick` event which just asks Re-frame to dispatch an
application-level event.

Somewhere, we had better say how to handle such an event. That would look
something like this:

``` {.clojure .numberLines}
(re-frame/reg-event-db :begin-login                     
  (fn [current-db event]                                
    (let [new-db (assoc current-db :logging-in? true)]  
      new-db))                                          
```

There's a lot packed into those five lines of code, so let's look at it step by step.

Line 1 tells Re-frame that we are registering an event handler, and that it will
return a new database value.

Line 2 provides the second argument to `reg-event-db` which has to be a
function. So we define a function right here inline. It takes the current
"database" and the event. The application database is the current "state of the
world." It's not a database in the RDBMS or NoSQL sense. It's just an in-memory
value that keeps track of my application's state. Most of the time, we use a map
for this database.

In fact, line 3 create a new map by associating (pronounced like "a sosh" not "a
sock") a key `:logging-in?` with the value `true`. In ClojureScript, like in
Clojure, data structures such as maps are immutable. Instead of changing a map
in place, we make a copy of the old map with some changes incorporated.

Line 4 returns the new map.

Taken together, it means that whenever Re-frame dispatches the `:begin-login`
event, we set a flag in the application state to say that we're attempting to
login. The view layer might use that information to show a spinner or disable
some other buttons.

Well, so far with this trivial example, it might seem like jumping through a lot
of hoops to accomplish something as basic as setting a flag. The real value
shows through with more complicated interactions. Because each handler is a pure
function, I can call them directly with my own arguments (the framework doesn't
have to be involved) for tests or exploration. Further, I can use tooling to
look at all the events that were dispatched and see what the database looked
like both before and after the event. Finally, I can make the view layer a
derivative of the database which removes a lot of the weird corner cases that we
can otherwise get into.

By the way, I wrote that example code in a verbose way to help separate concepts
into lines. In a real application, I might do it more like this:

```{.clojure .numberLines}
(re-frame/reg-event-db :begin-login             
  (fn [db _]                                    
    (assoc db :logging-in? true)))              
```

The underscore `_` on line 2 is a legitimate identifier in ClojureScript and
Clojure, but by convention it means "I'm not going to use this value." Also,
notice that I'm no longer using a `let` to bind the new database value to a
name... I just return it directly by having it be the last form in the function.

### Compression versus Comprehension

My purpose here is not compression for its own sake, nor am I trying to play
code golf. My objective is to get rid of boilerplate and cruft so one glance at
the code tells me what it does. I'm trying to optimize for code reading rather
than code writing. There is definitely such a thing as going too far though. For
example, I could write the same event handler like this:

``` clojure
(defn s! [k] (fn [v & _] (assoc v k true)))[^hof1]

;; a hundred lines away ...

(re-frame/reg-event-db :begin-login
  (s! :logging-in?))
```

[hof1]: {-}
  If you're interested, the `s!` function returns another function which will later associate `true` to the key that was given to `s!` in a database that is given to the returned function. Yes, that did take me three times as many characters to explain as to code!

I would say that this version is over-compressed. The function `s!` is a fairly
trivial composition of basic language features. Once you've learned Clojure, the
phrase `(assoc db :logging-in? true)` is a natural chunk of meaning and it reads
the same in any Clojure program. To decipher `s!` I need to remember it has a
local, application-specific meaning. If I don't remember it, and `s!` is not
visible when I look at `:begin-login`, then I need to navigate to it and
navigate back to comprehend what I see. The mental overhead of that recall or
navigation is not worth the characters saved.

### Affecting the World

So far, the event handler we wrote only sets a flag in our local database. Most
of the time an action like "log in" requires some extra interaction with the
world. Suppose we need to invoke a back end API function for authentication. The
event handler _still_ doesn't directly do that invocation. Instead, it returns
an effect map with additional effects specified. Re-frame will find an
appropriate effect handler to invoke---or complain that no such effect exists,
of course.

Here's how an event handler for the `:begin-login` event might look:

```{.clojure .numberLines}
(re-frame/reg-event-fx :begin-login             
  (fn [cofx _]                                  
     {:db (assoc (:db cofx) :logging-in? true)  
      :http {:method :post                      
             :url "/api/v1/auth"                
             :on-success [:login-succeeded]     
             :on-failure [:login-failed]}}))    
```

Before we dive into the details of this function, notice two things. First, we
didn't change the `:on-click` function in the view at all. We get that
decoupling as a benefit of Re-frame's model.

Second, there's a subtle change on line 1. Instead of calling `reg-event-db`,
we're calling `reg-event-fx`. The difference has tripped me up more than once.
`reg-event-db` registers an event handler that Re-frame will call with the
current database and whose return value becomes the new database. But it turns
out that `reg-event-db` is a convenience function. The more general version is
`reg-event-fx`, which calls the event handler with a "coeffects map" and which
returns an "effects map."[^coeffects]

[^coeffects]: {-}
    As the prefix "co-" suggests, co-effects have their arrows reversed from normal effect. An _effect_ specifies a morphism from "external world" to a new "external world". A "co-effect" describes a function on the morphism itself. That is it changes how the effect gets applied.

    In concrete terms, co-effects take information from the world into the event handler, while the event handler sends information out to the world.

The effects map that we return allows one event handler to specify multiple
effects. Each key represents a different type of effect, and Re-frame uses those
keys to locate the correct effect handler to call.

On line 3, you can see that one of the effects we ask for is to update the
database. The effect handler for `:db` directly takes the value from that key
and splats it into the application database atom. (You might already be able to
picture how `reg-event-db` works... it creates a wrapper function that calls
your event handler then constructs a map with the `:db` and your function's
return value.)

Line 4 starts a new effect specification, for an effect handler called `:http`.
That one doesn't come with Re-frame. It's something we will implement. The value
of that effect is a map with some keys that we could use to issue an XHR.

A Re-frame application will define a handful of effect handlers. Each one of
defines its own micro-DSL for how the effect should be specified.

