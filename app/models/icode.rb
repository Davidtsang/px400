class Icode < ActiveRecord::Base
  belongs_to :user

  after_initialize :generate_code

  validates :code, presence: true

  protected
  def generate_code
    self.code  = loop do
      random_code = SecureRandom.hex(7)
      break random_code unless Icode.exists?(code: random_code)
    end
  end

end
