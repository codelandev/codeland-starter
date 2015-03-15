require 'spec_helper'

RSpec.describe Codeland::Starter::Integrations::Heroku do
  def stub_heroku(content = nil, status = 201, app_name = name)
    stub_request(:post, 'https://api.heroku.com/apps')
      .with(
        :body    => { :name => name, :region => 'us', :stack => 'cedar' },
        :headers => {
          'Accept'        => 'application/vnd.heroku+json; version=3',
          'Authorization' => "Bearer #{heroku_token}",
          'Content-Type'  => 'application/json',
          'Host'          => 'api.heroku.com:443',
          'User-Agent'    => "excon/#{Excon::VERSION}"
        }
      ).to_return(:status => status, :body => content)
  end

  def stub_heroku_error(error, app_name = name)
    stub_request(:post, 'https://api.heroku.com/apps')
      .with(
        :body    => { :name => app_name, :region => 'us', :stack => 'cedar' },
        :headers => {
          'Accept'        => 'application/vnd.heroku+json; version=3',
          'Authorization' => "Bearer #{heroku_token}",
          'Content-Type'  => 'application/json',
          'Host'          => 'api.heroku.com:443',
          'User-Agent'    => "excon/#{Excon::VERSION}"
        }
      ).to_raise(error)
  end

  let!(:heroku_token) { 'HEROKU_OAUTH_TOKEN' }

  let!(:heroku_file) do
    File.open(File.dirname(__FILE__) + '/../../fixtures/heroku_app.json', 'rb')
  end

  let!(:installed_yaml) { File.join(File.dirname(__FILE__), '..', '..', '..', 'lib', 'codeland', 'starter', 'codeland-starter.yml') }


  describe '#initialize' do
    let!(:name) { 'MyAppName' }

    context 'api' do
      context 'with heroku key in YAML' do
        before { expect(Codeland::Starter::Configuration).to receive(:[]).with('heroku').exactly(2).times.and_return({'oauth_token' => heroku_token}) }

        it 'sets @api' do
          expected_kind = PlatformAPI::Client
          expect(subject.instance_variable_get(:@api)).to be_a(expected_kind)
        end
      end

      context 'without heroku key in YAML' do
        before do
          expect(Codeland::Starter::Configuration).to receive(:[]).with('heroku').once.and_return(nil)
          expect(Codeland::Starter).to receive(:config).and_return(Codeland::Starter::Configuration.new(installed_yaml))
        end

        it 'raises missing yaml' do
          expect{ described_class.new }.to raise_error(Codeland::Starter::MissingYAML)
        end
      end
    end
  end

  describe '#create' do
    before do
      expect(Codeland::Starter).to receive(:name).and_return(name)
    end

    subject { described_class.new.create }

    context 'wrong oauth token' do
      let!(:name) { 'MyAppName' }
      before { stub_heroku_error(Excon::Errors::Unauthorized) }
      before { expect(Codeland::Starter).to receive(:config).and_return(Codeland::Starter::Configuration.new(installed_yaml)) }
      before { expect(Codeland::Starter::Configuration).to receive(:[]).with('heroku').exactly(2).times.and_return({'oauth_token' => heroku_token}) }
      before { allow_any_instance_of(described_class).to receive(:add_git_remote).and_return(nil) }

      it 'raises MissingYAML' do
        expect{ subject }.to raise_error(Codeland::Starter::MissingYAML)
      end
    end

    context 'app with name taken' do
      subject { described_class.new }
      let!(:name) { 'codeland' }
      before do
        expect(Codeland::Starter::Configuration).to receive(:[]).with('heroku').exactly(2).times.and_return({'oauth_token' => heroku_token})
        error = Excon::Errors::UnprocessableEntity.new("UnprocessableEntity")
        stub_heroku_error(error, name)
        stub_heroku(heroku_file, 201, nil)
        is_expected.to receive(:create_app).with(name).once.and_raise(error)
        is_expected.to receive(:create_app).with(no_args).once
        allow_any_instance_of(described_class).to receive(:add_git_remote).and_return(nil)
      end

      it 'calls create with empty name' do
        subject.create
      end
    end

    context 'app with new unique name' do
      before { expect(Codeland::Starter::Configuration).to receive(:[]).with('heroku').exactly(2).times.and_return({'oauth_token' => heroku_token}) }
      before { stub_heroku(heroku_file) }

      subject { described_class.new }

      let!(:name) { 'new-app-for-codeland' }

      context 'returned json have some keys' do
        before { subject.create }
        before { allow_any_instance_of(described_class).to receive(:add_git_remote).and_return(nil) }

        %w(git_url id name web_url).each do |key|
          it "includes #{key} key" do
            expect(JSON.parse(subject.app)).to have_key('id')
          end
        end
      end

      context 'git remote' do
        before do
          expected = "git remote add heroku git_url"
          expect(subject).to receive(:system).with(expected).once
        end

        it 'calls git remote add heroku' do
          subject.create
        end
      end
    end
  end

  describe '#output' do
    before { expect(Codeland::Starter).to receive(:config).exactly(4).times.and_return(Codeland::Starter::Configuration.new(installed_yaml)) }

    context 'default' do
      it { expect(subject.output).to be_nil }
    end

    context 'successfull' do
      it 'prints a message' do
        expect(subject).to receive(:success?).and_return(true)
        expect(STDOUT).to receive(:puts)
        subject.output
      end
    end
  end

  describe '#perform' do
    before { expect(Codeland::Starter).to receive(:config).exactly(4).times.and_return(Codeland::Starter::Configuration.new(installed_yaml)) }

    context '#create' do
      before do
        expect_any_instance_of(Codeland::Starter::Integrations::Heroku).to receive(:create).once
        expect_any_instance_of(Codeland::Starter::Integrations::Heroku).to receive(:output).once.and_return(nil)
      end

      it 'calls #create' do
        subject.perform
      end
    end

    context '#output' do
      before do
        expect_any_instance_of(Codeland::Starter::Integrations::Heroku).to receive(:create).once.and_return(nil)
        expect_any_instance_of(Codeland::Starter::Integrations::Heroku).to receive(:output).once
      end

      it 'calls #output' do
        subject.perform
      end
    end
  end
end
