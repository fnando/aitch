# frozen_string_literal: true

module Aitch
  module Ext
    refine String do
      def dasherize
        unicode_normalize(:nfkd)
          .delete("'")
          .gsub(/[^\x00-\x7F]/, "")
          .gsub(/([a-z\d])([A-Z])/, '\1-\2')
          .gsub(/([A-Z]+)([A-Z][a-z])/, '\1-\2')
          .gsub(/[^-\w]+/xim, "-")
          .tr("_", "-")
          .gsub(/-+/xm, "-")
          .gsub(/^-?(.*?)-?$/, '\1')
          .downcase
      end
    end
  end
end
