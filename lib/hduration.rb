# -*- encoding : utf-8 -*-
require 'hduration/version'
require 'hduration/numeric'
require 'hduration/time'
require 'hduration/localizations'
Hduration::Localizations.load_all

# Hduration objects are simple mechanisms that allow you to operate on durations
# of time.  They allow you to know how much time has passed since a certain
# point in time, or they can tell you how much time something is (when given as
# seconds) in different units of time measurement.  Hdurations would particularly
# be useful for those scripts or applications that allow you to know the uptime
# of themselves or perhaps provide a countdown until a certain event.
class Hduration
  include Comparable
  include Enumerable

  # Unit multiples
  MULTIPLES = {
    :seconds => 1,
    :minutes => 60,
    :hours   => 3600,
    :days    => 86400,
    :weeks   => 604800,
    :second  => 1,
    :minute  => 60,
    :hour    => 3600,
    :day     => 86400,
    :week    => 604800
  }

  # Unit names
  UNITS = [:seconds, :minutes, :hours, :days, :weeks]

  attr_reader :total, :seconds, :minutes, :hours, :days, :weeks

  # Change the locale Hduration will use when converting itself to a string
  def Hduration.change_locale(locale)
    @@locale = Localizations.locales[locale.to_sym] or raise LocaleError, "undefined locale '#{locale}'"
  end

  # Load default locale
  change_locale(Localizations::DEFAULT_LOCALE)

  # Constructs a Hduration instance that represents the duration since the UNIX
  # epoch (1970-01-01T00:00:00Z)
  def Hduration.since_epoch
    new(Time.now)
  end

  # Calculates the duration "since" a given time.  Assumes that the time is in
  # the past.  Does not error if the time is in the present or future.
  def Hduration.since(time)
    new(Time.now.to_i - time.to_i)
  end

  # Calculates the duration "until" a given time.  Assumes that the time is in
  # the future.  Does not error if a time in the present or past is given.
  def Hduration.until(time)
    new(time.to_i - Time.now.to_i)
  end

  # Initialize a duration.  `args' can be a hash or anything else.  If a hash is
  # passed, it will be scanned for a key=>value pair of time units such as those
  # listed in the Hduration::UNITS array or Hduration::MULTIPLES hash.
  #
  # If anything else except a hash is passed, #to_i is invoked on that object
  # and expects that it return the number of seconds desired for the duration.
  def initialize(args = 0)
    # Two types of arguments are accepted.  If it isn't a hash, it's converted
    # to an integer.
    if args.kind_of?(Hash)
      @seconds = 0
      MULTIPLES.each do |unit, multiple|
        unit = unit.to_sym
        @seconds += args[unit] * multiple if args.key?(unit)
      end
    else
      @seconds = args.to_i
    end

    # Calculate duration
    calculate!
  end

  # Calculates the duration from seconds and figures out what the actual
  # durations are in specific units.  This method is called internally, and
  # does not need to be called by user code.
  def calculate!
		multiples = [MULTIPLES[:weeks], MULTIPLES[:days], MULTIPLES[:hours], MULTIPLES[:minutes], MULTIPLES[:seconds]]
		units     = []
		@total    = @seconds.to_f.round
		multiples.inject(@total) do |total, multiple|
		  # Divide into largest unit
			units << total / multiple
			total % multiple # The remainder will be divided as the next largest
		end

		# Gather the divided units
		@weeks, @days, @hours, @minutes, @seconds = units
  end

  # Compare this duration to another (or objects that respond to #to_i)
	def <=>(other)
		@total <=> other.to_i
	end

  # Convenient iterator for going through each duration unit from lowest to
  # highest.  (Goes from seconds...weeks)
  def each
    UNITS.each { |unit| yield unit, __send__(unit) }
  end

  # Format a duration into a human-readable string.
  #
  #   %w  => weeks
  #   %d  => days
  #   %h  => hours
  #   %m  => minutes
  #   %s  => seconds
  #   %t  => total seconds
  #   %H  => zero-padded hours
  #   %M  => zero-padded minutes
  #   %S  => zero-padded seconds
  #   %~s => locale-dependent "seconds" terminology
  #   %~m => locale-dependent "minutes" terminology
  #   %~h => locale-dependent "hours" terminology
  #   %~d => locale-dependent "days" terminology
  #   %~w => locale-dependent "weeks" terminology
  #
  def format(format_str)
    identifiers = {
      'w'  => @weeks,
      'd'  => @days,
      'h'  => @hours,
      'm'  => @minutes,
      's'  => @seconds,
      't'  => @total,
      'H'  => @hours.to_s.rjust(2, '0'),
      'M'  => @minutes.to_s.rjust(2, '0'),
      'S'  => @seconds.to_s.rjust(2, '0'),
      '~s' => @seconds == 1 ? @@locale.singulars[0] : @@locale.plurals[0],
      '~m' => @minutes == 1 ? @@locale.singulars[1] : @@locale.plurals[1],
      '~h' => @hours   == 1 ? @@locale.singulars[2] : @@locale.plurals[2],
      '~d' => @days    == 1 ? @@locale.singulars[3] : @@locale.plurals[3],
      '~w' => @weeks   == 1 ? @@locale.singulars[4] : @@locale.plurals[4]
    }

		format_str.gsub(/%?%(w|d|h|m|s|t|H|M|S|~(?:s|m|h|d|w))/) do |match|
			match['%%'] ? match : identifiers[match[1..-1]]
		end.gsub('%%', '%')
  end

  def method_missing(m, *args, &block)
    units = UNITS.join('|')
    match = /(round_)?(#{units})_to_(#{units})$/.match(m.to_s)
    if match
      seconds = ((__send__(match[2].to_sym) * MULTIPLES[match[2].to_sym]) / MULTIPLES[match[3].to_sym].to_f)
      match[1] ? seconds.round : seconds
    else
      super
    end
  end

  # String representation of the Hduration object.
  def to_s
    @@locale.format.call(self)
  end

  # Inspect Hduration object.
	def inspect
		"#<#{self.class}: #{(s = to_s).empty? ? '...' : s}>"
	end

	def +(other)
		Hduration.new(@total + other.to_i)
	end

	def -(other)
		Hduration.new(@total - other.to_i)
	end

	def *(other)
		Hduration.new(@total * other.to_i)
	end

	def /(other)
		Hduration.new(@total / other.to_i)
	end

	def %(other)
		Hduration.new(@total % other.to_i)
	end

  def seconds=(seconds)
    initialize :seconds => (@total + seconds) - @seconds
  end

  def minutes=(minutes)
    initialize :seconds => @total - minutes_to_seconds, :minutes => minutes
  end

  def hours=(hours)
    initialize :seconds => @total - hours_to_seconds, :hours => hours
  end

  def days=(days)
    initialize :seconds => @total - days_to_seconds, :days => days
  end

  def weeks=(weeks)
    initialize :seconds => @total - weeks_to_seconds, :weeks => weeks
  end

  alias_method :to_i, :total
  alias_method :strftime, :format
end
