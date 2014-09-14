require 'spec_helper'

RSpec.describe Codeland::Starter::Services::Heroku do
  def stub_heroku(content = nil, status = 201, app_name = name)
    stub_request(:post, 'https://api.heroku.com/apps')
      .with(
        :body    => { :name => name, :region => 'us', :stack => 'cedar' },
        :headers => {
          'Accept'        => 'application/vnd.heroku+json; version=3',
          'Authorization' => "Bearer #{ENV['HEROKU_OAUTH_TOKEN']}",
          'Content-Type'  => 'application/json',
          'Host'          => 'api.heroku.com:443',
          'User-Agent'    => 'excon/0.39.5'
        }
      ).to_return(:status => status, :body => content)
  end

  def stub_heroku_error(error, app_name = name)
    stub_request(:post, 'https://api.heroku.com/apps')
      .with(
        :body    => { :name => app_name, :region => 'us', :stack => 'cedar' },
        :headers => {
          'Accept'        => 'application/vnd.heroku+json; version=3',
          'Authorization' => "Bearer #{ENV['HEROKU_OAUTH_TOKEN']}",
          'Content-Type'  => 'application/json',
          'Host'          => 'api.heroku.com:443',
          'User-Agent'    => 'excon/0.39.5'
        }
      ).to_raise(error)
  end

  let!(:heroku_file) do
    File.open(File.dirname(__FILE__) + '/../../fixtures/heroku_app.json', 'rb')
  end

  subject { described_class.new(name) }

  describe '#initialize' do
    let!(:name) { 'MyAppName' }
    let!(:heroku_token) { ENV['HEROKU_OAUTH_TOKEN'] }

    context 'name' do
      it 'sets @name' do
        expect(subject.instance_variable_get(:@name)).to eq(name)
      end
    end

    context 'api' do
      context 'with ENV[HEROKU_OAUTH_TOKEN]' do
        it 'sets @api' do
          expected_kind = PlatformAPI::Client
          expect(subject.instance_variable_get(:@api)).to be_a(expected_kind)
        end
      end
    end
  end

  describe '#create' do
    subject { described_class.new(name).create }

    context 'wrong oauth token' do
      let!(:name) { 'MyAppName' }
      before { stub_heroku_error(Excon::Errors::Unauthorized) }

      it 'raises Env::EnvNotSet' do
        expect{ subject }.to raise_error(Codeland::Starter::Env::EnvNotSet)
      end
    end

    context 'app with name taken' do
      subject { described_class.new(name) }
      let!(:name) { 'codeland' }
      before do
        error = Excon::Errors::UnprocessableEntity.new("UnprocessableEntity")
        stub_heroku_error(error, name)
        stub_heroku(heroku_file, 201, nil)
        is_expected.to receive(:create_app).with(name).once.and_raise(error)
        is_expected.to receive(:create_app).with(no_args).once
      end



      it 'calls create with empty name' do
        subject.create
      end
    end

    context 'app with new unique name' do
      before { stub_heroku(heroku_file) }

      let!(:name) { 'new-app-for-codeland' }

      context 'returned json have some keys' do
        %w(git_url id name web_url).each do |key|
          it "includes #{key} key" do
            expect(JSON.parse(subject)).to have_key('id')
          end
        end
      end
    end
  end
end
