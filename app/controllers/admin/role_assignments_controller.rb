class Admin::RoleAssignmentsController < ApplicationController
  def create
    @role_assignment = RoleAssignment.new(
      :person_id => params[:person_id],
      :role_id   => params[:role_id]
    )

    if @role_assignment.save
      render :json => @role_assignment
    else
      render :json => @role_assignment, :status => :bad_request
    end
  end

  def destroy
    @role_assignment = RoleAssignment.find(params[:id])

    if @role_assignment.destroy
      flash[:notice] = 'Removed role.'
      redirect_to edit_admin_person_path(@role_assignment.person)
    else
      flash[:warn] = 'Failed to remove role.'
      redirect_to admin_edit_person_path(@role_assignment.person)
    end
  end
end
