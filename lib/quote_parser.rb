class QuoteParser
  @@quotations = %w(" ')
  @@separators = %w(- — ~ \()
  @@diff_open_char = '“'
  @@diff_close_char = '”'

  attr_reader :title, :author

  def parse(raw:)
    @raw = raw.strip
    initiate

    use_quotation_mark
    use_differential_mark
    use_separator
    use_everything
    self
  end

  private

  attr_reader :raw, :separator

  def initiate
    @author = ''
    @title = ''
    @is_differential_mark = nil
    @is_separated_by_special = nil
    @q_start_index = nil
    @q_end_index = nil
    @author_section = nil
    @first_char = nil
  end

  ## STRATEGIES

  # title Enclosed within "" or ''
  def use_quotation_mark
    return unless is_first_char_mark

    if even_quotation? && q_end_index
      set_title(extra_chars: [first_char])
      set_author
    end
  end

  # title enclosed within “”
  def use_differential_mark
    return if identified?

    if is_differential_mark && q_end_index
      set_title(extra_chars: [first_char, @@diff_close_char])
      set_author
    end
  end

  # title and author separated by special character
  def use_separator
    return if identified?

    identify_separator
    if is_separated_by_special && q_end_index
      set_title(extra_chars: [separator])
      set_author
    end
  end

  def use_everything
    return if identified?

    @title = @raw
  end

  # SET title & AUTHOR
  def set_title(extra_chars: nil)
    @title = strip_by_chars(@raw[q_start_index..q_end_index], extra_chars: extra_chars).strip
  end

  def set_author
    @author = parsed_author
  end

  # PREDICATE METHOD TO IDENTIFY STRATEGY
  def even_quotation?
    @raw.count(first_char) % 2 == 0
  end

  def is_differential_mark
    @is_differential_mark ||= first_char == @@diff_open_char
  end

  def is_separated_by_special
    @is_separated_by_special ||= @separator.present?
  end

  # UTILITIES TO PLUCK AUTHOR AND title
  def identify_separator
    @@separators.each do |s|
      @separator = s and break unless @raw.index(/#{Regexp.quote(s)}/).nil?
    end
  end

  # PREDICATE METHOD TO KNOW IF title IS IDENTIFIED
  def identified?
    @title.present?
  end

  # UTILITIES TO SET title
  def q_start_index
    @q_start_index ||= 0
  end

  def q_end_index
    @q_end_index ||=
      if even_quotation?
        @raw.rindex(first_char)
      elsif is_differential_mark
        @raw.rindex(@@diff_close_char)
      elsif is_separated_by_special
        @raw.rindex(/#{Regexp.quote(separator)}/)
      end
  end

  # UTILITIES TO SET AUTHOR
  def author_section
    @author_section ||= @raw[q_end_index + 1..@raw.length].strip
  end

  def parsed_author
    _a_first_char = author_section.first
    _a_last_char = author_section.last

    author_section.chop! if author_section.last == '.' && author_section.last(3) != 'Jr.' # remove is unnecessary . present

    return author_section if _a_first_char.index(/\W{1}/).nil?

    extra_chars = [_a_first_char]
    extra_chars.push(')') if _a_first_char.eql? '('

    strip_by_chars(author_section, extra_chars: extra_chars).strip
  end

  # FIRST CHARACTER related operation
  def first_char
    @first_char ||= raw.first
  end

  def is_first_char_mark
    @@quotations.include? first_char
  end

  # UTILITIES

  # Remove characters from string from start and end
  def strip_by_chars(str, extra_chars: [])
    _length = extra_chars.length
    return str if _length.zero?

    reg = _length > 1 ? [Regexp.quote(extra_chars.join(''))] : Regexp.quote(extra_chars.first)
    str.gsub(/^#{reg}*|#{reg}*$/, '')
  end
end
