require "csv"
require 'google/apis/civicinfo_v2'
require "erb"
puts "Event Manager Initialized!"

def clean_zipcode(zipcode)
        zipcode.to_s.rjust(5, "0")[0, 5]
end

def legisplators_by_zipcode(zipcode)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        civic_info.representative_info_by_address(
          address: zipcode,
          levels: 'country',
          roles: ['legislatorUpperBody', 'legislatorLowerBody']
        ).officials
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
end

if File.exist? "event_attendees.csv"
    contents = CSV.open(
        "event_attendees.csv", 
        headers: true, 
        header_converters: :symbol
    )

    template_letter = File.read('form_letter.erb')
    erb_template = ERB.new template_letter

    contents.each do |row|
        id = row[0]
        zipcode = clean_zipcode(row[:zipcode])
        name = row[:first_name]
        legislators = legisplators_by_zipcode(zipcode)
        puts "#{name} - #{zipcode} - #{legislators}"

        form_letter = erb_template.result(binding)
        puts form_letter

        Dir.mkdir('output') unless Dir.exist?('output')

        filename = "output/thanks_#{id}.html"

        File.open(filename, 'w') do |file|
            file.puts form_letter
        end
    end
else puts "File is not found"
end


