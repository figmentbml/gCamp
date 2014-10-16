def faq
    faq1 = Faq.new
    faq1.question = <%= link_to "What-is-gCamp?">, #what-is-gcamp_path %>
    faq1.answer = "gCamp is an awesome tool that will change your life."
    faq1.link = <a name="what-is-gcamp"></a>

    faq2 = Faq.new
    faq2.question = "How do I join gCamp?"
    faq2.answer = "Right now gCamp is still in production, so you can't join."

    faq3 = Faq.new
    faq3.question = "When will gCamp be finished?"
    faq3.answer = "gCamp is a work in progress, but should be fully functional by Decemeber 2014.  Functional, but our developers are going to continue to improve the site for the foreseeable future."

    faq4 = Faq.new
    faq4.question = "I'm scared, is it going to be too hard?"
    faq4.answer = "This is a funny question that we get a lot.  It's not going to be hard.  You life will be different.  That's right gCamp will change your life because everything will be in one place!"

    faq5 = Faq.new
    faq5.question = "What are the alternatives?"
    faq5.answer = "The alternatives are simple. You can live your life in an unorganized mess or you can check out gCamp and organize those documents, tasks, and comments."

    @faqs = [faq1, faq2, faq3, faq4, faq5]

  end


<ul>
<% @faqs.each do |faq| %>
      <li>
      <a name= "faq.question">
        <strong><%= faq.question %></strong>
      </a>
      </li>
      <br/>
  <% end %>
</ul>
<br/>
<br/>

<% @faqs.each do |faq| %>
    <strong><a href= "#faq.question"><%= faq.question %></strong></a></p>
    <footer><%= faq.answer %></footer>
    <br/>
  <% end %>


in models/faq
def initialize(question, answer)
  @question = question
  @answer = answer
end

faq = Faq.new("","")

p faq


  car = Car.new("Chevy", "Tracker", 1978)

  p car
