require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(9)
  end

  def score
    session[:score] = 0
    @word = params[:word]
    @letters = params[:letters].split("")
    @score = 0

    if @word.present?
      url = "https://wagon-dictionary.herokuapp.com/#{@word}"
      valid_word = URI.open(url).read
      @valid_word = JSON.parse(valid_word)

      if @valid_word
        @word.chars.each do |letter|
          if @letters.include?(letter)
            @score += 1
            # @letters.delete_at(@letters.index(letter) || @letters.length)
          else
            @score = 0
          end
        end
      else
        @score = 0
      end
    else
      @score = 0
    end
    # TODO
    # Check if the word is a valid english word, otherwise score = 0
    # Check if the word is in the grid, otherwise score = 0
      # Make it work with double letters later
    # Get extra points for each letter in the answer
    # Lose points as you take more time

    if session[:current_score]
      session[:current_score] += @score
    else
      session[:current_score] = @score
    end
    @score = session[:current_score]
  end
end
