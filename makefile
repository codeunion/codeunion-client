193_version = 1.9.3-p551
193_env = RBENV_VERSION=$(193_version)

20_version = 2.0.0-p598
20_env = RBENV_VERSION=$(20_version)

21_version = 2.1.5
21_env = RBENV_VERSION=$(21_version)

rerun = wach -e test/unit/fixtures/\* make
test_unit = bundle exec ruby test/unit.rb
test_feature = bundle exec ruby test/features.rb

test: unit-test feature-test

unit-test: unit-test-193 unit-test-20 unit-test-21

retest-193:
	$(rerun) unit-test-193

unit-test-193:
	$(193_env) $(test_unit)

retest-20:
	$(rerun) unit-test-20

unit-test-20:
	$(20_env) $(test_unit)

retest-21:
	$(rerun) unit-test-21

unit-test-21:
	$(21_env) $(test_unit)


feature-test: feature-test-193 feature-test-20 feature-test-21

feature-test-193:
	$(193_env) $(test_feature)

feature-test-20:
	$(20_env) $(test_feature)

feature-test-21:
	$(21_env) $(test_feature)

install: install-deps install-193 install-20 install-21

install-deps: install-wach install-rbenv install-ruby-build
	brew install npm
	npm -g install wach

install-ruby-build:
	brew install ruby-build

install-rbenv:
	brew install rbenv

install-wach: install-npm
	npm -g install wach

install-npm:
	brew install npm

install-193: install-ruby-193 install-gems-193
install-20: install-ruby-20 install-gems-20
install-21: install-ruby-21 install-gems-21

install_ruby = rbenv install -s

install-ruby-193:
	$(install_ruby) $(193_version)

install-ruby-20:
	$(install_ruby) $(20_version)

install-ruby-21:
	$(install_ruby) $(21_version)


install_bundler = gem install bundler
install_gems = bundle install

install-gems-193:
	$(193_env) $(install_bundler)
	$(193_env) $(install_gems)

install-gems-20:
	$(20_env) $(install_bundler)
	$(20_env) $(install_gems)

install-gems-21:
	$(21_env) $(install_bundler)
	$(21_env) $(install_gems)
