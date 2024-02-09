class TagSerchesController < ApplicationController
  def serch 
    @model =Book
    @word= params[:word]
    @books = Book.where("tag LIKE?", "%${@word}%")
    render "searches/result"
  end
end
