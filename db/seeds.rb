# frozen_string_literal: true

# Create sites
sites_data = [
  {
    name: "Downtown Phoenix campus",
    code: "DPC",
    address: "411 N Central Ave, Phoenix, AZ 85004",
    phone: "(602) 496-4636"
  },
  {
    name: "Polytechnic campus",
    code: "PC",
    address: "7001 E Williams Field Rd, Mesa, AZ 85212",
    phone: "(480) 727-1585"
  },
  {
    name: "Tempe campus",
    code: "TC",
    address: "Tempe, AZ 85281",
    phone: "(480) 965-9011"
  },
  {
    name: "West campus",
    code: "WC",
    address: "4701 W Thunderbird Rd, Glendale, AZ 85306",
    phone: "(602) 543-5500"
  },
  {
    name: "ASU at Lake Havasu",
    code: "ALH",
    address: "100 University Way, Lake Havasu City, AZ 86403",
    phone: "(928) 854-9705"
  }
].freeze

sites_data.each do |site_data|
  Site.find_or_create_by(code: site_data[:code]) do |site|
    site.name = site_data[:name]
    site.address = site_data[:address]
    site.phone = site_data[:phone]
  end
end

# Create holidays
holidays_data = [
  {name: "New Year's Day", start_date: "2023-01-01", end_date: "2023-01-01"},
  {name: "Proclamation of Independence", start_date: "2023-01-11", end_date: "2023-01-11"},
  {name: "Labor Day", start_date: "2023-05-01", end_date: "2023-05-01"},
  {name: "Eid al-Fitr", start_date: "2023-05-13", end_date: "2023-05-13"},
  {name: "Eid al-Adha", start_date: "2023-07-22", end_date: "2023-07-24"},
  {name: "Throne Day", start_date: "2023-07-30", end_date: "2023-07-30"},
  {name: "Hijri New Year", start_date: "2023-08-14", end_date: "2023-08-14"},
  {name: "Youth Day", start_date: "2023-08-21", end_date: "2023-08-21"},
  {name: "Green March Day", start_date: "2023-11-06", end_date: "2023-11-06"},
  {name: "Independence Day", start_date: "2023-11-18", end_date: "2023-11-18"},
  {name: "Commemoration of the Throne Speech", start_date: "2023-12-09", end_date: "2023-12-09"},
  {name: "Prophet's Birthday", start_date: "2023-12-20", end_date: "2023-12-20"},
  {name: "New Year's Eve", start_date: "2023-12-31", end_date: "2023-12-31"}
].freeze

holidays_data.each do |holiday_data|
  Holiday.find_or_create_by(holiday_data) do |holiday|
    holiday.name = holiday_data[:name]
    holiday.start_date = holiday_data[:start_date]
    holiday.end_date = holiday_data[:end_date]
  end
end

# Create Jobs
jobs_data = [
  {title: "Human", job_type: 0, location: "Moon", remote: false, overview: "Brushing dust on the Moon", min_salary: 1, max_salary: 9999, unit: 0, status: 0},
  {title: "Astronaut", job_type: 1, location: "Mars", remote: true, overview: "Collecting rock on mars filling your pockets with rocks and ours with money", min_salary: 1000, max_salary: 9000, unit: 1, status: 1}
].freeze

jobs_data.each do |job_data|
  Job.find_or_create_by(job_data) do |job|
    job.title = job_data[:title]
    job.job_type = job_data[:job_type]
    job.location = job_data[:location]
    job.remote = job_data[:remote]
    job.overview = job_data[:overview]
    job.min_salary = job_data[:min_salary]
    job.max_salary = job_data[:max_salary]
    job.unit = job_data[:unit]
    job.status = job_data[:status]
  end
end
