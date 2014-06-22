require 'active_record'
require 'pry'

module TOL
  class ActiveRecordDatabase
    def initialize
      ActiveRecord::Base.establish_connection(
      :adapter => 'postgresql',
      :database => 'TreeOfLife_test'
      )
    end
  end
end
