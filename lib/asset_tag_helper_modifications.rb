module AssetTagHelperModifications

  def self.included(base)
    base.class_eval {
      def path_to_javascript(source)
        if source.match(/^http/)
          source
        else
          compute_public_path(source, 'javascripts', 'js')
        end
      end
    }
  end
end