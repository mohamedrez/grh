FROM mohamedrez/maktaba_base:0.0.2
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

