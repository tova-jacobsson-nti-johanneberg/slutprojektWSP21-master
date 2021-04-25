
require 'sinatra'
require 'slim'
require 'sqlite3'
require 'bcrypt'

get('/') do
    slim(:index)
end

get('/konto') do
  slim(:konto)
end
 
get('/admin') do
  id = session[:id].to_i
  db = SQLite3::Database.new('databas/databas.db')
  db.results_as_hash = true 
  @result = db.execute("SELECT * FROM paket")
  @result2 = db.execute("SELECT * FROM additions")
  slim(:admin)
end


get('/login') do
    slim(:login)
 end

get('/register') do
    slim(:register)
end



get('/kontakt') do
  slim(:kontakt)
end

get('/about') do
  slim(:about)
end

get('/galleri') do
  slim(:galleri)
end



post('/login') do 
    username = params[:username]
    password = params[:password]
    db = SQLite3::Database.new('databas/databas.db')
    db.results_as_hash = true 
    result = db.execute("SELECT * FROM users WHERE username = ?", username).first
    pwdigest = result["pwdigest"]
    id = result["id"]
  
    if BCrypt::Password.new(pwdigest) == password 
      if username == "admin" 
        session[:id] = id
        redirect('/admin')
      else 
      session[:id] = id
      redirect('/konto')
      end
    else 
      "FEL LÖSEN!"
    end 

  end 
  
  get('/handla') do 
    id = session[:id].to_i
    db = SQLite3::Database.new('databas/databas.db')
    db.results_as_hash = true 
    result = db.execute("SELECT * FROM paket")
    slim(:"/handla",locals:{paket:result})
  end 

  post('/paket') do 
    paketnamn = params[:paketnamn]
    id = session[:id].to_i
    db = SQLite3::Database.new('databas/databas.db')
    db.execute("INSERT INTO paket (paketnamn) VALUES (?)",paketnamn)
    redirect('/admin')
  end 

  post('/additions') do 
    additionnamn = params[:additionnamn]
    id = session[:id].to_i
    db = SQLite3::Database.new('databas/databas.db')
    db.execute("INSERT INTO additions (additionnamn) VALUES (?)",additionnamn)
    redirect('/admin')
  end 

  post('/additions/paket') do 
    additionnamn = params[:additionnamn]
    id = session[:id].to_i
    db = SQLite3::Database.new('databas/databas.db')
    db.execute("INSERT INTO additions (additionnamn) VALUES (?)",additionnamn)
    redirect('/admin')
  end 


  post('/paket/delete') do 
    paketnamn = params[:paketnamn]
    id = session[:id].to_i
    db = SQLite3::Database.new('databas/databas.db')
    db.execute("DELETE paket (paketnamn) VALUES (?)",paketnamn)
    redirect('/admin')
  end 

  post('/paket/edit') do 
    paketnamn = params[:paketnamn]
    id = session[:id].to_i
    db = SQLite3::Database.new('databas/databas.db')
    db.execute("UPDATE paket (paketnamn) VALUES (?)",paketnamn)
    redirect('/admin')
  end 
  
  post('/addition/delete') do 
    additionnamn = params[:additionnamn]
    id = session[:id].to_i
    db = SQLite3::Database.new('databas/databas.db')
    db.execute("DELETE (additionnamn) VALUES (?)",additionnamn)
    redirect('/admin')
  end 

  post('/addition/edit') do 
    additionnamn = params[:additionnamn]
    id = session[:id].to_i
    db = SQLite3::Database.new('databas/databas.db')
    db.execute("UPDATE additions  (additionnamn) VALUES (?)",additionnamn)
    redirect('/admin')
  end 

  post('/users/new') do
    username = params[:username]
    password = params[:password]
    password_confirm = params[:password_confirm]
    if (password == password_confirm)
      password_digest = BCrypt::Password.create(password)
      db = SQLite3::Database.new('databas/databas.db')
      db.execute("INSERT INTO users (username,pwdigest) VALUES (?,?)",username,password_digest)
      redirect('/konto')
      "Tack för att du registrerade dig"
    else 
      "Lösenorden matchade inte"
    end 
  end 

  post('/uppgifter') do 
    id = session[:id].to_i
    username = params[:username]
    namn = params[:namn]
    gata = params[:adress]
    telefon = params[:telefon]
    postnr = params[:postnr]
    ort = params[:ort]
    email = params[:email]
    db = SQLite3::Database.new('databas/databas.db')
    db.execute("INSERT INTO user_info (namn, gata, telefon, postnr, ort, email) WHERE user_id = ",namn, gata, telefon, postnr, ort, email)
 
  end 

