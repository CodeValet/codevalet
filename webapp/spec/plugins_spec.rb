require 'spec_helper'
require 'codevalet/webapp/plugins'

describe CodeValet::WebApp::Plugins do
  subject(:klass) { described_class }
  before(:each) { klass.clear! }

  it { should respond_to :data }
  describe '.data' do
    subject(:data) { klass.data }

    it { should be_kind_of Hash }

    it 'should only read the file once' do
      expect(File).to receive(:read).and_call_original.once

      1..3.times { klass.data }
    end
  end

  it { should respond_to :essential }
  describe '.essential' do
    subject(:essential) { klass.essential}
    it { should be_kind_of Hash }
  end
end
