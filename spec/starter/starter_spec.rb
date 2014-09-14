require 'spec_helper'

RSpec.describe Codeland::Starter do
  describe '.create_project' do
    let!(:name) { 'app-name' }

    it 'sets @name' do
      expect(Codeland::Starter::Ask).to receive(:heroku?).and_return(false)
      subject.create_project(name)
      expect(subject.name).to eq(name)
    end

    context 'with heroku' do
      after { subject.create_project(name) }

      it 'calls .create_heroku' do
        expect(Codeland::Starter::Ask).to receive(:heroku?).and_return(true)
        is_expected.to receive(:create_heroku).once
      end
    end

    context 'without heroku' do
      after { subject.create_project(name) }

      it 'not calls .create_heroku' do
        expect(Codeland::Starter::Ask).to receive(:heroku?).and_return(false)
        is_expected.not_to receive(:create_heroku)
      end
    end
  end

  describe '.create_heroku' do
    subject { described_class.create_heroku }

    context 'Env vars ready' do
      before do
        expect(described_class).to receive(:name).and_return('app-name')

        expect(Codeland::Starter::Env).to receive(:service_ready?)
          .with('Heroku').and_return(true)
      end

      it 'calls heroku.create' do
        heroku = Codeland::Starter::Services::Heroku
        expect_any_instance_of(heroku).to receive(:create).once.and_return(nil)
        subject
      end
    end

    context 'missing env vars' do
      before do
        env = Codeland::Starter::Env
        expect(env).to receive(:service_ready?)
          .with('Heroku').and_raise(env::EnvNotSet.new('Heroku'))
      end

      it 'exits' do
        expect{ subject }.to raise_exception(SystemExit)
      end
    end
  end
end
