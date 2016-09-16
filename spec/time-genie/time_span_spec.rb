require 'spec_helper'

describe TimeGenie::TimeSpan do

  before do
    @jan = TimeGenie::TimeSpan.new(Date.new(2010, 1, 1), Date.new(2010, 1, 31))
    @feb = TimeGenie::TimeSpan.new(Date.new(2010, 2, 1), Date.new(2010, 2, 28))
    @mar = TimeGenie::TimeSpan.new(Date.new(2010, 3, 1), Date.new(2010, 3, 31))
    @apr = TimeGenie::TimeSpan.new(Date.new(2010, 4, 1), Date.new(2010, 4, 30))
    @may = TimeGenie::TimeSpan.new(Date.new(2010, 5, 1), Date.new(2010, 5, 31))
    @jun = TimeGenie::TimeSpan.new(Date.new(2010, 6, 1), Date.new(2010, 6, 30))
    @jul = TimeGenie::TimeSpan.new(Date.new(2010, 7, 1), Date.new(2010, 7, 31))
    @aug = TimeGenie::TimeSpan.new(Date.new(2010, 8, 1), Date.new(2010, 8, 31))
    @sep = TimeGenie::TimeSpan.new(Date.new(2010, 9, 1), Date.new(2010, 9, 30))
    @oct = TimeGenie::TimeSpan.new(Date.new(2010, 10, 1), Date.new(2010, 10, 31))
    @nov = TimeGenie::TimeSpan.new(Date.new(2010, 11, 1), Date.new(2010, 11, 30))
    @dec = TimeGenie::TimeSpan.new(Date.new(2010, 12, 1), Date.new(2010, 12, 31))
  end

  it 'should report jours calendaires correctly' do
    expect(@jan.calendaires).to eql(31)
    expect(@feb.calendaires).to eql(28)
    expect(@mar.calendaires).to eql(31)
    expect(@apr.calendaires).to eql(30)
    expect(@may.calendaires).to eql(31)
    expect(@jun.calendaires).to eql(30)
    expect(@jul.calendaires).to eql(31)
    expect(@aug.calendaires).to eql(31)
    expect(@sep.calendaires).to eql(30)
    expect(@oct.calendaires).to eql(31)
    expect(@nov.calendaires).to eql(30)
    expect(@dec.calendaires).to eql(31)
  end

  it 'should report jours ouvrables correctly' do
    expect(@jan.ouvrables).to eql(26)
    expect(@feb.ouvrables).to eql(24)
    expect(@mar.ouvrables).to eql(27)
    expect(@apr.ouvrables).to eql(26)
    expect(@may.ouvrables).to eql(26)
    expect(@jun.ouvrables).to eql(26)
    expect(@jul.ouvrables).to eql(27)
    expect(@aug.ouvrables).to eql(26)
    expect(@sep.ouvrables).to eql(26)
    expect(@oct.ouvrables).to eql(26)
    expect(@nov.ouvrables).to eql(26)
    expect(@dec.ouvrables).to eql(27)
  end

  it 'should report jours ouvres correctly' do
    expect(@jan.ouvres).to eql(21)
    expect(@feb.ouvres).to eql(20)
    expect(@mar.ouvres).to eql(23)
    expect(@apr.ouvres).to eql(22)
    expect(@may.ouvres).to eql(21)
    expect(@jun.ouvres).to eql(22)
    expect(@jul.ouvres).to eql(22)
    expect(@aug.ouvres).to eql(22)
    expect(@sep.ouvres).to eql(22)
    expect(@oct.ouvres).to eql(21)
    expect(@nov.ouvres).to eql(22)
    expect(@dec.ouvres).to eql(23)
  end

  it 'should report calendaires correctly when overlapping two years' do
    dec_09_to_jan_10 = TimeGenie::TimeSpan.new(Date.new(2009, 12, 1), Date.new(2010, 1, 31))
    expect(dec_09_to_jan_10.calendaires).to eql(62)
  end

  it 'should intersect correctly' do
    ts1 = TimeGenie::TimeSpan.new(Date.new(2010, 1, 1), Date.new(2010, 1, 31))
    ts2 = TimeGenie::TimeSpan.new(Date.new(2010, 2, 1), Date.new(2010, 2, 28))

    expect(ts1.intersect(ts2)).to be_nil

    ts1 = TimeGenie::TimeSpan.new(Date.new(2010, 1, 1), Date.new(2010, 2, 1))
    ts2 = TimeGenie::TimeSpan.new(Date.new(2010, 2, 1), Date.new(2010, 2, 28))

    expect(ts1.intersect(ts2)).to eql(TimeGenie::TimeSpan.new(Date.new(2010, 2, 1), Date.new(2010, 2, 1)))

    ts1 = TimeGenie::TimeSpan.new(Date.new(2010, 1, 1), Date.new(2010, 1, 31))
    ts2 = TimeGenie::TimeSpan.new(Date.new(2010, 2, 1), Date.new(2010, 2, 28))

    tsc = TimeGenie::TimeSpanCollection.new([ts1, ts2])
    ts3 = TimeGenie::TimeSpan.new(Date.new(2010, 1, 15), Date.new(2010, 2, 15))

    ts4 = TimeGenie::TimeSpan.new(Date.new(2010, 1, 15), Date.new(2010, 1, 31))
    ts5 = TimeGenie::TimeSpan.new(Date.new(2010, 2, 1), Date.new(2010, 2, 15))
    tsc_res = TimeGenie::TimeSpanCollection.new([ts4, ts5])

    expect(tsc_res).to eql(ts3.intersect(tsc))
  end

  it 'should report unequality correctly' do
    ts1 = TimeGenie::TimeSpan.new(Date.today, Date.today + 3)
    ts2 = TimeGenie::TimeSpan.new(Date.today, Date.today + 6)

    expect(ts1).to_not eql(ts2)
  end
end
