require 'digest/sha1'

module ActsAsDigestedOn
  def self.included(model)
    model.extend ClassMethods
  end

  module Validations
    def self.included(model)
      model.class_eval do
        options = acts_as_digested_on_vars[:validates_uniqueness_of_options]
        validates_uniqueness_of acts_as_digested_on_vars[:digest_column], options
      end
    end
  end

  module Callbacks
    def self.included(model)
      model.class_eval do
        before_validation :set_digest
      end
    end
  end

  module InstanceMethods
    def generate_digest
      original_columns = self.class.acts_as_digested_on_vars[:original_columns]
      original_string = "--#{ original_columns.map { |v| self[v].to_s }.join('--') }--"
      Digest::SHA1.hexdigest original_string
    end

    private
    def set_digest
      digest_column = self.class.acts_as_digested_on_vars[:digest_column]
      self[digest_column] = generate_digest
    end
  end

  module ClassMethods
    def acts_as_digested_on(original_columns, options = {})
      options = options.symbolize_keys

      original_columns = Array(original_columns).flatten
      digest_column = options.delete(:digest_column) || 'digest'
      unique = options.key?(:unique) ? options.delete(:unique) : true

      class_inheritable_hash :acts_as_digested_on_vars
      self.acts_as_digested_on_vars = {
        :original_columns => original_columns,
        :digest_column => digest_column,
        :unique => unique,
        :validates_uniqueness_of_options => options
      }

      include InstanceMethods
      include Callbacks
      include Validations if self.acts_as_digested_on_vars[:unique]
    end
  end
end

ActiveRecord::Base.send :include, ActsAsDigestedOn
