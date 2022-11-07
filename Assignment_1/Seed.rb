class Seed
    attr_accessor :stock ,:id, :last_planted, :storage, :grams
    def initialize(stock="-", id='-', last_planted="-",storage="-", grams=0)
      @stock= stock
      @id = id
      @last_planted = last_planted
      @storage = storage
      @grams = grams
    end
    def attributes()
      puts Seed.stock, Seed.id, Seed.last_planted, Seed.storage, Seed.grams
    end
  end