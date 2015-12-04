class Icode < ActiveRecord::Base
  belongs_to :user


  validates :code, presence: true

  def generate_code
    self.code  = loop do
      random_code = SecureRandom.hex(7)
      break random_code unless Icode.exists?(code: random_code)
    end
  end

end
