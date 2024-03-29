= Project
Hduration <http://rubyforge.org/projects/duration>

= Original Author
Matthew Harris <matt@matthewharris.org>
http://matthewharris.org

= Fork Authors
Paul Gibler <paul.gibler@velir.com>
Patrick Robertson <patrick.robertson@velir.com>
Herman verschooten <Herman@verschooten.net>

= Synopsis
Hduration objects are simple mechanisms that allow you to operate on durations
of time.

They allow you to know how much time has passed since a certain
point in time, or they can tell you how much time something is (when given as
seconds) in different units of time measurement.

Hdurations would particularly be useful for those scripts or applications that
allow you to know the uptime of themselves or perhaps provide a countdown until
a certain event.

As of version 0.1.0, the duration library has been completely rewritten with
better knowledge.

= Features
Hduration is packed with many features and has plans for many more.

=== Current features
* Duck typing objects to work with Hduration
* Localization support of formatted strings (feel free to submit your own!)
* Capability to compare durations to any object (duck typing)
* Arithmetic operations from Hduration instances are legal (duck typing)
* Convenience methods for creating durations from Time objects

=== Soon to come features
* Collection of holiday-related methods (creating durations since/until a holiday)
* A larger collection of locales
* Definitely have to put more Rubyisms in there too!
* ...and much more! (can't think of any yet)

= Credits
I want to thank everyone who downloaded duration, tried it, and sent me e-mails
of appreciation, feedback, bug reports and suggestions.

Your gratitude has motivated me to rework this almost-dead library and continue
to maintain it.

Thanks!

= Usage
Using the duration library is fairly simple and straight-forward.  The base
class most of you will be using is the Hduration class.

=== Initialization
There are two ways to initialize the Hduration class.  One way is to pass an
object capable of responding to the #to_i method.  That object is expected to
return an integer or float that represents the number of seconds for the
duration object.

The second way to initialize the Hduration class is to pass a key=>value paired
Hash object.  The hash's keys will be scanned for units of measurement defiend
in Hduration::UNITS or (the keys of) Hduration::MULTIPLES.

Here's an example of using the formerly mentioned solution:
    duration = Hduration.new(Time.now)
    => #<Hduration: 1981 weeks, 3 hours, 50 minutes and 44 seconds>

As you can see, it gave us the duration since the UNIX epoch.  This works fine
because Time objects respond to the #to_i method.  And Time#to_i returns a
UNIX timestamp (which is the number of seconds that have passed since the UNIX
epoch, January 1, 1970).

Before I move on to demonstrating the second solution, I'd like to note that
there are Time#to_duration, Time#duration and Hduration.since_epoch for
accomplishing similar tasks.

Alright, the second solution is to pass in a Hash object, as previously
mentioned.

For example:
    duration = Hduration.new(:hours => 12, :minutes => 58, :days => 14)
    => #<Hduration: 2 weeks, 12 hours and 58 minutes>

So, it works.  But also notice that I gave it `:days => 14', but it spat out
`2 weeks'.  Yes, Hduration knows what it's doing.

There are more keys you can pass.  Check all the keys available in the
Hduration::MULTIPLES hash to see.  All those keys are valid to pass.  Any
duplicated multiples will merely be added to each other, so be careful if that's
not the desired behavior.

=== Formatting
The Hduration class provides Hduration#format (alias: Hduration#strftime) for
formatting the time units into a string.

For more information on the identifiers it supports, check out Hduration#format.

Here's an example of how to format the known minutes in the duration:
    duration = Hduration.since_epoch
    duration.format('%~m passed: %m')
    => "minutes passed: 4"

Now, this may look a bit tricky at first, but it's somewhat similar to the
standard strftime() function you see in many lanuages, with the exception of the
weird "%~m" type identifiers.  These identifiers are the correct terminology for
the corresponding time unit.

The identifiers are locale-sensitive and can be easily changed to another
language.  Localization is done internally from the duration library, and does
not use the system's locales.

If you would like to write a locale for your language (if it doesn't exist),
you can simply read the source code of the existing locales lying within the
"duration/localizations" directory.  They are straight-forward 10-15 line
modules and are not complex at all.

=== Arithmetic
Hduration objects support arithmetic against any object that response to the
#to_i method.  This is pretty self-explanatory.  What happens when you divide
a duration by 2?

    duration = Hduration.since_epoch
    => #<Hduration: 1981 weeks, 4 hours, 12 minutes and 54 seconds>

    duration / 2
    => #<Hduration: 990 weeks, 3 days, 14 hours, 6 minutes and 27 seconds>

Pretty simple, right?

=== Magical Methods
Finally, Hduration has a few magical methods that are handled through the
#method_missing override.  Hduration instances support all method calls to such
methods as `round_<unit>_to_<unit>' and `<unit>_to_<unit>'.  These methods
basically convert their <unit> to another <unit> and spit back the numbers.

The `round_<unit>_to_<unit>' method rounds the converted unit.

    Hduration.since_epoch.weeks_to_days
    => 13867.0

    Hduration.since_epoch.round_weeks_to_days
    => 13867

    Hduration.since_epoch.weeks_to_days.round
    => 13867

= Feedback
Well, I hope you learned a lot from the above explanations.  Time for you to get
creative on your own now!

If you have any feedback, bug reports, suggestions or locale submissions, just
e-mail me at matt@matthewharris.org or shugotenshi@gmail.com and I will be glad
to answer you back.
