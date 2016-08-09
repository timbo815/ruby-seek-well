require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.columns
    return @columns if @columns

    result = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
       #{self.table_name}
    SQL

    @columns = result.first.map(&:to_sym)
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
   self.class.columns.map { |attr| self.send(attr) }
  end

  def self.finalize!
    self.columns.each do |name|
      define_method(name) do
        self.attributes[name]
      end

      define_method("#{name}=") do |value|
        self.attributes[name] = value
      end
    end
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", value)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{table_name}.*
      FROM
        #{table_name}
    SQL

    parse_all(results)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end
end
