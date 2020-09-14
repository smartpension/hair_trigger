# frozen_string_literal: true

require 'spec_helper'

describe 'MySQL definer' do
  let(:config_username) { nil }
  let(:config_host) { nil }

  let(:config) {
    {
      username: config_username,
      host: config_host
    }
  }

  let(:definer) { HairTrigger::Mysql::Definer.new(config: config) }

  describe '#to_s' do
    subject { definer.to_s }

    context 'when config is empty' do
      it 'returns a default definer' do
        expect(subject).to eq "'root'@'localhost'"
      end

    end

    context 'with a configured username' do
      let(:config_username) { 'user' }

      it 'includes the username' do
        expect(subject).to eq "'user'@'localhost'"
      end
    end

    context 'with a configured host' do
      let(:config_host) { 'host.example.com' }

      it 'includes the host' do
        expect(subject).to eq "'root'@'host.example.com'"
      end

      describe 'translations' do
        context '127.0.0.1' do
          let(:config_host) { '127.0.0.1' }

          it "translates to 'localhost'" do
            expect(subject).to eq "'root'@'localhost'"
          end
        end
      end
    end

    context 'with user override in initialize' do
      let(:user) { 'test' }
      let(:definer) { HairTrigger::Mysql::Definer.new(user: user, config: config) }

      it 'includes the user' do
        expect(subject).to eq "'test'@'localhost'"
      end
    end

    context 'with host override in initialize' do
      let(:host) { 'host.example.com' }
      let(:definer) { HairTrigger::Mysql::Definer.new(host: host, config: config) }

      it 'includes the host' do
        expect(subject).to eq "'root'@'host.example.com'"
      end

      describe 'translations' do
        context '127.0.0.1' do
          let(:host) { '127.0.0.1' }

          it "translates to 'localhost'" do
            expect(subject).to eq "'root'@'localhost'"
          end
        end

        context '%' do
          let(:host) { '%' }

          it "translates to 'localhost'" do
            expect(subject).to eq "'root'@'localhost'"
          end
        end
      end
    end
  end
end
