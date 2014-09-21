require 'spec_helper'

RSpec.describe Codeland::Starter::Configuration do
  let!(:installed_yaml) { File.join(File.dirname(__FILE__), '..', '..', 'lib', 'codeland', 'starter', 'codeland-starter.yml') }

  describe '::DEFAULT_FILENAME' do
    it { expect(described_class::DEFAULT_FILENAME).to eq('codeland-starter.yml') }
  end

  describe 'initialize' do
    context '@yaml' do
      let!(:other_yaml) { 'otherfile.yml' }

      context 'installed' do
        context 'argument file exists' do
          subject { described_class.new(other_yaml) }

          before do
            expect(File).to receive(:exists?).with(other_yaml).and_return(true)
            expect(File).to receive(:open).with(other_yaml).and_return(other_yaml)
            expect(YAML).to receive(:load_file).with(other_yaml).and_return(other_yaml)
          end

          it { expect(subject.yaml).to eq(other_yaml) }
        end

        context 'argument dont exists' do
          let!(:default_yaml) { File.join(Dir.home, described_class::DEFAULT_FILENAME) }

          before do
            expect(File).to receive(:exists?).with(other_yaml).and_return(false)
            expect(File).to receive(:exists?).with(default_yaml).and_return(true)
            expect(File).to receive(:open).with(default_yaml).and_return(default_yaml)
            expect(YAML).to receive(:load_file).with(default_yaml).and_return(default_yaml)
          end

          subject { described_class.new(other_yaml) }

          it { expect(subject.yaml).to eq(subject.default_yaml_file) }
        end
      end

      context 'not installed' do
        before { expect(File).to receive(:exists?).exactly(2).times.and_return(false) }

        it { expect{ described_class.new(installed_yaml) }.to raise_error(Codeland::Starter::MissingYAML) }
      end
    end
  end

  describe '#default_yaml_file' do
    subject { described_class.new(file).default_yaml_file }

    let!(:file) { File.open(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'codeland', 'starter', 'codeland-starter.yml')) }

    it { is_expected.to eq(File.join(Dir.home, described_class::DEFAULT_FILENAME)) }
  end

  describe '#integrations' do
    subject { described_class.new(installed_yaml).integrations }

    it { is_expected.to be_a(Array) }
  end
end
