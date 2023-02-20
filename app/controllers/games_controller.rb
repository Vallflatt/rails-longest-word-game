require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    #afficher nouvelle grille aléatoire et un formulaire
    #formulaire envoyé avec POST à score
    alphabet = ("A".."Z").to_a
    @letters = []
    @letters.push(alphabet.sample) while @letters.length < 10
  end

  def score
    #récupérer les inputs du formulaire
    @answer = params[:answer]
    letters = params[:letters].chars()

    @success = true
    @error = ""

    #vérifier que le mot est dans les lettres à dispo
    user_input = @answer.upcase.chars
    user_input.each do |char|
      index = letters.index char
      if index.nil?
        @success = false
        @error = "Sorry but #{@answer} can't be built out of #{params[:letters].chars().join(", ")}"
      else
        letters.delete_at(index)
      end
    end

    #vérifier que le mot existe si il n'y a pas déjà une erreur
    if @success == true
      url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
      result = URI.open(url).read
      if JSON.parse(result)["found"] == false
        @success = false
        @error = "Sorry but #{@answer} does not seem to be a valid English word..."
      end
    end
  end
end
