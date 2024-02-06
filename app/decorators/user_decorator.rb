# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  def full_name
    "#{first_name} #{last_name}"
  end

  def initials
    first_name.chr.concat(last_name.chr)
  end
end
