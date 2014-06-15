$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'active_record'
require 'acts_as_digested_on'

I18n.enforce_available_locales = true

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3', :database => ':memory:')

class ActiveRecord::Base
  def self.define_table(table_name = self.name.tableize, &migration)
    ActiveRecord::Schema.define(:version => 1) do
      create_table(table_name, &migration)
    end
  end
end
