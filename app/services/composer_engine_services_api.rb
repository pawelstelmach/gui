class ComposerEngineServicesApi < ActionWebService::API::Base
  api_method :compose, :expects => [SmartServiceGraph], :returns => [SmartServiceGraph]
end
