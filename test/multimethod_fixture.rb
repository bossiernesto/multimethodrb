class Persona
  attr_accessor :nombre, :apellido

  def initialize
    self.nombre = 'Johann Sebastian'
    self.apellido = 'Mastropiero' #Casi Bach
  end

end

class MegaStringUtils
  multimethod :concat do
    define_for [String, String] do |s1, s2|
      s1 + s2
    end

    define_for [String, Fixnum] do |s, n|
      s * n
    end
  end
end

class SuperMegaStringUtils < MegaStringUtils
  multimethod :concat do
    define_for [String, String] do |s1, s2|
      s2 + s1
    end
    define_for [String, Array] do |s, a|
      a.join s
    end
  end
end


class StringUtils

  self_multimethod :concat do

    define_for [String, String] do |s1, s2|
      s1 + s2
    end

    define_for [String, Fixnum] do |s, n|
      s * n
    end

  end

  multimethod :concat do

    define_for [String, duck(:nombre, :apellido)] do |s, p|
      "#{s} #{p.nombre} #{p.apellido}!"
    end

    define_for [String, String] do |s1, s2|
      s1 + s2
    end

    define_for [String, -1] do |n, s|
      n.reverse
    end

    define_for [String, proc { |o| o.odd? or o==42 }] do |s, n|
      true
    end

    define_for [String, Fixnum] do |s, n|
      s * n
    end

    define_for [Array] do |a|
      a.join
    end

    define_for [nil] do |o|
      nil
    end

  end

end