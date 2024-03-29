# -*- encoding : utf-8 -*-
require 'hduration/locale'
require 'hduration/localizations/english'
require 'hduration/localizations/korean'
require 'hduration/localizations/french'
require 'hduration/localizations/dutch'
require 'hduration/localizations/polish'

class Hduration
  # Contains localizations for the time formatters.  Standard locales cannot be
  # used because they don't define time units.
  module Localizations
    # Default locale
    DEFAULT_LOCALE = :en
    @@locales = {}

    # Load all locales.  This is invoked automatically upon loading Hduration.
    def Localizations.load_all
      locales = []
      constants.each do |constant|
        mod = const_get(constant)
        next unless mod.kind_of?(Module) and mod.const_defined?('LOCALE')

        locale    = mod.const_get('LOCALE').to_sym  # Locale name
        plurals   = mod.const_get('PLURALS')        # Unit plurals
        singulars = mod.const_get('SINGULARS')      # Unit singulars

        if mod.const_defined? 'FORMAT'
          format = mod.const_get 'FORMAT'
          format = format.kind_of?(Proc) ? format : proc { |duration| duration.format(format.to_s) }
        end

        # Add valid locale to the collection.
        @@locales[locale] = Locale.new(locale, plurals, singulars, format)
      end
    end

    # Collection of locales
    def Localizations.locales
      @@locales
    end
  end

  class LocaleError < StandardError
  end
end
