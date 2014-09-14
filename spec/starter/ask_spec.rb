require 'spec_helper'

RSpec.describe Codeland::Starter::Ask do
  describe '.question?' do
    before { expect(described_class).to receive(:print).and_return(nil) }

    subject { described_class.question?('question') }

    context 'yes' do
      %w(y ye yes Y YE YES Yes).each do |word|
        context "accepts #{word}" do
          before { expect(STDIN).to receive(:gets).and_return(word) }

          it { is_expected.to be true }
        end
      end
    end

    context 'no' do
      %w(n no N NO No).each do |word|
        context "accepts #{word}" do
          before { expect(STDIN).to receive(:gets).and_return(word) }

          it { is_expected.to be false }
        end
      end
    end
  end

  describe '.heroku?' do
    it 'calls .question? with Wants heroku?' do
      is_expected.to receive(:question?).with('Wants heroku?')
      subject.heroku?
    end
  end
end
