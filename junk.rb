scenario "Sign In without email" do
  User.create!(
    first_name: "James",
    last_name: "Lacy",
    email: "jim@email.com",
    password: "123",
    password_confirmation: "123"
  )
  visit root_path
  click_on "Sign In"
  fill_in "Password", with: "123"
  click_on "Sign In"
  expect(page).to have_content("Username / password combination is invalid")
  expect(page).to have_content("Sign In")
end

scenario "Sign in without password" do
  User.create!(
    first_name: "James",
    last_name: "Lacy",
    email: "jim@email.com",
    password: "123",
    password_confirmation: "123"
  )
  visit root_path
  click_on "Sign In"
  fill_in "Email", with: "jim@email.com"
  click_on "Sign In"
  expect(page).to have_content("Password can't be blank")
  expect(page).to have_content("Sign In")
  expect(page).to have_no_content("Sign Out")
end

scenario "Sign In with different password & password confirmation" do
  User.create!(
    first_name: "James",
    last_name: "Lacy",
    email: "jim@email.com",
    password: "123",
    password_confirmation: "123"
  )
  visit root_path
  click_on "Sign In"
  fill_in "Email", with: "jim@email.com"
  fill_in "Password", with: "123"
  click_on "Sign In"
  expect(page).to have_content("Password confirmation doesn't match Password")
  expect(page).to have_content("Sign In")
  expect(page).to have_no_content("Sign Out")
end

scenario "Sign in & out" do
  User.create!(
    first_name: "James",
    last_name: "Lacy",
    email: "jim@email.com",
    password: "123",
    password_confirmation: "123"
  )
  visit root_path
  click_on "Sign In"
  fill_in "Email", with: "jim@email.com"
  fill_in "Password", with: "123"
  click_on "Sign In"
  expect(page).to have_content("James Lacy")
  expect(page).to have_no_content("Sign Up")

  click_on "Sign Out"
  expect(page).to have_no_content("James Lacy")
  expect(page).to have_content("Sign In")
end



<col style=width:70%>

<%= link_to 'Create Task', new_task_path, class: "btn btn-info btn-primary pull-right" %>

<%= render 'form', button_name: "Update Task" %>




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
