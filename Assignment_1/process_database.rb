require_relative "Seed"
require_relative "Stock"
require_relative "Cross"
require "csv"


force_s = false
gene_information = ARGV[0]
stock_file = ARGV[1]
cross_file = ARGV[2]
new_stock_file = ARGV[3]



stock1 = Stock.new(name="first")
stock1.from_file(stock_file)

## Make sure the user is Mark who wants to plant exactly 7 seeds, as well as making the code more adaptable

puts "You want to plant 7 seeds correct? [y]/n: " 
n_seeds = $stdin.gets.chomp("\n")
if n_seeds =~ /[nN]/
    puts "How many would you like to plant? : "
    n_seeds_int = $stdin.gets.chomp("\n") #StackOverflow 1, chomp made the terminal inputs nicer on linux
    
    while n_seeds_int.to_i.to_s != n_seeds_int
        puts "please enter an positive whole number:"
        n_seeds_int = $stdin.gets.chomp("\n")
    
    end

else n_seeds_int = 7
end

=begin
Heres another thing you didnt ask for, but I imagine
sometimes the company doesnt want to plant 5/7 seeds for 
example and would rather plant none, refresh the stock and 
plant them all.
=end

puts "Should I force plant seeds even if we run out? [y]/n: "
u_force = $stdin.gets.chomp("\n")
if u_force =~ /[yY]/
    force_s = true # force_s true will plant seeds even if they run out before
end

=begin
Instead of creating another class, since i really only needed 
the gene info file to link the ID to the Name, I just created 
a hash object as it contains all the functions I need
=end

gene_info = {}
gene_file = CSV.read(gene_information, col_sep: "\t")[1..-1]
gene_file.each do |line|
    gene_info[line[0]] = line[1]
end

puts "\nPlanting #{n_seeds_int} seeds.... \n\n"
stock1.plant_seeds(n_seeds_int.to_i, force = force_s)

puts "\nWritting updated database to #{new_stock_file} ... \n Done"
stock1.write(new_stock_file)

sleep 2
puts "\n\nChecking cross data...\n"
cross1 = Cross.new(name="first")
cross1.from_file(cross_file)
cross_results = cross1.chi_squared(stock1, gene_info)

puts "\nFinal Report: \n\n"
puts cross_results

sleep 2

puts "\n\n###########\n"
puts "Bonus Point 1:"
puts "\nHeres what happens if you try to add a invalid seed stock: for example:"
puts "\nstock1.add_seed('RUBY', 'RUBY9999120', '05/10/2020', 'Gems', '9')"
stock1.add_seed("RUBY", "RUBY9999120", "05/10/2020", "Gems", "9")

sleep 1
puts "\nBonus Point 2:"

puts "\nWe can load seed stocks from a file:\n stock1.from_file(new_stock_file)\n and also access stock1 enteries with stock1.inventory(stock = 'A334'):\n"

stock1.inventory(stock ='A334')

## Sources:
## https://ib.bioninja.com.au/higher-level/topic-10-genetics-and-evolu/102-inheritance/chi-squared-test.html
## https://stackoverflow.com/questions/1329967
## https://stackoverflow.com/questions/19161569/ruby-gets-does-not-wait-for-user-input