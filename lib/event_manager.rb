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

def busy_hours(reg_dates) 
    hours = reg_dates.map { |date| date.split(" ")[1].split(":")[0] }

    frequent_hour = Hash.new
    (00..23).each { |hour| frequent_hour["#{hour} hour(s)"] = hours.count(hour.to_s) }

    frequent_hour.delete_if { |key, value| value == 0}

    frequent_hour
end

if File.exist? "event_attendees.csv"
    contents = CSV.open(
        "event_attendees.csv", 
        headers: true, 
        header_converters: :symbol
    )

    reg_dates = Array.new

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

        reg_dates.push(row[:regdate])
    end

    puts busy_hours(reg_dates)



else puts "File is not found"
end


