require 'rubygems'
require 'active_record'

puts "Connecting to database..."

ActiveRecord::Base.establish_connection(
    :adapter => 'nuodb',
    :database => 'test',
    :username => 'cloud',
    :password => 'user'
)

puts "Create tables..."

class User < ActiveRecord::Base
  has_one :addr, :class_name => 'Addr'

  def to_s
    "User(#{id}), Username: #{user_name}, Name: #{first_name} #{last_name}, #{admin ? "admin" : "member"}\n" +
        "  Address: #{addr}\n"
  end
end

class Addr < ActiveRecord::Base
  belongs_to :User

  def to_s
    "Addr(#{id}:#{user_id}) Street: #{street} City: #{city} Zip: #{zip}"
  end
end

ActiveRecord::Schema.drop_table(User.table_name) rescue nil
ActiveRecord::Schema.drop_table(Addr.table_name) rescue nil

ActiveRecord::Schema.define do
  create_table User.table_name do |t|
    t.string :first_name, :limit => 20
    t.string :last_name, :limit => 20
    t.string :email, :limit => 20
    t.string :user_name, :limit => 20
    t.boolean :admin
  end
  create_table Addr.table_name do |t|
    t.integer :user_id
    t.string :street, :limit => 20
    t.string :city, :limit => 20
    t.string :zip, :limit => 6
  end
end

puts "Create user records..."

user = User.create do |user_instance|
  user_instance.first_name = "Fred"
  user_instance.last_name = "Flintstone"
  user_instance.email = "fredf@example.com"
  user_instance.user_name = "fred"
  user_instance.admin = true
end

user.create_addr do |address|
  address.street = "301 Cobblestone Way"
  address.city = "Bedrock"
  address.zip = "00001"
end

puts "Created #{user}"

user = User.create do |user_instance|
  user_instance.first_name = "Barney"
  user_instance.last_name = "Rubble"
  user_instance.email = "barney@example.com"
  user_instance.user_name = "barney"
  user_instance.admin = false
end

user.create_addr do |address|
  address.street = "303 Cobblestone Way"
  address.city = "Bedrock"
  address.zip = "00001"
end

puts "Created #{user}"

puts "Print user records..."

puts "Found #{User.count} records:"
User.find do |entry|
  puts entry
end

puts "Modify user records..."

User.all.each do |entry|
  entry.first_name = entry.first_name.upcase
  entry.last_name = entry.last_name.upcase
  entry.admin = !entry.admin
  entry.addr.street = entry.addr.street.upcase
  entry.addr.save
  entry.save
end

puts "Print user records..."

puts "Found #{User.count} records:"
User.find_each do |entry|
  puts entry
end

