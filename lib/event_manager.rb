require "csv"
puts "Event Manager Initialized!"

def clean_zipcode(zipcode)
    if zipcode.to_s.length < 5
        zipcode.to_s.rjust(5, "0")
    elsif
        zipcode.to_s[0, 5]
    else
        zipcode
    end
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

        puts "#{name} - #{zipcode}"
    end
else puts "File is not found"
end