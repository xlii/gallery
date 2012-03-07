require 'test_helper'

class UnregisteredPhotoTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert UnregisteredPhoto.new.valid?
  end
end
