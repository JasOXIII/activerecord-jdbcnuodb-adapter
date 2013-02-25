module Arel
  module Visitors
    class NuoDB < Arel::Visitors::ToSql
      def visit_Arel_Nodes_SelectStatement(o)
        [
            (visit(o.with) if o.with),
            o.cores.map { |x| visit_Arel_Nodes_SelectCore x }.join,
            ("ORDER BY #{o.orders.map { |x| visit x }.join(', ')}" unless o.orders.empty?),
            (visit(o.offset) if o.offset),
            (visit(o.limit) if o.limit),
            (visit(o.lock) if o.lock),
        ].compact.join ' '
      end

      def visit_Arel_Nodes_Limit(o)
        "FETCH FIRST #{visit o.expr} ROWS ONLY"
      end
    end
  end
end

