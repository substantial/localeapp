module I18n::Backend::Base
  alias_method :default_without_handler, :default

  def default(locale, object, subject, options = {})
    result = default_without_handler(locale, object, subject, options)
    case subject # case is what i18n gem uses here so doing the same
    when Array
      # Do nothing, we only send missing translations with text defaults
    else
      Localeapp.missing_translations.add(locale, object || @last_object, subject, options)
    end
    @last_object = options[:fallback] ? object : nil
    return result
  end
end
