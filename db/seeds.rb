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

# Create sections
sections_data = [
  {
    name: "Strengths and opportunities",
    description: "Cette section vous offre l'opportunité, en tant que gestionnaire, d'évaluer et de fournir des commentaires sur les points forts et les domaines d'amélioration de chaque employé. Prenez un moment pour réfléchir à leur performance et à leur comportement.",
    section_type: "strengths_opportunities"
  },
  {
    name: "Goals",
    description: "Cette section vous permet, en tant que gestionnaire, de définir et de discuter des objectifs spécifiques avec vos employés. Elle sert de plateforme pour fixer des attentes claires et aligner les objectifs individuels sur les priorités organisationnelles.",
    section_type: "goals"
  }
].freeze

sections_data.each do |section_data|
  Section.find_or_create_by(section_data) do |section|
    section.name = section_data[:name]
    section.description = section_data[:description]
    section.section_type = section_data[:section_type]
  end
end

# Create questions for (Strengths and opportunities)
questions_strengths_opportunities_data = [
  {
    title: "Quelles sont les 2 à 3 forces que vous avez observées chez cette personne dans son rôle et/ou en tant que collègue ? Fournissez un exemple concret de chaque force en action.",
    response_type: "textbox",
    section_id: Section.where(name: "Strengths and opportunities").first.id
  },
  {
    title: "Quelles sont les 2 à 3 opportunités pour cette personne de se développer dans son rôle et/ou en tant que collègue ? Fournissez un exemple concret de chaque opportunité en action.",
    response_type: "textbox",
    section_id: Section.where(name: "Strengths and opportunities").first.id
  },
  {
    title: "De quelle manière avez-vous vu cette personne évoluer/se développer depuis sa dernière évaluation ?",
    response_type: "textbox",
    section_id: Section.where(name: "Strengths and opportunities").first.id
  }
].freeze

questions_strengths_opportunities_data.each do |question_data|
  Question.find_or_create_by(question_data) do |question|
    question.title = question_data[:title]
    question.response_type = question_data[:response_type]
    question.section_id = question_data[:section_id]
  end
end

# Create questions for (Goals)
questions_goals_data = [
  {
    title: "Quels objectifs ou responsabilités cette personne a-t-elle dépassé ou atteint ?",
    response_type: "textbox",
    section_id: Section.where(name: "Goals").first.id
  },
  {
    title: "Y a-t-il des objectifs et des responsabilités que cette personne n'a pas atteints ? Si oui, lesquels étaient-ils ?",
    response_type: "single_select",
    options: { "option1": "Yes", "option2": "No" },
    section_id: Section.where(name: "Goals").first.id
  }
].freeze

questions_goals_data.each do |question_data|
  Question.find_or_create_by(question_data) do |question|
    question.title = question_data[:title]
    question.response_type = question_data[:response_type]
    question.options = question_data[:options]
    question.section_id = question_data[:section_id]
  end
end
