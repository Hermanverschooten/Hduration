# -*- encoding : utf-8 -*-
# -*- coding: utf-8 -*-
class Hduration
  module Localizations
    # Korean localization
    module Korean
      LOCALE    = :ko
      PLURALS   = %w(초 분 시간 일 주)
      SINGULARS = %w(초 분 시간 일 주)
      FORMAT    = proc do |duration|
    		str = duration.format('%w%~w, %d%~d, %h%~h, %m%~m, %s%~s')
    		str.sub(/^0[^\d+,]+,?/i, '').gsub(/ 0[^\d+,]+,?/i, '').chomp(',').strip
    	end
    end
  end
end
