require 'rspec'
require_relative '../src/multimethod'
require_relative 'multimethod_fixture'

describe 'resolve multimethod' do


  it 'resolve simple multimethod, punto 1' do
    utils = StringUtils.new
    expect(utils.concat('hola', 'mundo')).to eq('holamundo')
  end


  it 'resolve multimethod string,Integer, punto 1' do
    utils = StringUtils.new
    expect(utils.concat('hola', 2)).to eq('holahola')
  end

  it 'resolve multimethod array, punto 1' do
    utils = StringUtils.new
    expect(utils.concat(['hola', ' ', 'mundo'])).to eq('hola mundo')
  end

  it 'resolve dispatch por valores, punto 2' do
    utils = StringUtils.new
    expect(utils.concat(nil)).to eq(nil)
  end

  it 'resolve reverse string, punto 2' do
    utils = StringUtils.new
    expect(utils.concat('hola', -1)).to eq('aloh')
  end

  it 'resolve uneven value, punto 2' do
    utils = StringUtils.new
    expect(utils.concat('hola', 45)).to eq(true)
  end

  it 'resolve johan sebastian mastropero, punto 3' do
    utils = StringUtils.new
    expect(utils.concat('Hola', Persona.new)).to eq('Hola Johann Sebastian Mastropiero!')
  end

  it 'resolve simple multimethod, punto 4' do
    expect(StringUtils.concat('hola', 'mundo')).to eq('holamundo')
  end


  it 'resolve multimethod string,Integer, punto 4' do
    expect(StringUtils.concat('hola', 2)).to eq('holahola')
  end

  #Herencia

  it 'resolve multimethod c/herencia, bonus' do
    super_utils =  SuperMegaStringUtils.new
    expect(super_utils.concat('hola', 'mundo')).to eq('mundohola')
  end

  it 'resolve multimethod c/herencia metodo en superclase solamente, bonus' do
    super_utils =  SuperMegaStringUtils.new
    expect(super_utils.concat('-', 3)).to eq('---')
  end

  it 'resolve multimethod c/herencia metodo en subclase string array, bonus' do
    super_utils =  SuperMegaStringUtils.new
    expect(super_utils.concat('-', ['hola', 'mundo'])).to eq('hola-mundo')
  end

  it 'resolve multimethod c/herencia metodo en superclase, bonus' do
    utils =  MegaStringUtils.new
    expect(utils.concat('hola', 'mundo')).to eq('holamundo')
  end

end