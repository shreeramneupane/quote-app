class QuotesController < ApplicationController
  def random
    @quote = Quote.select(:author, :title).take
  end
end
