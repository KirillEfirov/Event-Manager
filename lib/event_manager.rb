require "csv"
puts "Event Manager Initialized!"

if File.exist? "event_attendees.csv"
    contents = CSV.open(
        "event_attendees.csv", 
        headers: true, 
        header_converters: :symbol
    )

    contents.each do |row|
        name = row[:first_name]
        puts name
    end
else puts "File is not found"
end