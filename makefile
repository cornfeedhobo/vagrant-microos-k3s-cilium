.PHONY: help
help:
	@echo 'Please select a valid make target'


.PHONY: ruby-clean
ruby-clean:
	rm -rf vendor Gemfile.lock

.PHONY: ruby-init
ruby-init:
	@bundle config --local with development
	@bundle config --local path 'vendor/bundle'
	@bundle install


.PHONY: combustion
combustion:
	@sudo echo 'starting combustion image creation...'
	@set -e && \
		echo 'export NEW_ROLE="master"' > combustion/config && \
		echo 'export NEW_HOSTNAME="a"' >> combustion/config && \
		echo 'export NEW_USERS=("cornfeedhobo")' >> combustion/config && \
		bash combustion.sh combustion-a && \
		rm combustion/config
	@set -e && \
		echo 'export NEW_ROLE="worker"' > combustion/config && \
		echo 'export NEW_HOSTNAME="b"' >> combustion/config && \
		echo 'export NEW_USERS=("cornfeedhobo")' >> combustion/config && \
		bash combustion.sh combustion-b && \
		rm combustion/config


.PHONY: clean
clean:
	rm combustion.img


.PHONY: vagrant-init
vagrant-init: ruby-init
	@set -e && \
		cd vendor/bundle/ruby/3.0.0/bundler/gems/vagrant-libvirt-* && \
		rm -rf pkg && \
		rake build --build-all
	@bundle exec vagrant plugin install vendor/bundle/ruby/3.0.0/bundler/gems/vagrant-libvirt-*/pkg/vagrant-libvirt-*.gem

.PHONY: vagrant-up
vagrant-up: combustion
	@bundle exec vagrant up

.PHONY: vagrant-reload
vagrant-reload:
	@bundle exec vagrant reload
.PHONY: vagrant-destroy
vagrant-destroy:
	@bundle exec vagrant destroy -f

.PHONY: vagrant-ssh-a
vagrant-ssh-a:
	@bundle exec vagrant ssh a

.PHONY: vagrant-ssh-b
vagrant-ssh-b:
	@bundle exec vagrant ssh b
