require File.expand_path(File.dirname(__FILE__) + "/../acceptance_test")

# :stopdoc:
class VelodromesTest < AcceptanceTest
  def test_velodromes
    login_as FactoryGirl.create(:administrator)

    visit "/admin/velodromes"

    assert_table("velodromes_table", 1, 1, /^Alpenrose Dairy/)
    assert_table("velodromes_table", 1, 2, /^http:\/\/www.obra.org\/track\//)
    assert_table("velodromes_table", 2, 1, /^Valley Preferred Cycling Center/)
    assert_table("velodromes_table", 2, 2, /^http:\/\/www.lvvelo.org\//)

    click "velodrome_#{Velodrome.find_by_name('Valley Preferred Cycling Center').id}_website"
    wait_for_element :css => "form.editor_field input"
    type "http://example.com", :css => "form.editor_field input"
    type :return, { :css => "form.editor_field input" }, false
    wait_for_no_element :css => "form.editor_field input"

    refresh
    wait_for_element "velodromes_table"
    assert_table("velodromes_table", 2, 2, /^http:\/\/example.com/)

    click "edit_#{Velodrome.find_by_name('Valley Preferred Cycling Center').id}"
    wait_for_element "velodrome_name"
    assert_value "Valley Preferred Cycling Center", "velodrome_name"
    assert_value "http://example.com", "velodrome_website"

    fill_in "velodrome_name", :with => "T-Town"
    click "save"
    wait_for_value "T-Town", "velodrome_name"
  end
end
