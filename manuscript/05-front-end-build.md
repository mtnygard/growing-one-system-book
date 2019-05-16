---
title: Front End Build
...

<section>

Front end development can be wonderful once you have a working build. Change a
line of code and see its effect in milliseconds with hot reloading. Use the
developer console to run snippets of code inside your environment. But getting that build working sometimes feels like doing a jigsaw puzzle without the picture on the box. Add in a transpiled language (or two!) and it can get positively maddening.

</section>

## Building ClojureScript

I will try to keep the build as simple as possible. It starts with [Shadow-cljs](http://shadow-cljs.org/), which compiles ClojureScript, manages the CLJS dependencies, and does hot code reloading. It looks for a file called `shadow-cljs.edn`. "EDN" is short for Extensible Data Notation, which is a human-readable data serialization format. Think of it like JSON with better type preservation. EDN is commonly used in the Clojure ecosystem because it can be both read and emitted with only the core library.

``` {.clojure .numberLines}
{:source-paths ["src"]
 :dependencies [[reagent "0.8.1"]
                [re-frame "0.10.6"]
                [binaryage/devtools "0.9.10"]
                [thheller/shadow-cljsjs "0.0.16"]
                [day8.re-frame/http-fx "0.1.6"]
                [day8.re-frame/re-frame-10x "0.3.7-react16"]
                [day8.re-frame/tracing "0.5.1"]]
 :dev-http     {8080 {:root      "target/"
                      :proxy-url "http://localhost:3000"}}
 :builds       {:app {:output-dir       "target/"
                      :asset-path       "."
                      :target           :browser
                      :modules          {:main {:init-fn igles.main/init}}
                      :compiler-options {:closure-defines {"goog.DEBUG"                                 true
                                                           "re_frame.trace.trace_enabled_QMARK_"        true
                                                           "day8.re_frame.tracing.trace_enabled_QMARK_" true}}
                      :devtools         {:preloads   [day8.re-frame-10x.preload
                                                      devtools.preload]
                                         :after-load igles.main/reload!}}}}
```

The dependencies on lines 2 through 8 are expresssed in a shorthand notation for Maven coordinates. In `shadow-cljs.edn` these are little 2-vectors with a symbol as the first element and a string as the second. You could read this file into any other tool and manipulate its contents. It's data. Shadow-cljs itself interprets the symbol by mapping the namespace (the part before the slash) as the Maven group ID and the part after the slash as the Maven artifact ID. The string identifies the version. Dependencies that don't have a namespace mean the group ID is the same as the artifact ID.

We won't worry too much about the `:builds` section for now. Mostly we note that the output files go under `target`, which is also the root that our dev server can vend from. Also, we are targeting a browser for the build. Shadow-cljs can target Node for back end work as well.

Under `:dev-http` we also see `:proxy-url`. This allows the front end code to make XHR calls to the same origin, and the dev server will transparently proxy through to a different server. This lets us mimic the deployment configuration a bit more closely, where we would have a single origin via a load balancer or other reverse proxy.

`shadow-cljs watch app` will let us build the Clojurescript code with hot reloading. But we're still missing some pieces. Namely, we need an HTML file to load the app along with non-Clojurescript dependencies.

I'm going to use Yarn to manage NPM packages and assemble things under `target`. The `package.json` file for that looks like this:


``` {.json .numberLines}
{
  "name": "growing-one-system-fe",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "watch": "shadow-cljs watch app",
    "compile": "shadow-cljs compile app",
    "release": "shadow-cljs release app",
    "html": "mkdir -p target && cp assets/index.html target/",
    "serve": "yarn html && http-server target/",
    "del": "rm -r target/*",
    "build": "yarn release && yarn html && yarn serve"
  },
  "author": "",
  "license": "EPL-2.0",
  "devDependencies": {
    "highlight.js": "^9.15.6",
    "http-server": "^0.11.1",
    "react-flip-move": "^3.0.3",
    "react-highlight.js": "^1.0.7",
    "shadow-cljs": "^2.8.0"
  },
  "dependencies": {
    "create-react-class": "^15.6.3",
    "react": "^16.8.5",
    "react-dom": "^16.8.5"
  }
}
```

Notice that the dependencies mainly revolve around React. Clojurescript doesn't know anything about React by itself. In order to make React visible within the Clojurescript code we do a little dance of assembly and loading.

## NPM Build

There are several ways to make NPM packages visible to Clojurescript. Every time I have to make a change to this part, though, it feels like I'm shaking the Jell-o. It can take a couple of hours to stabilize. So mostly, I try to find a pattern that works and stick with it. For this project, here are the rules:

1. Use Yarn to install the packages under `node_modules`
2. Use Yarn to copy our HTML source page to `target`
3. Use Shadow-cljs to compile the CLJS code to Javascript.
4. The CLJS compiler uses Google Closure to bundle (and optionally minify) the generated code.
5. Avoid webpack, babel, gulp, grunt, and npm unless absolutely necessary.


## The Host Page

We need one HTML page to load our app. Sometimes it will also directly load JS files to make them available for Clojurescript.[^re-frame]

[^re-frame]: {-}
  Re-frame uses Reagent, which knows to load React. So our HTML page doesn't need to refer to React directly. We _do_ need to specify React in `packages.json` to make the code available locally though.

Our HTML file looks like this:

```
<body>
<div id="app"/>
<script>var CLOSURE_UNCOMPILED_DEFINES = {"re_frame.trace.trace_enabled_QMARK_": true};</script>
<script src="main.js" type="text/javascript"></script>
<script>window.onload = function () { igles.main.init(); }</script>
</body>
```

Pretty simple. When our app initializes, it will rewrite the contents of the `app` div with our UI. The bit about `CLOSURE_UNCOMPILED_DEFINES` just lets us use Re-frame's debugging tools. We'll remove that later.

## Single-Player Clicker Game

To get the front-end event loop working, we'll write our own clicker game. [^cow] It has a button to increase your score, and another button to submit your score. Maybe we'll add in-app purchases for autoclickers, multiclickers, machine learning based clickers, and even blockchain clickers. (I fully expect to receive at least one termsheet based solely on the preceeding sentence.)

[^cow]: {-}
    See the essential [Cow Clicker article in Wired](https://www.wired.com/2011/12/ff-cowclicker/).

To make this into a re-frame application, we need to create:

1. A view to display the buttons and the current score
2. An event handler to increase the score
3. An event handler to submit the score
4. A database[^app-memory] to hold the score and UI state
5. A subscription to make the score available to the UI.

[^app-memory]: {-}
    It's a "database" in the broadest sense: a bunch of data. We use nested maps as a tree structure. Thus the app database might contain

    `{:user {:name "Michael" :admin? true}` 
    ` :view :create-world}`

    This structure would only be in the browser's memory. We might refer to "the value at `[:user :name]`" as a shorthand for getting the value of the `:name` key from the map which is the value of the `:user` key of the database. In code, that looks like one of the following equivalent expressions:

    - `(-> db :user :name)`
    - `(get-in db [:user :name])`
    - `(:name (:user db))`

### View

The most common view is a function that returns some data to be converted into HTML.

``` {.clojure .numberLines}
(defn capture-app
  []
  [:div
   [:h1 "This is here."]
   [:p (str "Clicked " @(rf/subscribe [:counter]) " times")]
   [:button {:on-click #(rf/dispatch [:counter-clicked])} "Click This!"]
   [:button {:on-click #(rf/dispatch [:submit-score])} "Submit your score"]])
```

Here we see a function `capture-app` which takes no parameters and returns a structure of nested vectors. The first element of each vector becomes the element tag. If the second element is a map, then it will be converted to HTML attributes. Everything else becomes a child of the element.[^hiccup]

[^hiccup]: {-} 
    This is called "Hiccup" format, because it was first introduced to Clojure by [James Reeves'](https://github.com/weavejester/hiccup) popular [Hiccup](https://github.com/weavejester/hiccup) library for generating HTML.

Line 5 uses a subscription to get the current score.[^deref]

[^deref]: {-}
    The `@` symbol on line 5 means "deref". In Clojure, we treat anything that mutates as a reference to a value. Dereferencing to get a value is clearly a point-in-time operation and we should not expect to get the same value back the next time we deref the reference.

Lines 6 defines a button with an `on-click` handler. The handler is an anonymous function (as indicated by the `#` before the open parenthesis.) That function dispatches a Re-frame event in response to the browser event.

Putting it together, line 6 creates a button that says "Click This!". When the user does click it, re-frame dispatches `:counter-clicked`.

Line 7 does much the same, but with a different label and a different event.

### Event Handler - Increase Score

The `:counter-clicked` event is just something we made up. It's not built into re-frame. For it to have any effect, we need to register an event handler.

``` {.clojure .numberLines}
(rf/reg-event-fx :counter-clicked
  (fn-traced [{:keys [db]} _]
    {:db (update db :counter inc)}))
```

There is some dense syntax there. Line 1 tells re-frame what event to handle and that the handler expects a full _coeffects map_. (That's because we use `reg-event-fx`. There is also `reg-event-db` that says we only expect to update the database. `reg-event-db` is a wrapper around `reg-event-fx`.) 

On line 2, we use `fn-traced` to help with debugging. This is part of re-frame's dev tools. In a release build it will reduce to `fn`. In a dev build, it does capture an execution trace that we can see in the [re-frame-10x dashboard](https://github.com/Day8/re-frame-10x).

Also on line 2, the argument vector [destructures] the first argument (the coeffects map) to extract the `:db` value. This is the current state of the application, supplied by re-frame. We ignore the second argument, which is just the event type.

On line 3, we return an effect map that says "replace the database with this new database," where the new database is created by updating the value of the `:counter` key in the old database.[^persist]

[^persist]: {-}
    The database is just a map, and like all maps in Clojure, it is immutable. A function like `update` returns a new value that incorporates a change from the old value.

It would be possible to write this in a more condensed form with `reg-event-db`:

``` {.clojure .numberLines}
(rf/reg-event-db :counter-clicked
  (fn-traced [db _]
    (update db :counter inc)))
```

Somewhere along the way I just got into the habit of using `reg-event-fx` by default, but this is a case where the shorter version also requires less explanation so in a future commit I will use this simpler version.

### Event Handler - Submit Score

We don't have a back end yet, so we can't really submit the score anywhere. We'll use logging to the console as a stand-in.

``` {.clojure .numberLines}
(rf/reg-event-fx :submit-score
  (fn-traced [{:keys [db]} _]
    {:db         (assoc db :submit-enabled false)
     :http-xhrio {:method          :post
                  :uri             "/v1/scores"
                  :params          {:payload [{"user/score" (:counter db)}]}
                  :timeout         8000
                  :format          (ajax/json-request-format)
                  :response-format (ajax/json-response-format)
                  :on-success      [:score-submitted]
                  :on-failure      [:submit-score-failed]}}))

(rf/reg-event-fx :score-submitted
  (fn-traced [{:keys [db]} _]
    {:db (assoc db :submit-enabled true)}))

(rf/reg-event-fx :submit-score-failed
  (fn-traced [{:keys [db]} response]
    (println response)
    {:db (assoc db :submit-enabeld true)}))
```

### Database

``` {.clojure .numberLines}
(ns igles.db)

(def initial-value {:counter 0
                    :submit-enabled true})
```

### Subscription

Re-frame strongly encourages us to keep logic out of the views. Even simple logic about concatenting strings or converting types should go into a subscription. Sometimes, that leads to relatively trivial subscriptions like this one:

``` {.clojure .numberLines}
(ns igles.subs
  (:require [re-frame.core :as rf]))

(rf/reg-sub :counter
  (fn [db _]
    (:counter db)))
```

