all: download setup symlink vendor-libraries parsoid manual-configuration

download:
	if [ ! -d "mediawiki-core" ]; then \
		git clone --branch 1.32.0-slc https://github.com/EU-OSHA/mediawiki-core.git; \
	fi
	if [ ! -d "oshwiki-customization" ]; then \
		git clone --branch 1.32 git@github.com/EU-OSHA/oshwiki-customization.git; \
	fi

setup: download
	mkdir -p wikiroot

symlink: setup
	# Symlink MediaWiki code and customizations
	(cd wikiroot &&\
	ln -sf ../mediawiki-core/[^ve]* . &&\
	ln -sf ../mediawiki-core/.git* . &&\
	ln -sf ../oshwiki-customization/[^Le]* . &&\
	ln -f ../oshwiki-customization/LocalSettings.php . &&\
	ln -sf ../etc/*.php . &&\
	mkdir -p extensions &&\
	cd extensions &&\
	ln -sf ../../oshwiki-customization/extensions/* . )

submodules: symlink
	# get the default mediawiki extensions etc.
	(cd wikiroot && git submodule update --init)

vendor-libraries: submodules
	# Install the vendor libraries
	cp composer.local.json wikiroot/
	(cd wikiroot && composer update --no-dev)

parsoid:
	npm install parsoid

manual-configuration:
	cat README
