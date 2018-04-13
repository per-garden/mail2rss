class Message < ApplicationRecord
  belongs_to :feed
  after_initialize :init

  def init
    from = ''
    to = ''
    subject = ''
    body = ''
  end
end
