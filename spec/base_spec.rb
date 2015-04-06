# require_relative '../lib/power-build/base'
require 'spec_helper'
require 'ostruct'

describe PowerBuild::Base do
  it '#push' do
    expect(subject.push).to be_falsy
  end

  it '#init' do
    expect{subject.init}.to change{Dir.entries(".").length}.by(1)
    expect{ subject.init }.to raise_error SystemExit
  end

  it '#print_version' do
    expect{ subject.__print_version }.to output(PowerBuild::VERSION + "\n").to_stdout
    expect(subject.__print_version).to be_falsy
  end

  it '#delete' do
    stub_const("PowerBuild::Constructor", 
      OpenStruct.new(:new => 
        OpenStruct.new(:remove_config => "remove_is_called")))
    expect(subject.delete).to eq "remove_is_called"
  end

  after(:each) do
    file = "power-build.config"
    if File.file? file
      FileUtils.remove file
      puts "#{file} is removed."
    end
  end

end

