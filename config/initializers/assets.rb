
#This was added by Mark to handle addition of conditional css/js due to JQMobile
Rails.application.config.assets.precompile += %w( app_jqrymob.css )
Rails.application.config.assets.precompile += %w( app_jqrymob.js )