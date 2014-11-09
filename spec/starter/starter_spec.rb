require 'spec_helper'

RSpec.describe Codeland::Starter do
  describe '.create_project' do
    let!(:name) { 'app-name' }
    let!(:installed_yaml) { File.join(File.dirname(__FILE__), '..', '..', 'lib', 'codeland', 'starter', 'codeland-starter.yml') }

    context 'name' do
      before { expect_any_instance_of(Codeland::Starter::Configuration).to receive(:integrations).and_return([]) }

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
              expect_any_instance_of(Codeland::Starter::Configuration).to receive(:integrations).and_return([integration])
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
end
