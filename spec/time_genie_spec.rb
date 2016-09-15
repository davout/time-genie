require_relative './spec_helper'

describe 'TimeGenie' do

  it 'should have a version' do
    expect(TimeGenie::VERSION).to match(/\d\.\d\.\d/)
  end

end

