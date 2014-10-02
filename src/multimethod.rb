class Module
  def multimethod(sym, &block)
    dispatcher = MultimethodDispatcher.new sym, &block
    self.define_multimethod_instance sym, dispatcher
  end

  def self_multimethod(sym, &block)
    dispatcher = MultimethodDispatcher.new sym, &block
    self.define_multimethod_class sym, dispatcher
  end

  def define_multimethod_instance(sym, dispatcher)
    self.define_multimethod sym, dispatcher, :define_method
  end

  def define_multimethod_class(sym, dispatcher)
    self.define_multimethod sym, dispatcher, :define_singleton_method
  end

  def define_multimethod(sym, dispatcher, method)
    dispatcher_instance = dispatcher
    self.send method, (sym) do |*args|
      begin
        dispatcher_instance.evaluate_input *args
      rescue MultiMethodNoMethodException
        super *args
      end
    end
  end
end


class MultimethodDispatcher

  attr_accessor :method_name, :methods

  def initialize(sym, &block)
    self.methods = []
    self.method_name = sym
    self.instance_eval &block
  end

  def define_for(array, &block)
    self.methods << (MultimethodMethod.new array, &block)
  end

  def evaluate_input(*args)
    self.methods.each do |method|
      if method.matches args
        return method.execute args
      end
    end
    raise MultiMethodNoMethodException, "No se encontro bloque de método que coincida con los argumentos #{args}"
  end

  def duck(*symbols)
    ArgDuck.new symbols
  end

end

class MultimethodMethod

  attr_accessor :block, :matchers, :matcher_types


  def initialize(arg_array, &block)
    self.block = block
    self.matchers = []
    self.matcher_types = {ArgDuck => Proc.new { |value| value },
                          Class => Proc.new { |value| ArgType.new value },
                          Proc => Proc.new { |value| ArgProc.new value },
                          Object => Proc.new { |value| ArgValue.new value }}
    arg_array.each do |arg|
      self.process_argument arg
    end
  end

  def process_argument value
    if value.nil?
      self.matchers << ArgNil.new(nil)
      return
    end
    self.matcher_types.keys.each do |type|
      if value.is_a? type
        self.matchers << self.matcher_types[type].call(value)
        return
      end
    end
  end

  def matches(arguments)
    unless arguments.length == self.matchers.length
      return false
    end

    ms = self.matchers.zip(arguments)
    ms.all? { |matcher| matcher[0].matches matcher[1] }
  end

  def execute(*args)
    self.block.call args[0]
  end

end

class MultimethodArg
  attr_accessor :value

  def initialize(value)
    self.value = value
  end

end

class ArgValue < MultimethodArg
  def matches(value_compare)
    value_compare == self.value
  end
end

class ArgType < MultimethodArg
  def matches(value_compare)
    value_compare.class == value
  end
end

class ArgNil < MultimethodArg
  def matches(value_compare)
    value_compare.nil?
  end
end

class ArgDuck < MultimethodArg
  def matches(object)
    self.value.any? { |sym|
      begin
        object.respond_to? sym
      rescue NoMethodError
        false
      end }
  end
end

class ArgProc < MultimethodArg
  def matches(value_compare)
    value.call value_compare
  end
end

class MultiMethodNoMethodException < StandardError
end