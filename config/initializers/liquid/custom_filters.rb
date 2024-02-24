module Liquid
  module CustomFilters
    def cast(input, type)
      case type
      when "string"
        input.to_s
      when "number"
        begin
          Float(input)
        rescue ArgumentError
          0 # Default to 0 if conversion fails
        end
      when "boolean"
        !!input
      else
        input # Return the input as is if type is not recognized
      end
    end

    def includes(input, substring)
      input.include?(substring)
    end

    def regex_replace(input, pattern, replacement = '', flags = '')
      options = 0
      options |= Regexp::IGNORECASE if flags.include?('i')
      options |= Regexp::MULTILINE if flags.include?('m')
      options |= Regexp::EXTENDED if flags.include?('x')
      options |= Regexp::FIXEDENCODING if flags.include?('n') || flags.include?('e') || flags.include?('s') || flags.include?('u')
  
      # Ruby does not directly support 'o' flag in Regexp.new; its behavior is implicit in how Ruby caches regex.
      # For encoding, we'll use a more general approach without directly mapping 'n', 'e', 's', 'u' to specific encodings,
      # as Ruby's Regexp doesn't support these flags directly like this. The example demonstrates handling common flags.
      
      re = Regexp.new(pattern, options)
      input.gsub(re, replacement)
    end

    def regex_test(input, pattern, replacement = '', flags = '')
      options = 0
      options |= Regexp::IGNORECASE if flags.include?('i')
      options |= Regexp::MULTILINE if flags.include?('m')
      options |= Regexp::EXTENDED if flags.include?('x')
      options |= Regexp::FIXEDENCODING if flags.include?('n') || flags.include?('e') || flags.include?('s') || flags.include?('u')
  
      # Ruby does not directly support 'o' flag in Regexp.new; its behavior is implicit in how Ruby caches regex.
      # For encoding, we'll use a more general approach without directly mapping 'n', 'e', 's', 'u' to specific encodings,
      # as Ruby's Regexp doesn't support these flags directly like this. The example demonstrates handling common flags.
      
      re = Regexp.new(pattern, options)
      re.match?(input)
    end
  end
end