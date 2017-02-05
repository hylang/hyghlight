# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class HyLang < RegexLexer
      title "HyLang"
      desc "The HyLang programming language (hylang.org)"

      tag 'hylang'
      aliases 'hy'

      filenames '*.hy'

      mimetypes 'text/x-hy', 'application/x-hy'

      def self.keywords
        @keywords ||= Set.new %w(
        )
      end

      def self.builtins
        @builtins ||= Set.new %w(
        )
      end

      identifier = %r([\w!$%*+,<=>?/.-]+)
      keyword = %r([\w!\#$%*+,<=>?/.-]+)

      def name_token(name)
        return Keyword if self.class.keywords.include?(name)
        return Name::Builtin if self.class.builtins.include?(name)
        nil
      end

      state :root do
        rule /;.*?$/, Comment::Single
        rule /\s+/m, Text::Whitespace

        rule /-?\d+\.\d+/, Num::Float
        rule /-?\d+/, Num::Integer
        rule /0x-?[0-9a-fA-F]+/, Num::Hex

        rule /"(\\.|[^"])*"/, Str
        rule /'#{keyword}/, Str::Symbol
        rule /::?#{keyword}/, Name::Constant
        rule /\\(.|[a-z]+)/i, Str::Char


        rule /~@|[`\'#^~&@]/, Operator

        rule /(\()(\s*)(#{identifier})/m do |m|
          token Punctuation, m[1]
          token Text::Whitespace, m[2]
          token(name_token(m[3]) || Name::Function, m[3])
        end

        rule identifier do |m|
          token name_token(m[0]) || Name
        end

        # vectors
        rule /[\[\]]/, Punctuation

        # maps
        rule /[{}]/, Punctuation

        # parentheses
        rule /[()]/, Punctuation
      end
    end
  end
end
