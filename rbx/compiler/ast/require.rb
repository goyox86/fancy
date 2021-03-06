module Fancy
  module AST

    class Require < Node
      def initialize(line, string)
        super(line)
        @string = string
      end

      def bytecode(g)
        Rubinius::AST::Self.new(1).bytecode(g)
        @string.bytecode(g)
        pos(g)
        g.allow_private
        g.send :fancy_require, 1, false
      end
    end

  end
end
