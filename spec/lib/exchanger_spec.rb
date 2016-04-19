require 'spec_helper'

describe Exchanger do
  let(:exchngr) do
    Exchanger.new(1 => 0, 2 => 0, 5 => 0, 10 => 0, 25 => 0, 50 => 0)
  end
  let(:exchngr_not_empty) do
    Exchanger.new(1 => 10, 2 => 10, 5 => 10, 10 => 10, 25 => 10, 50 => 10)
  end

  let(:exchngr_1_5_10) do
    Exchanger.new(1 => 1, 2 => 0, 5 => 1, 10 => 1, 25 => 0, 50 => 0)
  end

  describe '.add' do
    it 'change nothing from empty hash argument' do
      additional = {}
      expected = exchngr.coins
      exchngr.add(additional)
      expect(exchngr.coins).to eq(expected)
    end

    it 'change nothing from hash argument with wrong keys' do
      additional = { asd: 24, 12 => 4 }
      expected = exchngr.coins
      exchngr.add(additional)
      expect(exchngr.coins).to eq(expected)
    end

    it 'properly adds coins' do
      additional = { 1 => 2, 2 => 3, 5 => 5 }
      expected = exchngr.coins.each_with_object({}) do |(k, v), h|
        h[k] = v + additional[k].to_i
      end
      exchngr.add(additional)
      expect(exchngr.coins).to eq(expected)
    end

    it 'properly adds coins several times' do
      additional = { 1 => 2, 2 => 3, 5 => 5 }
      additional2 = { 25 => 2, 50 => 1, 2 => 5 }
      expected = exchngr.coins.each_with_object({}) do |(k, v), h|
        h[k] = v + additional[k].to_i + additional2[k].to_i
      end
      exchngr.add(additional)
      exchngr.add(additional2)
      expect(exchngr.coins).to eq(expected)
    end

    it "doesn't add coins not known by Exchanger" do
      additional = { 3 => 2, 12 => 3, 24 => 5 }
      expected = exchngr.coins
      exchngr.add(additional)
      expect(exchngr.coins).to eq(expected)
    end
  end

  describe '.substract' do
    it 'change nothing from empty hash argument' do
      additional = {}
      expected = exchngr_not_empty.coins
      exchngr_not_empty.substract(additional)
      expect(exchngr_not_empty.coins).to eq(expected)
    end

    it 'change nothing from hash argument with wrong keys' do
      additional = { asd: 24, 12 => 4 }
      expected = exchngr_not_empty.coins
      exchngr_not_empty.substract(additional)
      expect(exchngr_not_empty.coins).to eq(expected)
    end

    it 'substracts coins only down to zero' do
      additional = { 1 => 2, 2 => 3, 5 => 5 }
      expected = exchngr.coins
      exchngr.substract(additional)
      expect(exchngr.coins).to eq(expected)
    end

    it 'properly substracts coins multiple times' do
      additional = { 1 => 2, 2 => 3, 5 => 5 }
      additional2 = { 25 => 2, 50 => 1, 2 => 5 }
      expected = exchngr_not_empty.coins.each_with_object({}) do |(k, v), h|
        res = v - additional[k].to_i - additional2[k].to_i
        h[k] = res < 0 ? 0 : res
      end
      exchngr_not_empty.substract(additional)
      exchngr_not_empty.substract(additional2)
      expect(exchngr_not_empty.coins).to eq(expected)
    end

    it 'properly substracts coins' do
      additional = { 1 => 2, 2 => 3, 5 => 5 }
      expected = exchngr_not_empty.coins.each_with_object({}) do |(k, v), h|
        res = v - additional[k].to_i
        h[k] = res < 0 ? 0 : res
      end
      exchngr_not_empty.substract(additional)
      expect(exchngr_not_empty.coins).to eq(expected)
    end
  end

  describe '.coins' do
    it 'returns copy of interanl state' do
      coins = exchngr.coins
      coins[:test] = 'test'
      expect(exchngr.coins).not_to eq(coins)
    end
  end

  describe '.exchange' do
    it 'returns hash of change' do
      coins = exchngr_not_empty.exchange(76)
      expect(coins).to be_a(Hash)
    end

    it 'returns hash of change with proper sum' do
      amount = Random.rand(100)
      coins = exchngr_not_empty.exchange(amount)
      expect(coins.reduce(0) { |s, (k, v)| s + v * k }).to eq(amount)
    end

    it 'returns empty hash for zero' do
      coins = exchngr_not_empty.exchange(0)
      expect(coins).to eq({})
    end

    it "raise exception when coins don't sum up properly" do
      expect { exchngr_1_5_10.exchange(12) }.to raise_error(ExchangeError)
    end

    it 'raise exception when not able to provide change' do
      expect { exchngr_not_empty.exchange(100_007_6) }.to raise_error(ExchangeError)
      expect { exchngr_not_empty.exchange(-1) }.to raise_error(ExchangeError)
    end
  end
end
