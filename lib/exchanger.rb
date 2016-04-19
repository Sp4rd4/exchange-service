# Exchanger takes initial amount of coins
# and then uses them to exchange some money
class Exchanger
  attr_reader :coins

  def initialize(coins)
    @coins = coins.each_with_object({}) do |(k, v), h|
      h[k] = v < 0 ? 0 : v
    end
  end

  def exchange(amount)
    coins = nominals.each_with_object({}) do |k, h|
      coins = amount / k
      coins = @coins[k] if @coins[k] < coins
      next if coins <= 0
      amount -= coins * k
      h[k] = coins
    end
    raise ExcahngeError, 'Cannot provide change' if amount != 0
    coins ||= {}
    substract(coins)
    coins
  end

  def add(amounts)
    @coins = @coins.each_with_object({}) do |(k, v), h|
      h[k] = v + amounts[k].to_i
    end
  end

  def substract(amounts)
    @coins = @coins.each_with_object({}) do |(k, v), h|
      res = v - amounts[k].to_i
      h[k] = res < 0 ? 0 : res
    end
  end

  def coins
    @coins.clone
  end

  private

  def nominals
    @coins.keys.sort.reverse
  end
end

class ExcahngeError < StandardError
end
