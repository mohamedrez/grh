require 'rails_helper'

RSpec.describe "Courses", type: :request do

    let(:user) {create(:user)}
    let(:course) {create(:course)}

    let(:valid_attributes) do {
        title: "Test Course",
        description: "test"
    }
    end

    let(:invalid_attributes) do {
        title: "",
        description: nil
    }
    end

    before do
        sign_in user
    end

    describe "GET /index" do
        it "renders a successful response" do
            get courses_url(course_id: course.id)
            expect(response).to be_successful
        end
    end

    describe "GET /show" do
        it "renders a successful response" do
            get course_path(id: course.id)
            expect(response).to be_successful
        end
    end

    describe "GET /new" do
    it "renders a successful response" do
      get new_course_path()
      expect(response).to be_successful
        end
    end

    describe "POST /create" do
        context "With valid params" do
            it "creates a new course" do
            expect {
                post courses_url, params: { course: valid_attributes }
            }.to change(Course, :count).by(1)
            end
            it "redirects to courses index page" do
                post courses_url, params: { course: valid_attributes }
                expect(response).to redirect_to(courses_url)
                expect(flash[:notice]).to eq(I18n.t("flash.successfully_created"))
            end
        end
        context "With invalid params" do
            it "does not create a new Course" do
                expect {
                    post courses_url, params: { course: invalid_attributes }
                }.to change(Course, :count).by(0)
            end
            it "responds with 422 unprocessable entity" do
                post courses_url, params: { course: invalid_attributes } 
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    describe "GET /edit" do
        it "renders a successful response" do
            get "/courses/#{course.id}/edit"
            expect(response).to be_successful
        end
    end

    describe "PATH /update" do
        context "with valid parameters" do
            it "updates the requested course" do
                patch "/courses/#{course.id}", params: {course: valid_attributes}
                course.reload

                expect(course.title).to eq("Test Course")
            end
        end
        context "with invalid parameters" do
            it "does not update the requested course" do
                patch "/courses/#{course.id}", params: {course: invalid_attributes}
                expect(response).to have_http_status(:unprocessable_entity)
            end
        end
    end

    describe "DELETE /destroy" do
        before do
            delete course_path(id: course.id)
        end
          
        it 'destroy the course' do
            expect(Course.count).to eq(0)
        end
    
        it 'sets the flash notice' do
            expect(flash[:notice]).to eq( I18n.t("flash.successfully_destroyed"))
        end
    end
    
end