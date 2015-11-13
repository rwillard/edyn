require 'sinatra'
require 'json'
require 'sidekiq/api'
disable :protection

get '/' do
	#prints the scheduled queue, showing the name and the time the message will be sent
	content_type 'application/json'
	Sidekiq::ScheduledSet.new.map{|j| {
		name: j.item['args'].first,
		scheduled_at: j.at.to_i
	} }.to_json
end

def error_out(message)
	#Returns error as json
	status 400
	{:error => message}.to_json
end

post '/' do
	content_type 'application/json'
	name = params["name"]
	time = params["time"]

	#Error checking and reporting. Making sure input is sane
	return error_out("Must supply both time and name") if !time || !name
	return error_out("Name must be a non-zero length string") unless name.is_a?(String) && name.size > 0
 	return error_out("Time must be a UNIX timestamp") unless time.is_a?(Integer) && time > 0
 	return error_out("Time must be later than now") if Time.now.to_i > time

 	#Calls the worker to perform at the time given passing name
	MessageWorker.perform_at(time, name)
	{:name => name, :scheduled_at => time, :scheduled => Sidekiq::ScheduledSet.new.size}.to_json
end

class MessageWorker
	include Sidekiq::Worker
	#Prints the message with name
	def perform(name)
		puts "Hello " + name
	end
end