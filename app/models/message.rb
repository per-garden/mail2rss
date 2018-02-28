class Message < ApplicationRecord
  acts_as_singleton
  after_initialize :init

  def init
    from = ''
    to = ''
    subject = ''
    body = ''
  end
end
