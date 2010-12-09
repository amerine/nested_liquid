require 'spec_helper'


class BaseObject
  def to_liquid
    self.instance_variables
  end
end

class Person < BaseObject
  attr_accessor :name, :age
  attr_accessor :address
  attr_accessor :friend

  def initialize(name="John", age=21)
    @name = name
    @age = age
    @friend = Friend.new
    @address = Address.new
  end
 
  liquid_methods :name, :age, :friend, :address

  def start_nested
    "{{person.address.one}}"
  end
end

class Friend < BaseObject
  def cant_touch_this
    "nah nah nah na"
  end
end

class Address < BaseObject
  attr_accessor :street, :zip

  def initialize(street="123 St.", zip="97701") 
    @street = street
    @zip = zip
  end

  def combined
    @street +" "+ @zip
  end

  def street_and_age
    "{{person.address.street}} {{person.age}}"
  end

  def one
    "{{person.address.two}}"
  end

  def two
    "{{person.address.three}}"
  end

  def three
    "{{person.address.four}}"
  end
  
  def four
    "four"
  end

  liquid_methods :one, :two, :three, :four
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

  it "renders recusive liquid templates" do
    template = Liquid::Template.parse("{{person.name}} {{person.address.street_and_age}}")
    result = template.render('person' => @person)
    result.should.eql "John 123 St. 21"
  end


  it "renders really nested liquid statements" do
    template = Liquid::Template.parse("{{person.address.one}}")
    result = template.render('person' => @person)
    result.should.eql "four"
  end

end
