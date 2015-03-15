require 'spec_helper'

RSpec.describe Codeland::Starter do
  describe '.create_project' do
    before do
      allow(Codeland::Starter).to receive(:create_rails_project).and_return(true)
    end
    let!(:name) { 'app-name' }
    let!(:installed_yaml) { File.join(File.dirname(__FILE__), '..', '..', 'lib', 'codeland', 'starter', 'codeland-starter.yml') }

    context 'name' do
      before { expect_any_instance_of(Codeland::Starter::Configuration).to receive(:integrations).exactly(2).times.and_return([]) }

      it 'sets @name' do
        subject.create_project(name, installed_yaml)
        expect(subject.name).to eq(name)
      end
    end

    context 'integrations' do
      context 'with correct yaml' do
        context 'empty integrations on yaml' do
          before { expect_any_instance_of(Codeland::Starter::Configuration).to receive(:integrations).and_return([]) }

        end
        context 'with integrations' do
          after { subject.create_project(name, installed_yaml) }

          context 'defined integrations' do
            let!(:integration) { 'heroku' }
            let!(:integration_class) { Codeland::Starter::Integrations::Heroku }
            before do
              expect_any_instance_of(Codeland::Starter::Configuration).to receive(:integrations).exactly(2).times.and_return([integration])
            end

            it 'calls integration#perform' do
              expect_any_instance_of(integration_class).to receive(:perform).and_return(nil)
            end
          end
        end
      end

      context 'not existing yaml' do
      end
    end
  end

  describe '.create_rails_project' do
    subject { described_class }
    let!(:app_name) { 'my-cool-app' }
    before do
      is_expected.to receive(:name).and_return(app_name).at_least(1).times
      expected = "rails new #{app_name} --database=postgresql --template=#{File.join(described_class::ROOT_PATH, 'template', 'codeland.rb')} --skip-bundle --skip-test-unit"
      expect(described_class).to receive(:system).with(expected).once.and_return(nil)
      expect(Dir).to receive(:chdir).with(app_name).once.and_return(nil)
    end

    it 'calls rails new app_name with correct options' do
      subject.create_rails_project
    end
  end
end
