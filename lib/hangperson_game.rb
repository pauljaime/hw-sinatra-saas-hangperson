class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end

  
  #-----------------------------------------------------------------------------
  #Constructor
  def initialize(word)
    @word = word.downcase 
    @guesses = ''
    @wrong_guesses = ''
    @total_wrong = 0
    @gameStatus = :play

    @lstLetters = Hash.new
    @guessedword = Array.new(@word.length){ |i| '-' } 
    
    letters = word.chars
    letters.each { |l|
      if @lstLetters.has_key?(l)
        cnt = @lstLetters[l]
        @lstLetters[l] = cnt + 1
      else
        @lstLetters[l] =  1
      end

    }    
  end

  #-----------------------------------------------------------------------------
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  #-----------------------------------------------------------------------------
  def guess(letter)
    rv = true
    # Raise exception of the parameter is not a letter, null, or blank
    if letter == '' || letter == nil  || /[A-Za-z]/.match(letter) == nil
      raise ArgumentError, "Letter cannot be blank, nil, or a non-letter"
    end
    
    # check if character sent in is in upper case, if so, ignore
    if /[[:upper:]]/.match(letter) == nil
      #check if the letter sent in exists in the words to guess, if not, it is a wrong choice
      if /#{letter}/.match(@word) != nil
        #in the case that we have a word with multible of the same letter. begin
        # counting down (this may not be needed)
        if @lstLetters.has_key?(letter)
          cnt = @lstLetters[letter]
          if cnt != 0
            cnt = cnt - 1
            @lstLetters[letter] = cnt
            @guesses = @guesses + letter

            locations = @word.enum_for(:scan,/#{letter}/).map{Regexp.last_match.begin(0)}
            locations.each{ |i|
              @guessedword[i] = letter
            }
            if @guessedword.index('-') == nil
              @gameStatus = :win
            end
            
          else
            rv = false
          end
        end
      else
        if /#{letter}/.match(@wrong_guesses) == nil
          @wrong_guesses = @wrong_guesses + letter
          @total_wrong +=1
          if @total_wrong == 7
            @gameStatus = :lose
          end
        else
          rv = false
        end
      end
    else
      rv = false
    end
    return rv
  end
  
  #-----------------------------------------------------------------------------
  def word_with_guesses
    return @guessedword.join
  end

  #-----------------------------------------------------------------------------
  # Getter and Setter methods
  def word
    @word
  end
  def word= (value)
    @word = value
  end
  
  def guesses
      @guesses
  end
  
  def guesses= (value)
      @guesses = value
  end
  def wrong_guesses
    @wrong_guesses
  end

  def wrong_guesses= (value)
    @wrong_guesses = value
  end

  #-----------------------------------------------------------------------------
  def check_win_or_lose
    return @gameStatus
  end
  
end
