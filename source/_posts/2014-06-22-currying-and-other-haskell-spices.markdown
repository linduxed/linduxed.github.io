---
layout: post
title: "Currying and other Haskell spices"
date: Tue, 21 Jan 2014 22:24:04 +0000
comments: true
categories: tech
---
Most people who start looking at Haskell come from a background of one of the
more established languages. Be it Java, Ruby, Python or something else; most
often in those method signatures very clearly define the way in which the
methods can be called.

Not only does Haskell do things a bit differently, the differences allow for
increased flexibility when it comes to usage of functions in general.

<!--more-->

## A simple intro

The `(+)` function takes two arguments and returns the sum of those two
arguments (provided it's actually possible to sum the two). You can both invoke
it the "infix" way:

    Prelude> 2 + 3
    5

...or by using the usual function application syntax (function first, arguments
later):

    Prelude> (+) 2 3
    5

In the case of `+` we need to surround it with parentheses for it not to be
treated as an infix function.

Let's look at the type of `+`:

    Prelude> :type (+)
    (+) :: Num a => a -> a -> a

The `Num a` part indicates that the type variable a must implement the
typeclass `Num`. That's a fancy way of saying that our arguments (represented
by the `a`'s) must work like numbers. The fact that they're all `a`'s also
means that the arguments and the return value must all have the same type. For
people coming from languages like Java, think of `Num` as an interface that
each `a` must implement.

When you see that type declaration you might be thinking thinking "Why does it
use the same arrow `(->)` for both arguments and return values?"

The reason for this is that functions in Haskell actually take only one
argument and either return a result or a new function. For our `+` function,
this could be shown as follows:

    Prelude> :type (+) 2
    (+) 2 :: Num a => a -> a

Note that this new function takes one `a` and returns an `a` (once again, as
long as they're `Num`). It's the same syntax as before, but this time since
we're at the end of the line, we don't get a function but a result back.

These functions which return "intermediate" functions due to having more than
one argument are called *curried functions*. The interesting thing about this
is (as you might have figured out from the `(+) 2` example) that we can create
so called partially applied functions with great ease.

We could use that previous example to create a handy `plusTen` function:

    Prelude> let plusTen = (+) 10
    Prelude> :type plusTen
    plusTen :: Integer -> Integer
    Prelude> plusTen 10
    20
    Prelude> plusTen 1
    11

As said, this is a very simple example, but I think we can see some potential
here!

## Partial application in bulk

So in the example with `(+)` we created the more rigid `plusTen` function as an
alternative to being able to add any number to any other number. As you might
have guessed, this comes in handy when you have a useful general function, from
which you can spawn various utility functions, just by setting one or two
arguments to fixed values.

The fact that Haskell considers these partially applied functions as valid
constructs that we can pass around means that you could incorporate them into
more complex structures.

### Selling apples

Let's imagine that we've got an apple salesman, standing in the middle of
a town square and he needs to attract the attention of people around him. He's
got red and green apples, and he can either be really loud and obnoxious or
just quietly announce what he has to sell.

Here's some code:

```haskell
module Apples where

data Apple = Green | Red
data Loudness = Loud | Quiet

shouting :: Apple -> Loudness -> String
shouting Green Quiet = "Emerald green apples; get your Granny Smiths here!"
shouting Green Loud  = "GREEN APPLES, YOU NEED ONE!"
shouting Red   Quiet = "Ruby red apples; get your Red Delicious here!"
shouting Red   Loud  = "RED APPLES DAMMIT, BUY EM'!"
```

We're using pattern matching in this case to handle the various
`Apple`-`Loudness` combinations, but it could have been implemented any other
way.

We can try to load this module and make the salesman peddle his apples:

    Prelude> :load apples.hs
    [1 of 1] Compiling Apples           ( apples.hs, interpreted  )
    Ok, modules loaded: Apples.
    *Apples> shouting Green Loud
    "GREEN APPLES, YOU NEED ONE!"
    *Apples> shouting Red Quiet
    "Ruby red apples; get your Red Delicious here!"

OK, so that works, but it would get tedious quick. I mean, we've got a basket
full of apples to sell:

    *Apples> let basket = [Red, Red, Green, Red, Green, Red]
    *Apples> :t basket
    basket :: [Apple]

So what if we just generated a lot of functions which already have their Apple set?

### Other spices

The `zipWith` function takes two lists, takes the head of both of the lists and
apply a given function to both of the values. The result is put into a new
array, then this is repeated until one of the first two lists have run out of
elements. An example:

    *Apples> zipWith (+) [1,1,1,1] [1,2,3,4]
    [2,3,4,5]

There's another function which is generally used as an infix operator that's
called `$`. It serves the purpose of eliminating parentheses. Look at the
following example and see that the two calls are equivalent:

    *Apples> head $ reverse $ "Hello!"
    '!'
    *Apples> head ( reverse ( "Hello!" ) )
    '!'

We'll bring in a final function to help us, `repeat`. It creates an infinite
list of whatever you give it. Since Haskell is lazily evaluated, as long as you
only take a fixed number of elements from this list, having an infinite list is
totally fine:

    *Apples> take 4 $ repeat 1
    [1,1,1,1]

### Putting it all together

Let's combine them all and generate some "Apple-fixed" functions!

    *Apples> let basketShouting = zipWith ($) (repeat shouting) basket
    *Apples> :t basketShouting
    basketShouting :: [Loudness -> String]

Lots of stuff going on here so let's take it piece by piece.

We take the function `($)` and give its first argument from the first list.
This list is an infinite list that looks like this:

    [shouting, shouting, shouting...]

As the second argument for the `$` function we take the first element from the
second list. The second list looks like this:

    [Red, Red, Green, Red, Green]

Do this until one list runs out of elements (hint: it's not the infinite one),
and our resulting list will look something like this:

    [shouting Red, shouting Red, shouting Green, shouting Red, shouting Green]

You see, we used `$` to "bind" the function and the argument together. Since
function argument is the same thing as function $ argument we can use that
operator to tie things together as nicely as we've done here.

I should mention that the more experienced readers might be saying "Hey, why
not just use a `map` instead of `zipWith`?"

Good point, but where's the fun in that? :-P

To continue: with this collection of partially applied functions, it's as if
the peddler is holding the apples, just having to decide whether he wants to be
`Loud` or `Quiet`. He could for instance decide that he wants to start `Quiet`
with the first apple:

    *Apples> (head basketShouting) Quiet
    "Ruby red apples; get your Red Delicious here!"

Then he might want to `Loud`ly sell his third apple:

    *Apples> (basketShouting !! 2) Loud
    "GREEN APPLES, YOU NEED ONE!"

The `!!` function takes a list index (starting with zero).

Finally we could go ahead and have the guy sell all of the apples:

    *Apples> zipWith ($) basketShouting (repeat Loud)
    ["RED APPLES DAMMIT, BUY EM'!","RED APPLES DAMMIT, BUY EM'!","GREEN APPLES, YOU NEED ONE!","RED APPLES DAMMIT, BUY EM'!","GREEN APPLES, YOU NEED ONE!"]

Let's turn this into a newline separated string and have it look like some real
output:

    *Apples> putStrLn $ unlines $ zipWith ($) basketShouting (repeat Loud)
    RED APPLES DAMMIT, BUY EM'!
    RED APPLES DAMMIT, BUY EM'!
    GREEN APPLES, YOU NEED ONE!
    RED APPLES DAMMIT, BUY EM'!
    GREEN APPLES, YOU NEED ONE!

And there we have it! Loud and clear.
