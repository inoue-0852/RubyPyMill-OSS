require "spec_helper"
require "ruby_pymill"

RSpec.describe RubyPyMill do
  it "has a version" do
    expect(RubyPyMill::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end