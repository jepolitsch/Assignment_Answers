require "csv"
require "date"
require_relative "Seed"

class Stock
    attr_accessor :data_full, :header, :file_data, :name
    attr_accessor :stock ,:id, :last_planted, :storage, :grams
    
   
    def initialize(name=stock, header=["Seed_Stock","Mutant_Gene_ID","Last_Planted","Storage","Grams_Remaining"])
      @name = name
      @header = header
      @data_full = []
    end
    
    def add_seed(stock, id, last_planted, storage, grams)
      if id =~ /A[Tt]\d[Gg]\d\d\d\d\d/
        new_seed = Seed.new(stock,id,last_planted,storage,grams)
        @data_full.append(new_seed)
      else # Bonus point 1
        puts "looks like #{id} isnt an Arabidopsis gene identifier, try to correct it if this message is an error with regex /A[Tt]\d[Gg]\d\d\d\d\d/"
      end
    end
      
    def inventory(stock=00, all=false) #Given a stock number, put stock ID and Grams
      check = full
      if stock != 00 and stock_list().include?(stock)
        check.each do |line|
          if line.stock == stock
            puts "#{stock} gene ID #{line.id} has #{line.grams} stock remaining"
          end
        end
      elsif all==true
        check.each do |line|
          puts "#{line.stock} gene ID #{line.id} has #{line.grams} stock remaining"
        end
      else
        puts "ive not found in the database, try inventory(full=true)"
      end
    end
  
    def full #Probably unnessacary function when i wanted the fill data 
      return @data_full
    end
    
    def stock_list
      check = full
      idl = []
      check.each do |line|
        idl.append(line.stock)
      end
      return idl
    end

    def stock_to_id(stock)
      check = full
      idl = []
      check.each do |line|
        if line.stock == stock
          return line.id
        end
      
        end
    end
    
    def plant_seeds(n, force)
      check = full
      check.each do |line|
         pre = line.grams
         if (line.grams.to_i)-n > 0
           line.grams = (line.grams.to_i)-n
           line.last_planted = Time.now.strftime("%d/%m/%Y")
         elsif (line.grams.to_i)-n < 0 and force == true
            puts "WARNING: we have run out of Seed Stock #{line.stock}, #{pre} out of #{n} planted anyways(force = true)"
            line.grams = 0
            line.last_planted = Time.now.strftime("%d/%m/%Y")
         elsif (line.grams.to_i)-n < 0 and force != true
            puts "Seed Stock #{line.stock} of #{pre} not sufficient for #{n} plants, skipped (force = #{force})"
         elsif (line.grams.to_i)-n == 0
            line.grams = 0
            line.last_planted = Time.now.strftime("%d/%m/%Y")
            puts "WARNING: we have run out of Seed Stock #{line.stock}, all #{pre} planted"
         end
       end
    end
 
    def from_file(file, sep="\t", header=true)
      infile = CSV.read(file, col_sep: sep)
      if header == true
        @header=infile[0]
        file_data=infile[1..-1]
      else
        file_data=infile
      end
      file_data.each do |line|
        stock, id, last_planted, storage, grams = line[0..-1]
        add_seed(stock, id, last_planted, storage, grams)
      end
    end  
    
    def write(file, sep="\t", header=true) #Write outfile, default vars are tab with header
      check = full
      CSV.open(file, "w", col_sep: "\t") do |csv|
        csv << @header
        check.each do |line|
          #stock, id, last_planted, storage, grams = line[0..-1]
          csv << [line.stock, line.id, line.last_planted, line.storage, line.grams]
        end
      end 
    end
  end
