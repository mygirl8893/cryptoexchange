require 'spec_helper'

RSpec.describe 'Nanu.Exchange integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:brl_btc_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BRL', target: 'BTC', market: 'nanu_exchange') }

  it 'fetch pairs' do
    pairs = client.pairs('nanu_exchange')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'nanu_exchange'
  end

  it 'fetch ticker' do
    ticker = client.ticker(brl_btc_pair)

    expect(ticker.base).to eq 'BRL'
    expect(ticker.target).to eq 'BTC'
    expect(ticker.market).to eq 'nanu_exchange'
    expect(ticker.last).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.change).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil
    expect(ticker.payload).to_not be nil
  end

  it 'fetch order book' do
    order_book = client.order_book(brl_btc_pair)

    expect(order_book.base).to eq 'BRL'
    expect(order_book.target).to eq 'BTC'
    expect(order_book.market).to eq 'nanu_exchange'
    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.asks.count).to be > 1
    expect(order_book.bids.count).to be > 1
    expect(order_book.timestamp).to be_a Numeric
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trade' do
    trades = client.trades(brl_btc_pair)
    trade = trades.sample

    expect(trades).to_not be_empty
    expect(trade.base).to eq 'BRL'
    expect(trade.target).to eq 'BTC'
    expect(trade.market).to eq 'nanu_exchange'
    expect(trade.trade_id).to_not be_nil
    expect(['buy', 'sell']).to include trade.type
    expect(trade.price).to_not be_nil
    expect(trade.amount).to_not be_nil
    expect(trade.timestamp).to be_a Numeric
    expect(trade.payload).to_not be nil
  end
end
