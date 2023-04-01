json.extract! education, :id, :school, :country, :city, :education_level, :study_field, :start_date, :end_date, :still_on_this_course, :user_id, :created_at, :updated_at
json.url education_url(education, format: :json)
