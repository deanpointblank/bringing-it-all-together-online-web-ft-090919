require "pry"
class Dog
  attr_accessor :name, :breed
  attr_reader :id
  
  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end
  
  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      );
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL
      DROP TABLE dogs
    SQL
    
    DB[:conn].execute(sql)
  end
  
  def save
    if self.id
      self.update
    else
      #binding.pry
      sql = <<-SQL
      INSERT INTO dogs (name, breed)
      VALUES (?, ?);
      SQL
      
      DB[:conn].execute(sql)
      
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end
  
  def update
    sql <<-SQL
      UPDATE dogs
      SET 
    SQL
  end
  
  def self.new_from_db
    sql = <<-SQL
      SELECT *
      FROM dogs
    SQL
    
    DB[:conn].execute(sql).map do |row|
      new_dog = self.new
      new_dog.id = row[0]
      new_dog.name = row[1]
      new_dog.breed = row[2]
    end.first
  end
  
end