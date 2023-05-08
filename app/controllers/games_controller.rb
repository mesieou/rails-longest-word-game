require 'open-uri'
class GamesController < ApplicationController
  @url = 'https://wagon-dictionary.herokuapp.com/'

  def new
    letters = ('A'..'Z').to_a
    @random_letters = Array.new(10) { letters.sample }
  end

  def word_in_the_grid?
    @splitted_words = params[:word].upcase.chars
    @random_letters = params[:random_letters].split
    @all_letters_exist = @splitted_words.all? do |letter|
      @random_letters.include?(letter) &&
        @random_letters.count(letter) >= @splitted_words.count(letter)
    end
  end

  def word_exist?
    user_serialised = URI.open("https://wagon-dictionary.herokuapp.com/#{params[:word]}").read
    word = JSON.parse(user_serialised)
    @found = word['found']
  end

  def score
    word_exist?
    if word_in_the_grid? && @found
      @result = "Congratulations! #{params[:word]} is a valid english word"
    elsif word_in_the_grid? == false
      @result = "Sorry but the test cannot be built out of #{params[:random_letters]}"
    elsif @found == false
      @result = "Sorry, #{params[:word]} does not seem to be a valid english word"
    end
  end
end
