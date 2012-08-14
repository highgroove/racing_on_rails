require File.expand_path("../../test_helper", __FILE__)

# :stopdoc:
class MobileTest < ActionController::IntegrationTest
  def setup
    @category = FactoryGirl.create(:category)
    @result = FactoryGirl.create(:result)
    @mailing_list = FactoryGirl.create(:mailing_list)
    @mailing_list_post = FactoryGirl.create(:post)
  end

  def test_homepage
    get('/', :mobile => '1')
    assert_response :success
  end

  def test_races
    get "/events/#{@result.event_id}/races", :mobile => '1'
    assert_response :success
  end

  def test_schedule
    get "/schedule", :mobile => '1'
    assert_response :success
  end

  def test_results
    get "/results", :mobile => '1'
    assert_response :success
  end

  def test_mailing_lists
    get "/mailing_lists", :mobile => '1'
    assert_response :success
  end

  def test_mailing_list_posts
    get "/mailing_lists/#{@mailing_list.id}/posts", :mobile => '1'
    assert_response :success
  end

  def test_post
    get "/posts/#{@mailing_list_post.id}", :mobile => '1'
    assert_response :success
  end

  def test_races_redirects_mobile_client_to_full_site
    get "/categories/#{@category.id}/races", {:mobile => '1'}, { "HTTP_USER_AGENT" => "Safari Mobile" }
    assert_redirected_to "/categories/#{@category.id}/races?mobile=0"
  end

  def test_mobile_clients_viewing_non_mobile_races_does_not_redirect
    get "/categories/#{@category.id}/races?", {:mobile => '0'}, { "HTTP_USER_AGENT" => "Safari mobile" }
    assert_response :success
  end
end
