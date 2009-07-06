require 'rubygems'
require 'spec'
require 'active_record'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'acts_as_digested_on'

Spec::Runner.configure do |config|
  
end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

class ActiveRecord::Base
  def self.define_table(table_name = self.name.tableize, &migration)
    ActiveRecord::Schema.define(:version => 1) do
      create_table(table_name, &migration)
    end
  end
end
