module Arel
  module Visitors
    class NuoDB < Arel::Visitors::ToSql
      def visit_Arel_Nodes_Lock o
        visit o.expr
      end

      def visit_Arel_Nodes_Limit o
        "FETCH FIRST #{visit o.expr} ROWS ONLY"
      end

      def visit_Arel_Nodes_Matches o
        "#{visit o.left} LIKE #{visit o.right}"
      end

      def visit_Arel_Nodes_DoesNotMatch o
        "#{visit o.left} NOT LIKE #{visit o.right}"
      end
    end
  end
end

