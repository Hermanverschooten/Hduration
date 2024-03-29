# -*- encoding : utf-8 -*-
require 'hduration/time/holidays'

class Time
  extend Holidays

  def to_duration
    Hduration.new(self)
  end

  alias_method :duration, :to_duration
end
