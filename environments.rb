require 'active_record'
require 'active_record_tasks'
require 'sinatra'

# ActiveRecordTasks.configure do
#   db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/TreeOfLife_development')

#   ActiveRecord::Base.establish_connection(
#     :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
#     :host     => db.host,
#     :username => db.user,
#     :password => db.password,
#     :database => db.path[1..-1],
#     :encoding => 'utf8'
#   )
# end

configure :production do
  # db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/TreeOfLife_development')

  ActiveRecord::Base.establish_connection(
      :adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
  )
end
