class SmartServiceQos  < ActionWebService::Struct
  member :cost, SmartServiceQosParameter
  member :time, SmartServiceQosParameter
  member :groupness_factor, SmartServiceQosParameter
end