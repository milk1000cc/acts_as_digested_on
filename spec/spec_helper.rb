require 'logger'
require 'rspec'
require 'active_record'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'acts_as_digested_on'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')

class ActiveRecord::Base
  def self.define_table(table_name = self.name.tableize, &migration)
    ActiveRecord::Schema.define(:version => 1) do
      create_table(table_name, &migration)
    end
  end
end
