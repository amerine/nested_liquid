require 'spec_helper'

class Person
attr_accessor :name, :age
attr_accessor :address
attr_accessor :friend

  def initialize(name="John", age=21)
    @name = name
    @age = age
    @friend = Friend.new
    @address = Address.new
  end

  def to_liquid
    @name
  end
end

class Friend
  def cant_touch_this
    "nah nah nah na"
  end
end

class Address
  attr_accessor :street, :zip

  def initialize(street="123 St.", zip="97701") 
    @street = street
    @zip = zip
  end

  def combined
    @street +" "+ @zip
  end
end

describe "NestedLiquid" do
  before do
    Liquid.allowed_namespaces = "address"
    @person = Person.new
    @template = Liquid::Template.parse("{{person.address.combined}} is far away")

  end

  it "Sanity check for fake objects" do
    @person.address.combined.should.eql "123 St. 97701"
  end

  it "can render nested methods in the allowed namespace" do
    result = @template.render('person' => @person)
    result.should.eql "123 St. 97701 is far away"
  end

  it "shouldn't be able to call methods that are not allowed" do
    template = Liquid::Template.parse("{{person.friend.cant_touch_this}}")
    result = template.render('person' => @person)
    result.should.eql ""
  end
end
