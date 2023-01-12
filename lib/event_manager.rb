puts "Event Manager Initialized!"

if File.exist? "event_attendees.csv"
    lines = File.open("event_attendees.csv", "r").readlines
    lines.each do |line|
        puts line.split(",")[2]
    end
else puts "File is not found"
end