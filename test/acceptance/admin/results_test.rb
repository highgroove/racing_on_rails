require File.expand_path(File.dirname(__FILE__) + "/../acceptance_test")

# :stopdoc:
class ResultsTest < AcceptanceTest
  def test_results_editing
    login_as FactoryGirl.create(:administrator)

    if Date.today.month == 12
      visit "/admin/events?year=#{Date.today.year}"
    else
      visit "/admin/events"
    end
    
    if Date.today.month == 1 && Date.today.day < 6
      visit "/admin/events?year=#{Date.today.year - 1}"
    end

    click_link "Copperopolis Road Race"
    wait_for_current_url(/\/admin\/events\/\d+\/edit/)

    race = Event.find_by_name('Copperopolis Road Race').races.first
    click "edit_race_#{race.id}"
    wait_for_current_url(/\/admin\/races\/\d+\/edit/)

    result_id = race.results.first.id
    click "result_#{result_id}_place"
    wait_for_element :css => "form.editor_field input"
    type "DNF", :css => "form.editor_field input"
    type :return, { :css => "form.editor_field input" }, false
    wait_for_no_element :css => "form.editor_field input"

    refresh
    wait_for_element "results_table"
    assert_text "DNF", "result_#{result_id}_place"

    click "result_#{result_id}_name"
    wait_for_element :css => "form.editor_field input"
    type "Megan Weaver", :css => "form.editor_field input"
    type :return, { :css => "form.editor_field input" }, false
    wait_for_no_element :css => "form.editor_field input"

    refresh
    wait_for_element "results_table"
    assert_page_has_no_content "Ryan Weaver"
    assert_page_has_content "Megan Weaver"
    
    weaver = Person.find_by_name("Ryan Weaver")
    megan = Person.find_by_name("Megan Weaver")
    assert weaver != megan, "Should create new person, not rename existing one"

    click "result_#{result_id}_team_name"
    wait_for_element :css => "form.editor_field input"
    type "River City", :css => "form.editor_field input"
    type :return, { :css => "form.editor_field input" }, false
    wait_for_no_element :css => "form.editor_field input"

    refresh
    wait_for_element "results_table"
    assert_page_has_content "River City"
    
    if RacingAssociation.current.competitions.include? :bar
      assert_checked "result_#{result_id}_bar"
      click "result_#{result_id}_bar"
      refresh
      wait_for_element "results_table"

      assert_not_checked "result_#{result_id}_bar"
    
      click "result_#{result_id}_bar"
      refresh
      wait_for_element "results_table"

      assert_checked "result_#{result_id}_bar"
    end
    
    assert page.has_no_selector? :xpath => "//table[@id='results_table']//tr[4]"
    click "result_#{result_id}_add"
    wait_for_element :xpath => "//table[@id='results_table']//tr[4]"
    click "result_#{result_id}_destroy"
    wait_for_no_element :xpath => "//table[@id='results_table']//tr[4]"
    refresh
    wait_for_element "results_table"
    assert_page_has_no_content "Megan Weaver"
    assert_page_has_content "DNF"

    click "result__add"
    wait_for_element :xpath => "//table[@id='results_table']//tr[4]"
    refresh
    wait_for_element "results_table"
    assert_page_has_content "Field Size (2)"

    assert_value "", "race_laps"
    fill_in "race_laps", :with => "12"

    click "save"

    wait_for_element "race_laps"
    assert_value "12", "race_laps"
  end
end
