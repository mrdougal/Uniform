# require 'uniform/extensions/errors'
# require 'uniform/extensions/rescue'
require 'uniform/configuration'
require 'uniform/routes'

require 'uniform/rescues'
require 'uniform/authentication'
require 'uniform/cart_methods'
require 'uniform/helpers'


ActionView::Base.send :include, Uniform::Helpers

ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :compnow => ['reset','base', 'compnow']
ActionView::Helpers::AssetTagHelper.register_stylesheet_expansion :plugins =>['plugins/formtastic','plugins/formtastic_changes']
