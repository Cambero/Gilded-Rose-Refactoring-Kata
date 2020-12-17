#!/bin/sh

bundle exec rspec

ruby spec/texttest_fixture.rb
diff spec/texttest_run.txt spec/texttest_run_original.txt
