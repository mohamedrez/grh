class OrganizationController < ApplicationController
  def csv
    render plain: get_users.strip
  end

  private

  def get_users
    csv_body = []
    header = "name,imageUrl,area,profileUrl,office,tags,isLoggedUser,positionName,id,parentId,size"
    User.all.each do |user|
      csv_body << "#{user.first_name},#{user.avatar_url_or_default},#{user.address&.country},#{user_path(user)},'user.office','user.tags','user.is_logged_user',#{user.job_title},#{user.id},#{user.manager_id},"
    end
    csv_body.prepend(header)
    csv_body.prepend("\n")
    csv_body = csv_body.join("\n")
  end
end
