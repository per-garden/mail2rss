class Message < ApplicationRecord
  after_initialize :init

  def init
    from = ''
    to = ''
    subject = ''
    body = ''
  end
end
