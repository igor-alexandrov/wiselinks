module Wiselinks
  module Helpers    
    def wiselinks_meta_tag
      if Wiselinks.options[:assets_digest].present?       
        tag('meta', :name => 'assets-digest', :content => Wiselinks.options[:assets_digest])
      end
    end 
  end
end
