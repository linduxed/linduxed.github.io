---
layout: post
title: "Writing more readable RSpec tests"
date: 2014-08-24 17:32:27 +0200
comments: true
categories: tech
---
Some time ago Joe Ferris wrote a piece on the thoughtbot blog called ["Let's Not"][lets-not] (that I recommend you read first),
which concerns itself with the usage of various RSpec helper methods.
Methods like `let`, `before` and `subject` come under fire and are deemed as problematic.

  [lets-not]: http://robots.thoughtbot.com/lets-not

While I agree with the message of the article,
I feel that I could expand on the part about **why** these helpers are as problematic as Mr. Ferris makes them out to be.

<!--more-->

I should start off by saying that while my thoughts pertain specifically to usage of RSpec,
a lot of the mentioned structures, methods and patterns are recurrent in other frameworks and languages.
I'm sure there's information here that could be extrapolated to your non-RSpec setup.

## Cognitive load

When I write a test there are two rules which guide my writing :

* All of the necessary information for understanding what is being tested should be readily available.
* The collaborators in the test should be as minimal as possible.
* Minimize cleverness.

{% pullquote %}
The key thing to remember is that a test is written once but read many more times.
If they aren't on the TODO list for refactoring, then {" you generally don't care about your tests while they're green; it's when they go red that you start reading them. "}
This is why it's of importance that when something *does* break in your system, you want the test to tell you in as straightforward language as possible *what* broke and *why*.
{% endpullquote %}

Having written tests with and without them for some time now, I find that tools like `let`, `before` and `subject` DRY up your tests, but often at the cost of making the tests less readable.

## Examples in the wild

Let's look at some code to see what I mean.

One of the things I did to learn Rails was to go through [Michael Hartl's Ruby on Rails guide](http://www.railstutorial.org/book),
a book which instructs its readers to write their tests in such a way that it starts to violate some of the aforementioned guidelines.

Before I continue I wish to make it clear that I value the book highly: it helped me tremendously and I definitely recommend it as one of the better introductory books for Rails (at least out of those that I know of).
Additionally, despite what I consider being shortcomings in how the test-related portions of the book are written, these portions contain valuable lessons about *what* to test, so please don't let this blog post discourage you from reading it.

With that said, there are plenty of examples which illustrate the issues that arise from too extensive usage of the various facilities that RSpec offers you.

### User model tests

Let's start by looking at the tests for [the `User` model][user-model].
Due to the size of the file, I've removed some tests which I won't be using to illustrate my point.

  [user-model]: https://github.com/mhartl/sample_app/blob/master/spec/models/user_spec.rb

```ruby
require 'spec_helper'

describe User do

  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  # ...
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }

  it { should be_valid }
  it { should_not be_admin }

  # ...

  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end

    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(older_micropost) }
      its(:feed) { should include(newer_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  # ...
end
```

Let's assume that the test on line 57 breaks: for some reason the `newer_micropost` isn't included in `its` feed.

The most likely thing you'll first do is open this spec file and jump down to the line in question.
Here's when the redundantly arduous procedure starts:

#### Jumping back and forth

First we have to figure out what the `subject` that `its` refers to is.
Let's backtrack through the code all the way up to line 10 to figure out.
Or well, not really, because you'll have to read through line 6 to get to know what `@user` actually means.

Next, what's this `newer_micropost` thing?
We'll have to jump up to lines 29-31 to figure that out.
Apparently it's of essence that `newer_micropost` is evaluated before each example in which it's invoked (since `let!` is used instead of `let`).

{% blockquote Right before Listing 10.10 http://www.railstutorial.org/book/user_microposts#sec-ordering_and_dependency %}
This uses the let! (read “let bang”) method in place of let; the reason is that let variables are lazy, meaning that they only spring into existence when referenced. The problem is that we want the microposts to exist immediately, so that the timestamps are in the right order and so that @user.microposts isn’t empty. We accomplish this with let!, which forces the corresponding variable to come into existence immediately.
{% endblockquote %}

So, the usage of `let!` instead of `let` here is completely unrelated to our broken test.
Good to know.

Speaking of which, is it really of relevance to us that the `newer_micropost` was `created_at: 1.hour.ago`?
I would assume not, but considering we're using this memoized value and not a `micropost` created just for the test on line 57, we can only guess.

Oh, I just accidentally noticed that on line 25 apparently the `@user` gets saved!
I'm not sure if that changes things but it sure is good to know.

I guess we'll need to look at some setup to make sense of this:

Lines 51-54 tell us that `@user` should `follow!` something called `followed_user`.
Oh, that's right above at line 49, fine.
Then we create three microposts with a specified content, sure.

#### Analyzing the journey

To do nothing but *understand* the full scope of the setup and expectations for the one test on line 57, there's *a lot* of jumping around, hunting for the procedure that makes the test happen.

When I'm already in a confused state over why a test tells me that something in my code broke, the **last** thing I want to do is spend time deciphering the test.
I've often heard people from the Ruby community talk about using tests as a live documentation for your code, but if I need to put in this much work to read the documentation than I'm starting to think that I might as well read the source code.
If the code is well written there will be less to read anyway.

I mentioned previously that I strive to have all the necessary information readily available, where in this case we have a couple of [Mystery guests][mystery-guest] instead.

Confusion was introduced because we had to consider redundant information due to a too large [General fixture][general-fixture].

Finally we had the case of needing immediate evaluation of something that is normally lazily evaluated (`let` vs `let!`), increasing "cleverness" of the tests.

  [mystery-guest]: http://xunitpatterns.com/Obscure%20Test.html#Mystery%20Guest
  [general-fixture]: http://xunitpatterns.com/Obscure%20Test.html#General%20Fixture

Let's see what this will look like if we try to avoid these helper methods.

### Alternate implementation of User model tests

Let's start off by talking about the `respond_to`, `be_valid` and `be_admin` expectations, since they're somewhat unrelated to the topic at hand:

First of all, I'm not a fan of testing whether something gets responded to or not.
Test what it does, and if all it does is that it delegates a message somewhere else, ensure that the message is sent.
These tests ensure the *existence* of an interface, not its workings.  
Tests of this kind could be an attempt to ensure that inheritance of certain methods has occurred, so for the sake of brevity we'll just assume that's the case (if you check [the tests][tests] and then [the code][code], you'll notice that's not the case for all of them).

  [tests]: https://github.com/mhartl/sample_app/blob/master/spec/models/user_spec.rb#L26-L28
  [code]: https://github.com/mhartl/sample_app/blob/master/app/models/user.rb#L22-L32

Let's turn that block of tests into a case where I *could* imagine `subject` being used.
Oh, and let's assume that we have a `User` factory available.  
I suspect that the reason `@user` was instantiated the way it was on on line 6 above, was because it allowed the tests to build an instance of `User` but run `@user.save` only in the tests where it was necessary (like on line 25).  
We'll use `FactoryGirl.build` and `FactoryGirl.create` instead.

```ruby
require 'spec_helper'

describe User do
  describe 'inherited methods' do
    subject do
      FactoryGirl.build(:user,
        name: "Example User",
        email: "user@example.com",
        password: "foobar",
        password_confirmation: "foobar"
      )
    end

    it { should respond_to(:name) }
    it { should respond_to(:email) }
    # ...
    it { should respond_to(:follow!) }
    it { should respond_to(:unfollow!) }

    it { should be_valid }
    it { should_not be_admin }
  end

  # ...
end
```

I think this could be written without `subject` as well, but this is a case where it would be an acceptable usage, due to the trivial setup that one needs to comprehend after reading a test that broke.

Let's now extend this code with the rewritten `describe "micropost associations"` block:

```ruby
require 'spec_helper'

describe User do
  describe 'inherited methods' do
    subject do
      FactoryGirl.build(:user,
        name: "Example User",
        email: "user@example.com",
        password: "foobar",
        password_confirmation: "foobar"
      )
    end

    it { should respond_to(:name) }
    it { should respond_to(:email) }
    # ...
    it { should respond_to(:follow!) }
    it { should respond_to(:unfollow!) }

    it { should be_valid }
    it { should_not be_admin }
  end

  describe 'micropost associations' do
    it 'has the right microposts in the right order' do
      user = FactoryGirl.create(:user)
      older_micropost = FactoryGirl.create(:micropost, user: user, created_at: 1.day.ago)
      newer_micropost = FactoryGirl.create(:micropost, user: user, created_at: 1.hour.ago)

      user.microposts.should == [newer_micropost, older_micropost]
    end

    it 'destroys associated microposts' do
      user = FactoryGirl.create(:user)
      FactoryGirl.create_list(:micropost, 2, user: user)
      microposts = user.microposts

      user.destroy

      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
    end
  end

  describe "#feed" do
    it 'includes only followed microposts' do
      user_that_follows = FactoryGirl.create(:user)
      own_posts = FactoryGirl.create_list(:micropost, 3, user: user_that_follows)
      not_followed_user = FactoryGirl.create(:user)
      not_followed_post = FactoryGirl.create(:micropost, user: not_followed_user)
      followed_user = FactoryGirl.create(:user)
      followed_posts = FactoryGirl.create_list(:micropost, 3, user: followed_user)

      user_that_follows.follow!(followed_user)

      feed = user_that_follows.feed
      expect(feed).to include(own_posts)
      expect(feed).to include(followed_posts)
      expect(feed).not_to include(not_followed_post)
    end
  end

  # ...
end
```

A number of different things have happened to the tests:

* The `#feed`-related tests have been indented out, giving them a dedicated `describe` block in which we clearly test nothing but the `#feed` method.
* Every `it`-block is self-contained and has everything it needs to carry out the test.
  We've avoided the [Mystery guest][mystery-guest] problem.
* Every `it`-block is written to use a uniform structure of Setup, Procedure and Expectations (in the test on line 25, Procedure was not needed).
* Every collaborating object is as minimal as necessary, assuming that the factories are written [as minimal as possible (only to pass validation)][factory-girl].
  We've avoided the [General fixture][general-fixture] problem.

  [mystery-guest]: http://xunitpatterns.com/Obscure%20Test.html#Mystery%20Guest
  [general-fixture]: http://xunitpatterns.com/Obscure%20Test.html#General%20Fixture
  [factory-girl]: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#defining-factories

### Nested `describe` blocks

While not entirely related, an issue that I've found reoccurring in tests that make heavy use of `subject`, `let` and `before` is deeply nested `describe` blocks.

[This spec file is a great example of it][user-pages-spec] (too long to include here).

  [user-pages-spec]: https://github.com/mhartl/sample_app/blob/master/spec/requests/user_pages_spec.rb

I remember myself writing these tests when I was going through the tutorial and thinking that it was so clever that you could extend previous scenarios by nesting a `describe` inside a previous one.
The error message was extended in a "natural" way, appending just a tiny bit more.
I didn't need to write particularly large tests either, since they could use all the stuff that was defined a couple of indendentation levels back.

This is enabled by the previously mentioned methods.

It's also an express train to Confusion Town.

While it might sound cool, it rapidly becomes a frustrating mess to read.
It's essentially a way to exacerbate the already significant potential that the methods have to write confusing tests.

## Final words

There's [a video on the subject][upcase], where the man behind the ["Let's Not"][lets-not] article talks about all of these things.
The full video is behind a pay-wall, but if you don't already have an account on Upcase I do recommend getting one, since they've got a lot of good material on the site.

Additionally, let me close by linking to a [short but classic post by Jeff Atwood][coding-horror] on the subject of how to code.

  [upcase]: https://upcase.com/videos/rspec-best-practices
  [lets-not]: http://robots.thoughtbot.com/lets-not
  [coding-horror]: http://blog.codinghorror.com/coding-for-violent-psychopaths/
