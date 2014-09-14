require 'spec_helper'

RSpec.describe Codeland::Starter::Env do
  let!(:before_oauth_token) { ENV['HEROKU_OAUTH_TOKEN'] }

  describe '.service_ready?' do
    subject { described_class.service_ready?(service) }

    context 'ready service' do
      context 'Heroku' do
        let!(:service) { 'Heroku' }

        before { ENV['HEROKU_OAUTH_TOKEN'] = 'some token' }
        after { ENV['HEROKU_OAUTH_TOKEN'] = before_oauth_token }

        it { expect{ subject }.not_to raise_error }
        it { is_expected.to be_nil }
      end
    end

    context 'missing envs' do
      context 'Heroku' do
        let!(:service) { 'Heroku' }

        before { ENV['HEROKU_OAUTH_TOKEN'] = nil }
        after { ENV['HEROKU_OAUTH_TOKEN'] = before_oauth_token }

        it { expect{ subject }.to raise_error(described_class::EnvNotSet) }
      end
    end
  end
end
