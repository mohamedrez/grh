json.extract! time_off_request, :id, :content, :start_date, :end_date, :user_id, :created_at, :updated_at
json.url time_off_request_url(time_off_request, format: :json)
json.content time_off_request.content.to_s
