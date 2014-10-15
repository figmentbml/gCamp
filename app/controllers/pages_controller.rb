class PagesController < ApplicationController

  def index
    @quotes = [
      ["Failure is not an option. Everyone has to succeed", "Arnold"],
      ["Your time is limited, so don't waste it living someone else's life.", "Steve Jobs"],
      ["The present is surrendered to the past and the future.", "Walker Percy"]
        ]
  end

end
