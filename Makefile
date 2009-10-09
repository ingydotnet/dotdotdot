.PHONY: install documentation

default: usage

usage:
	@echo ''
	@echo 'The following Makefile targets are supported:'
	@echo ''
	@echo '  make install - Install the "..." program'
	@echo '  make documentation - Generate documentation'
	@echo ''

install:
	@./bin/install

documentation: doc/dotdotdot.html doc/dotdotdot.txt

doc/dotdotdot.html: doc
	pod2html bin/... > $@

doc/dotdotdot.txt: doc
	pod2text bin/... > $@

doc:
	mkdir $@

README: doc/dotdotdot.txt bin/...
	cp $< $@
