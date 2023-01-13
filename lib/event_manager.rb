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

            legislators_names = legislators.map do |legislator|
                    legislator.name
            end
        rescue
            'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
        end

        legislators_names = ["Not found"] if legislators_names.nil?
        
        puts "#{name} #{zipcode} #{legislators_names.join()}"
    end
else puts "File is not found"
end


