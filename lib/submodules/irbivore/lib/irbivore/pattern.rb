module Irbivore::Patterns
  def harmony(x,y, constrain=true)
    value = x * 5 + y * 4
    value %= 12 if constrain
  end
end
