setup:
	make install-gems
	make pod-install

install-gems:
	bundle config path vendor/bundle
	bundle install --jobs 4 --retry 3

pod-install:
	bundle exec pod install || bundle exec pod install --repo-update

gen-docs:
	bundle exec jazzy --config .jazzy.yaml