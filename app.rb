#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
require 'sqlite3'

configure do
  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'create table if not exists
    "Users"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "name" TEXT,
      "phone" TEXT,
      "date_stamp" TEXT,
      "barber" TEXT,
      "color" TEXT
    )'
end

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
  
  db = SQLite3::Database.new 'barbershop.db'
  db.execute 'insert into Users (name, phone, date_stamp, barber, color) 
  values(?, ?, ?, ?, ?)', [@name, @phone, @date_time, @barber, @color]
  erb "сэнк ю вэри мач"
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

  erb "Сообщение отправлено"
end

get '/showusers' do
  db = SQLite3::Database.new 'barbershop.db'
  db.results_as_hash = true
  x = []
  db.execute 'select * from Users' do |row|
    x << row[1]
  end
  erb "#{x.to_s}"
end