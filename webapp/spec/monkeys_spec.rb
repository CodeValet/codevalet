require 'spec_helper'
require 'codevalet/webapp/monkeys'

describe CodeValet::WebApp::Monkeys do
  subject(:klass) { described_class }
  before(:each) { klass.clear! }

  it { should respond_to :data }
  describe '.data' do
    subject(:data) { klass.data }

    it { should be_kind_of Array }

    it 'should only read the file once' do
      expect(File).to receive(:readlines).and_call_original.once

      1..3.times { klass.data }
    end
  end
end
