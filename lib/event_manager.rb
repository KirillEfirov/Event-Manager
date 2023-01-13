require "csv"
require 'google/apis/civicinfo_v2'
puts "Event Manager Initialized!"

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

def clean_zipcode(zipcode)
        zipcode.to_s.rjust(5, "0")[0, 5]
end

if File.exist? "event_attendees.csv"
    contents = CSV.open(
        "event_attendees.csv", 
        headers: true, 
        header_converters: :symbol
    )

    contents.each do |row|
        zipcode = clean_zipcode(row[:zipcode])
        name = row[:first_name]

        begin
            legislators = civic_info.representative_info_by_address(
                address: zipcode,
                levels: 'country',
                roles: ['legislatorUpperBody', 'legislatorLowerBody']
            )
            legislators = legislators.officials
        rescue
            'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
        end
        
        puts "#{name} #{zipcode} #{legislators}"
    end
else puts "File is not found"
end


