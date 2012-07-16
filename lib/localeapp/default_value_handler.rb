module I18n::Backend::Base
  alias_method :default_without_handler, :default

  def default(locale, object, subject, options = {})
    result = default_without_handler(locale, object, subject, options)
    return result if ::Localeapp.configuration.sending_disabled?

    if result
      sender = Localeapp::Sender.new

      # Make the default value a complete translation
      sender.post_translation(locale, object || @last_object, options, result)
    end

    @last_object = options[:fallback] ? object : nil
    return result
  end
end
