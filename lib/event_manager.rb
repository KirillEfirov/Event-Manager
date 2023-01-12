require "csv"
puts "Event Manager Initialized!"

if File.exist? "event_attendees.csv"
    contents = CSV.open("event_attendees.csv", headers: true)
    contents.each do |row|
        name = row[2]
        puts name
    end
else puts "File is not found"
end