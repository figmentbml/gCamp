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

  def faq
      faq1 = Faq.new
      faq1.question = "What is gCamp?"
      faq1.answer = "gCamp is an awesome tool that will change your life."

      faq2 = Faq.new
      faq2.question = "How do I join gCamp?"
      faq2.answer = "Right now gCamp is still in production, so you can't join."

      faq3 = Faq.new
      faq3.question = "When will gCamp be finished?"
      faq3.answer = "gCamp is a work in progress, but should be fully functional by Decemeber 2014.  Functional, but our developers are going to continue to improve the site for the foreseeable future."

      @faqs = [faq1, faq2, faq3]
      
    end

end
