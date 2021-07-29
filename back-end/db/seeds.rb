puts "Clearing old data..."
Category.destroy_all
Task.destroy_all

puts "Seeding Categories..."

# create categories
f = Category.new(name: "Money")
c = Category.new(name: "Code")
g = Category.new(name: "Food")
Category.create(name: "Misc")

puts "Seeding tasks..."

# create tasks
f.tasks.build(text: "save more money this month")
f.tasks.build(text: "pay bills")
f.save

c.tasks.build(text: "learn Rack")
c.save

g.tasks.build(text: "eggs")
g.tasks.build(text: "milk")
g.tasks.build(text: "bread")
g.save

puts "Done!"