require "csv"
require 'google/apis/civicinfo_v2'
require "erb"
def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
                                  address: zip,
                                  levels: 'country',
                                  roles: ['legislatorUpperBody', 'legislatorLowerBody'])
    legislators.officials
  rescue
    "You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials"
  end
end

def save_thank_you_letter(id,form_letter)
    Dir.mkdir("output") unless Dir.exists? "output"
    
    filename = "output/thanks_#{id}.html"

    File.open(filename,'w') do |file|
        file.puts form_letter
    end
end

def clean_phone_number(number) 
    cleaned = number.delete("().-").split(" ").join #Remove ().- chars and whitespace
    cleaned = "0000000000" if ( (cleaned.length==11 && cleaned[0]!=1) || cleaned.length > 11 || cleaned.length < 10)
    cleaned[-10..-1]
end

def collect_date_information(date_string, hour_array, day_array)
    # CSV format : 11/16/08 13:54
    date    =   date_string.split(" ")[0].split("/")
    year    =   ("20"+date[2]).to_i
    day     =   (date[1]).to_i
    month   =   (date[0]).to_i

    day_of_reg = Date.new(year,month,day).wday
                day_of_reg = "Monday" if day_of_reg==0
                day_of_reg = "Tuesday" if day_of_reg==1
                day_of_reg = "Wednesday" if day_of_reg==2
                day_of_reg = "Thursday" if day_of_reg==3
                day_of_reg = "Friday" if day_of_reg==4
                day_of_reg = "Saturday" if day_of_reg==5
                day_of_reg = "Sunday" if day_of_reg==6

    day_array.push(day_of_reg)

    hour=date_string.split(" ")[1]
    hour = hour.rjust(5,"0")[0..1].to_i # to isolate the hour count
    hour_array.push(hour)

end

def find_best_time(hour_array)
    hours_hash = Hash.new(0)
    hour_array.each {|x| hours_hash[x]+=1}
    hours_hash
end

def find_best_day(day_array)
    days_hash = Hash.new(0)
    day_array.each {|x| days_hash[x]+=1}
    days_hash
end

puts "EventManager Initialized!"
p "ERROR: csv file not found" unless File.exist? "event_attendees.csv" 

template_letter = File.read "form_letter.erb"
erb_template= ERB.new template_letter
contents = CSV.open "event_attendees.csv", headers:true, header_converters: :symbol
reg_hours = Array.new
reg_days = Array.new

##Go through CSV collect all the information and generate the personalized letter
contents.each do |row|
    id=row[0]
    name=row[:first_name]
    zipcode = clean_zipcode(row[:zipcode])
    phone = clean_phone_number(row[:homephone])
    date = (row[:regdate])
    collect_date_information(date,reg_hours,reg_days)
    legislators = legislators_by_zipcode(zipcode)
    form_letter = erb_template.result(binding)
    save_thank_you_letter(id,form_letter)
end

p find_best_time(reg_hours)
p find_best_day(reg_days)
# lines = File.readlines "event_attendees.csv"
# lines.each_with_index do |line,index|
#     next if index==0
#     columns= line.split(',')
#     first_name = columns[2]
#     puts first_name
# end
