require "csv"
puts "Event Manager Initialized!"

if File.exist? "event_attendees.csv"
    contents = CSV.open(
        "event_attendees.csv", 
        headers: true, 
        header_converters: :symbol
    )

    contents.each do |row|
        zip = row[:zipcode]
        name = row[:first_name]

        if zip.to_s.length < 5
            zip = zip.to_s.rjust(5, "0")
        else
            zip = zip.to_s[0, 5]
        end

        puts "#{name} - #{zip}"
    end
else puts "File is not found"
end