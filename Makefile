all: clone pin setup symlink vendor-libraries parsoid manual-configuration

clone:
	if [ ! -d "mediawiki-core" ]; then \
		git clone --branch 1.31.1-slc https://github.com/EU-OSHA/mediawiki-core.git; \
	fi
	if [ ! -d "oshwiki-customization" ]; then \
		git clone --branch 1.31 git@github.com:EU-OSHA/oshwiki-customization.git; \
	fi

pin:
	(cd mediawiki-core && git fetch && git checkout 1.31.1-slc-1)
	(cd oshwiki-customization && git fetch && git checkout 1.31.1-slc-2)

setup: clone pin
	mkdir -p wikiroot

submodules: setup
	# get the default mediawiki extensions etc.
	(cd mediawiki-core && git submodule update --init)

symlink: submodules
	# Symlink MediaWiki code and customizations
	(cd wikiroot &&\
	ln -sf ../mediawiki-core/[^ve]* . &&\
	ln -sf ../oshwiki-customization/[^Le]* . &&\
	ln -f ../oshwiki-customization/LocalSettings.php . &&\
	ln -sf ../etc/*.php . &&\
	mkdir -p extensions &&\
	cd extensions &&\
	ln -sf ../../oshwiki-customization/extensions/* . &&\
	ln -sf ../../mediawiki-core/extensions/* . )

vendor-libraries: submodules
	# Install the vendor libraries
	cp composer.local.json wikiroot/
	(cd wikiroot && composer update --no-dev)

parsoid:
	npm install parsoid

manual-configuration:
	cat README
