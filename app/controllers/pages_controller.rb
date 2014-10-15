class PagesController < ApplicationController

  def index
        quote1 = Quote.new
        quote1.quote = "Failure is not an option. Everyone has to succeed"
        quote1.author = "Arnold"

        quote2 = Quote.new
        quote2.quote = "Your time is limited, so don't waste it living someone else's life."
        quote2.author = "Steve Jobs"

        quote3 = Quote.new
        quote3.quote = "The present is surrendered to the past and the future."
        quote3.author = "Walker Percy"

        @quotes = [quote1, quote2, quote3]

  end


end
