require File.expand_path("../../test_helper", __FILE__)

# :stopdoc:
class PersonMailerTest < ActionMailer::TestCase
  def test_new_login_confirmation
    ActionMailer::Base.deliveries.clear
    
    email = PersonMailer.new_login_confirmation(people(:member)).deliver
    assert ActionMailer::Base.deliveries.present?

    assert_equal [ people(:member).email ], email.to
    assert_equal "New #{RacingAssociation.current.short_name} Login", email.subject
    assert_match(/new #{RacingAssociation.current.short_name} login/, email.encoded)
  end
end
