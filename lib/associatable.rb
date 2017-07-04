require 'active_support/inflector'
require_relative 'searchable'

class AssocOptions
  attr_accessor :primary_key, :foreign_key, :class_name

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end


class BelongsToOptions < AssocOptions
  def initialize(table_name, options = {})
    @class_name = options[:class_name] || table_name.to_s.singularize.camelcase
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] || "#{table_name.to_s.singularize.downcase}_id".to_sym
  end
end

class HasManyOptions < AssocOptions
  def initialize(table_name, owning_table_name, options = {})
    @class_name = options[:class_name] || table_name.to_s.singularize.camelcase
    @primary_key = options[:primary_key] || :id
    @foreign_key = options[:foreign_key] || "#{owning_table_name.to_s.singularize.downcase}_id".to_sym
  end
end

module Associatable
  def belongs_to(association, options = {})
    options = BelongsToOptions.new(association, options)

    define_method(association) do
      key_val = self.send(options.foreign_key)
      association.to_s.camelcase.constantize.where(options.primary_key => key_val).first
    end
  end

  def has_many(association, options = {})
    options = HasManyOptions.new(association, self.table_name, options)

    define_method(association) do
      key_val = self.send(options.primary_key)
      association.to_s.singularize.camelcase.constantize.where(options.primary_key => key_val)
    end
  end
end

class SQLObject
  extend Associatable
end
