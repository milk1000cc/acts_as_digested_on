require "acts_as_digested_on/version"
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
      digest = Digest::SHA1.hexdigest(original_string_for_digest)
      digest.encode! 'utf-8' if RUBY_VERSION.to_f >= 1.9
      digest
    end

    private
    def original_string_for_digest
      separator = '--'
      attr_names = self.class.acts_as_digested_on_vars[:attr_names]

      str = separator.dup
      str << attr_names.map { |v| send(v).to_s }.join(separator)
      str << separator
      str
    end

    def set_digest
      digest_column = self.class.acts_as_digested_on_vars[:digest_column]
      self[digest_column] = generate_digest
    end
  end

  module ClassMethods
    def acts_as_digested_on(attr_names, options = {})
      options = options.symbolize_keys

      attr_names = Array(attr_names).flatten
      digest_column = options.delete(:digest_column) || 'digest'
      unique = options.key?(:unique) ? options.delete(:unique) : true

      class_attribute :acts_as_digested_on_vars
      self.acts_as_digested_on_vars = {
        :attr_names => attr_names,
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
