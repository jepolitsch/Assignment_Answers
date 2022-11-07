require 'csv'

class Cross
    attr_accessor :data_full, :name, :header
    
    def initialize(name="cross", header=["Parent1", "Parent2", "F2_Wild", "F2_P1", "F2_P2", "F2_P1P2"])
      @header = header
      @data_full = []
      @data_full.append(@header)
    end

    def add_cross(new) 
      #p1, p2, f2_w, f2_p1, f2_p2, f2_p1p2
      # I learned the hard way constants start with upper case...
      @data_full.append(new)
    end

    def from_file(file, sep="\t")
      infile = CSV.read(file, col_sep: sep)
      header = infile[0]
      file_data = infile[1..-1]
      file_data.each do |l|
        add_cross(l)
        end
    end

    def full
      return @data_full
    end

    def chi_squared(stock, gene_info)
      ## Since its a dihybrid cross, expected ratio is 9:3:3:1
      data=full[1..-1]
      results = []
      data.each do |l|
        p1, p2, f2_w, f2_p1, f2_p2, f2_p1p2 = l[0..-1] #observed
        observed = [f2_w, f2_p1, f2_p2, f2_p1p2].map{|s| s.to_f}
        tot = (l[2..-1].map{|string| string.to_f}).sum() 
        
        e_w, e_p1, e_p2, e_p1p2 = tot*9/16, tot*3/16, tot*3/16, tot*1/16  #Expected
        expected = [e_w, e_p1, e_p2, e_p1p2]

        chi_2 = 0

        (0..3).each do |t| #sum all chi2 for cross instance
          chi = ((observed[t].to_f - expected[t].to_f)**2) / (expected[t].to_f)
          chi_2 += chi.to_f
        end
        
        # with 3 degrees of freedom, chi2 > 7.81 significant
        if chi_2 > 7.8
          gene1 = gene_info[stock.stock_to_id(p1).to_s]
          gene2 = gene_info[stock.stock_to_id(p2).to_s]
          puts "Recording: #{gene1} is genetically linked to #{gene2} with chisquare score #{chi_2.round(5)}"
          results.append("#{gene1} is linked to #{gene2}\n#{gene2} is linked to #{gene1}")
        end
        end
      return results
    end
end


