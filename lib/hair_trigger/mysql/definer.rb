module HairTrigger
  module Mysql
    class Definer

      HOST_TRANSLATIONS = {
        '127.0.0.1' => -> { 'localhost' },
        '%'         => -> { config[:host] }
      }.freeze

      def initialize(user: nil, host: nil, config:)
        @config = config
        @user = user || config[:username]
        @host = host || config[:host]
      end

      def user
        @user || 'root'
      end

      def host
        translate_host(@host) || 'localhost'
      end

      def to_s
        "'#{user}'@'#{host}'"
      end

      private

      attr_reader :config

      def translate_host(host)
        translation  = HOST_TRANSLATIONS[host]
        translation ? instance_exec(&translation) : host
      end
    end
  end
end
