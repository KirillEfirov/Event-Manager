puts "Event Manager Initialized!"

if File.exist? "event_attendees.csv"
    lines = File.open("event_attendees.csv", "r").readlines
    puts lines
else puts "File is not found"
end