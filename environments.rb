require 'active_record'
require 'active_record_tasks'
require 'sinatra'

configure :production do
  if ENV['DATABASE_URL']
    ActiveRecord::Base.establish_connection(
      :url => ENV['DATABASE_URL']
    )
  else
    db = URI.parse('postgres://localhost/TreeOfLife_development')

    ActiveRecord::Base.establish_connection(
      :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
    )
  end
end
