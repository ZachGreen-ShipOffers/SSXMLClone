#!/usr/local/bin/ruby

# With Nokogiri i can pasre each node and populate an array with the data.


require 'unirest'
require 'nokogiri'
require 'json'
require 'active_support/core_ext/hash'
params = {
  action: 'export',
  # UTC format mm/dd/yyyy HH:mm (24hour)
  start_date: '03/01/201500:00',
  end_date: '04/02/201507:00'
  }

res = Unirest.get 'http://demo1.etrackerplus.com/store/5006/custom_stores', headers: {}, parameters: params, auth: {:user => 'none', :password => 'none'}

ary.each {|e|
  e.each {|i|
    if i.class == REXML::Element
      puts "ELEMENT"
      puts i.value
    elsif i.class == REXML::Text
      puts i.value
    end
  }
}

# s = Nokogiri::XML(File.open('order.xml'))
# i = s.at_xpath '//Items'
# puts i.content
# puts "\n\n\n\n\n\>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n\n\n"


=begin
  send shipping notification to store once order has shippped
  uri: ?action=shipnotify
    &order_number=ABC123
    &carrier=USPS
    &service=USPS+Priority+Mail
    &tracking_number=9511343223432432432s

  TODO
  function to build xml shipment
  function to get info for order to put into xml function

=end

# res = Unirest.get 'http://storetosendshipingconfirmation.com/', headers: {}, parameters: 'xml Object'
# response should have a code of 200. if not try again.


def build_xml fields={}
  builder = Nokogiri::XML::Builder.new {|x|
    x.ShipNotice {
      x.OrderNumber fields["OrderNumber"]
      x.OrderID fields["OrderID"]
      x.CustomerCode fields["CustomerCode"]
      x.LabelCreateDate fields["LabelCreateDate"]
      x.ShipDate fields["ShipDate"]
      x.Carrier fields["Carrier"]
      x.Service fields["Service"]
      x.TrackingNumber fields["TrackingNumber"]
      x.ShippingCost fields["ShippingCost"]
      x.Recipient {
        x.Name fields["Name"]
        x.Company fields["Company"]
        x.Address1 fields["Address1"]
        x.Address2 fields["Address2"]
        x.City fields["City"]
        x.State fields["State"]
        x.PostalCode fields["PostalCode"]
        x.Country fields["Country"]
      }
      x.Items {
        x.Item {
          x.SKU fields["SKU"]
          x.Name fields["Name"]
          x.Quantity fields["Quantity"]
        }
      }
    }
  }
  puts builder.to_xml

end

# build_xml
