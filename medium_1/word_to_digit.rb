# The pain in this problem would have been greatly lessened had I been aware
#   of the regex \b expression to mark any word boundary.
#
# Any sequence of the digit words converted to a string of digits.
# The first and last word in the sequence could have punctuation adjacent on 
# the left (for the first item) or right (for the second item) side with no
# spaces.
# There could be more than one sequence in the original string.
#
# Data structures:
#   A string for the input
#   A hash that matches digit text to digit numerals
#   An array that contains each word in the original string
#   A second array that identifies whether each word is a (D)igit, (N)on-digit,
#     a digit on the (R)ight side of a sequence, or a digit on the (L)eft side. 
#   The digit only gets an L or R if there is nothing else in the word but 
# .   punctuation.
# Algorithm:
#   Any sequence that looks like LD*R gets converted.
#   A special method must be used to convert L and R. 
#   All L, D, and R words get converted and stored in a new array with all words
#   The words get recombined into a new string.

DIGIT_HASH = { zero: '0', one: '1', two: '2', three: '3', four: '4',
               five: '5', six: '6', seven: '7', eight: '8', nine: '9' }
DIGITS_REGEX = DIGIT_HASH.keys.map { |num| num.to_s }.join('|')

def find_digits(wds)
  digit_type = []
  wds.each_with_index do |w, idx|
    digit_type[idx] = case
                      when (w =~ %r{^(#{DIGITS_REGEX})$}i) then 'D'
                      when (w =~ %r{(#{DIGITS_REGEX})[^a-z0-9\-]+$}i) then 'R'
                      when (w =~ %r{^[^a-z0-9\-]+(#{DIGITS_REGEX})}i) then 'L'
                      else 'N'
                      end
  end
  digit_type
end

def edge_resolve(wd, edge)
  result_str = ''
  digit_str = ''
  wd.chars.each_with_index do |chr, idx|
    chr =~ /[^a-z]/i ? result_str << chr : digit_str << chr 
  end
  case edge
  when 'L' then result_str += DIGIT_HASH[digit_str.to_sym]
  when 'R' then result_str = DIGIT_HASH[digit_str.to_sym] + result_str
  end
  result_str
end

def word_to_digit(input)
  words = input.split
  digit_finder = find_digits(words)
  output = []
  digit_finder.each_with_index do |type, idx|
    output[idx] = case type
                  when 'D' then DIGIT_HASH[words[idx].to_sym]
                  when 'N' then words[idx]
                  when 'L' then edge_resolve(words[idx], 'L') 
                  when 'R' then edge_resolve(words[idx], 'R')
                  end 
  end
  output.join(' ')
end

p word_to_digit('Please call me at five five five one two three four. Thanks.')\
              == 'Please call me at 5 5 5 1 2 3 4. Thanks.'