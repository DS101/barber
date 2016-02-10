#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
# require 'pony'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
  erb :about
end

get '/visit' do
  erb :visit  
end

get '/contacts' do
  erb :contacts
end

post '/visit' do
  @name = params[:user_name]
  @phone = params[:phone]
  @date_time = params[:date_time]
  @barber = params[:barber]
  @color = params[:color]

  hh = { user_name: "enter name",
         phone: "enter phone",         
         date_time: "enter date and time" }
         
  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")

  if @error != ''
    return erb :visit
  end
  
  f = File.open("./public/test.txt", "a")
  f.write "Name: #{@name}, Phone: #{@phone}, Date and time: #{@date_time}, Your barber: #{@barber} and you color #{@color}\n"
  f.close
  erb "Спасибо за то что Вы с нами"
end

post '/contacts' do
  require 'pony'
  @email = params[:email]
  @message = params[:message]

  Pony.mail(
    :to => 'dimauvin@gmail.com',
    :from => "#{@email}",
    :subject => "art inquiry from #{@email}",
    :body => "#{@message}",
    :via => :smtp,
    :via_options => { 
      :address              => 'smtp.gmail.com', 
      :port                 => '587', 
      :enable_starttls_auto => true, 
      :user_name            => 'dimauvin@gmail.com', 
      :password             => 'qud24s85may', 
      :authentication       => :plain, 
      :domain               => 'localhost.localdomain'
  })

   
  # f = File.open("./public/contacts.txt", "a")
  # f.write "Email: #{@email}\n Сообщение:\n #{@message}\n"
  # f.write "-----------------------------------\n"
  # f.close
  erb "Сообщение отправлено"
end