module Fancy
  module AST

    class Match < Node
      def initialize(line, expr, clauses)
        super(line)
        @expr = expr
        @clauses = clauses
      end

      def bytecode(g)
        pos(g)

        # create labels for each clause body.
        clause_labels = []
        @clauses.size.times do
          clause_labels << g.new_label
        end
        end_label = g.new_label

        # ok, let's emit the bytecode
        @expr.bytecode(g)

        @clauses.each_with_index do |c, i|
          g.dup # save the @expr since we need to reuse it
          c.match_expr.bytecode(g)
          # use == for now, since === doesn't work as expected so far.
          g.send :==, 1
          g.git clause_labels[i]
        end
        g.pop
        g.push_nil
        g.goto end_label

        clause_labels.each_with_index do |label, i|
          label.set!
          g.pop
          @clauses[i].val_expr.bytecode(g)
          g.goto end_label
        end

        end_label.set!
      end
    end

    class MatchClause < Node
      attr_reader :match_expr, :val_expr
      def initialize(line, match_expr, val_expr)
        super(line)
        @match_expr = match_expr
        @val_expr = val_expr
      end
    end

  end
end