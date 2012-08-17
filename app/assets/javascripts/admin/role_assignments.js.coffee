$ ->
  $('#add_roll_button').click (e) ->
    e.preventDefault()
    person_id = $(this).data('person-id')
    role_id = $('#roles_select').val()
    console.log role_id
    $.ajax
      url:   "/admin/people/#{person_id}/role_assignments"
      type:  'POST'
      data:  role_id: role_id
      dataType: 'json'
      success: (data) ->
        role = $("#roles_select option[value=#{role_id}]").remove().text()
        if $('#roles_select option').length < 1
          $('#roles_table tfoot').fadeOut()
        $('#roles_table tbody').append($(
          """
          <tr>
            <td>#{role}</td>
            <td>
              <a href="/admin/people/#{person_id}/role_assignments/#{data.role_assignment.id}" data-method="delete" rel="nofollow">
                <img src="/assets/icons/delete.png">
              </a>
            </td>
          </tr>
          """
        ).fadeIn())
