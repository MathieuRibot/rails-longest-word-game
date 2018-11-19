require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << [*('A'..'Z')].sample }
    @start_time = Time.now
  end

  def score
    end_time = Time.now
    time = end_time - params[:start_time].to_time
    @attempt = params[:attempt].upcase
    grid = params[:grid].split(' ')
    run_game(@attempt, grid, time)
  end

  private

  def english_word?(word)
    parsing_url = "https://wagon-dictionary.herokuapp.com/#{word.downcase}"
    response = open(parsing_url)
    json = JSON.parse(response.read)
    json['found']
  end

  def respect_grid?(attempt, grid)
    attempt.upcase.split('').each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
    end
  end

  def run_game(attempt, grid, time)
    # elapsed_time = end_time - start_time
    if respect_grid?(attempt, grid) == false
      @score = { id: 1, time: time, score: 0 }
    elsif english_word?(attempt) == false || attempt == ''
      @score = { id: 2, time: time, score: 0 }
    else
      score = (1 / time).to_f + attempt.length.to_f
      @score = { id: 3, time: time.round(2), score: score.round(2) }
    end
  end
end
