require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'json'


get '/' do
  erb :home
end

post '/create' do
  sql = "INSERT INTO videos (title, description, url, genre) VALUES ('#{params['title']}', '#{params['description']}', '#{params['url']}', '#{params['genre'].downcase}')"
  run_sql(sql)
  redirect to "/#{params['genre'].downcase}"
end

get '/:genre' do
sql = "SELECT * FROM videos WHERE genre='#{params['genre']}'"
  @rows = run_sql(sql)
  erb :genre
end

post '/:genre/:video_id' do
  sql = "UPDATE videos SET title='#{params['title']}', description='#{params['description']}', url='#{params['url']}' WHERE id = #{params['video_id']}"
  run_sql(sql)
  redirect to "/#{params['genre']}" 
end 

post '/:genre/:video_id/delete' do
  sql = "DELETE FROM videos WHERE id=#{params['video_id']}"
  run_sql(sql)
  puts "/#{params['genre']}"
  redirect to "/#{params['genre']}"
end 

get '/:genre/:id/edit' do
  sql = "SELECT * FROM videos WHERE id = #{params['id']}"
  @row = run_sql(sql).first
  erb :edit
end

# get '/dogs/:id/edit' do
#   sql = "SELECT * FROM dogs WHERE id = #{params['id']}"
#   @row = run_sql(sql).first
#   erb :edit
# end

# post '/dogs/:dog_id' do
#   sql = "UPDATE dogs SET name='#{params['name']}', photo='#{params['photo']}', breed='#{params['breed']}' WHERE id = #{params['dog_id']}"
#   run_sql(sql)
#   redirect to "/dogs" 
# end 

# post '/dogs/:dog_id/delete' do
#   sql = "DELETE FROM dogs WHERE id=#{params['dog_id']}"
#   run_sql(sql)
#   redirect to "/dogs" 
# end 

def run_sql(sql)
  conn = PG.connect(:dbname => "videos", :host => "localhost")
  result = conn.exec(sql)
  conn.close
  result
end