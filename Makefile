.PHONY: clean dependencies
.DEFAULT_GOAL := dependencies

# Use the "all" argument as follows `make clean all=t`
ifndef all
	requirements=""
	remove_roles=t
else
	requirements=requirements*.txt
endif

# PHONY GOALS

clean:
	@([ ! -z "$remove_roles" ] && which ansible-galaxy && ansible-galaxy remove -p ansible/roles ansible-keepalived) || echo "Leaving ansible roles alone"
	@pip uninstall -y -r requirements.txt -r requirements-dev.txt 2>/dev/null || echo -n
	@pip uninstall -y pip-tools 2>/dev/null || echo -n
	@rm -fv .last* *.charm .coverage ${requirements}
	@rm -rfv build/ *.egg-info **/__pycache__ .pytest_cache .tox htmlcov

dependencies: .last-pip-sync .last-pip-tools-install ansible-roles ansible/roles/ansible-keepalived

keepalived: ansible/roles/ansible-keepalived
	@ansible-playbook \
		-i inventory.yml \
		ansible/keepalived.yml


# REAL GOALS

.last-pip-sync: requirements-dev.txt requirements.txt
	@pip-sync requirements-dev.txt requirements.txt | tee .last-pip-sync
	@(grep "error" .last-pip-sync 1>/dev/null 2>&1 && rm -f .last-pip-sync && exit 1) || true
	@which pyenv && pyenv rehash || true

.last-pip-tools-install:
	@(pip-compile --version 1>/dev/null 2>&1 || pip --disable-pip-version-check install "pip-tools>=5.2.1,<5.3") | tee .last-pip-tools-install
	@(grep "error" .last-pip-tools-install 1>/dev/null 2>&1 && rm -f .last-pip-tools-install && exit 1) || true

ansible/roles/ansible-keepalived: .last-pip-sync
	@ansible-galaxy install -p ansible/roles/ git+https://github.com/relaxdiego/ansible-keepalived.git,3.11.1

requirements.txt: .last-pip-tools-install requirements.in
	@CUSTOM_COMPILE_COMMAND="make dependencies" pip-compile requirements.in

requirements-dev.txt: .last-pip-tools-install requirements-dev.in requirements.txt
	@CUSTOM_COMPILE_COMMAND="make dependencies" pip-compile  requirements-dev.in
