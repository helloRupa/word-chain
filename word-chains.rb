# Build path from one word to another
require 'set'

class WordChainer
  def initialize(filename = './dictionary.txt')
    @dictionary = file_to_set(filename)
  end

  def file_to_set(filename)
    File.foreach(filename).map(&:chomp).to_set
  end

  def adjacent_words(word)
    alphabet = ('a'..'z').to_a
    adjacents = []

    alphabet.each do |char|
      (0...word.length).each do |idx|
        test_word = make_test_word(word, idx, char)
        next if test_word == word
        adjacents << test_word if @dictionary.include?(test_word)
      end
    end
    adjacents
  end

  def make_test_word(word, idx, char)
    test_word = word.dup
    test_word[idx] = char
    test_word
  end

  def run(source, target)
    @current_words = [source]
    @all_seen_words = { source => nil }
    until @all_seen_words.key?(target) || @current_words.empty?
      @current_words = explore_current_words
    end
    path = build_path(target)
    path.length > 1 ? path : 'No path found.'
  end

  def print_words(new_current_words)
    new_current_words.each do |word|
      puts "#{word} from #{@all_seen_words[word]}"
    end
  end

  def explore_current_words
    new_current_words = []

    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        next if @all_seen_words.include?(adjacent_word)
        new_current_words << adjacent_word
        @all_seen_words[adjacent_word] = current_word
      end
    end
    new_current_words
  end

  def build_path(target)
    path = [target]
    source = @all_seen_words[target]
    until source.nil?
      path.unshift(source)
      source = @all_seen_words[source]
    end
    path
  end
end

if $PROGRAM_NAME == __FILE__
  dict = WordChainer.new
  p dict.run('cat', 'cow')
  p dict.run('master', 'market')
  p dict.run('bongo', 'arson')
  p dict.run('carton', 'cartel')
end
