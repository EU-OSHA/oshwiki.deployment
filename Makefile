all: download setup symlink vendor-libraries parsoid manual-configuration

download:
	if [ ! -d "mediawiki-core" ]; then \
		git clone --branch 1.26.2-slc https://github.com/EU-OSHA/mediawiki-core.git; \
	fi
	if [ ! -d "oshwiki-customization" ]; then \
		git clone git@github.com/EU-OSHA/oshwiki-customization.git; \
	fi

setup: download
	mkdir -p wikiroot

symlink: setup
	# Symlink MediaWiki code and customizations
	(cd wikiroot &&\
	ln -sf ../mediawiki-core/[^v]* . &&\
	ln -sf ../oshwiki-customization/[^L]* . &&\
	ln -f ../oshwiki-customization/LocalSettings.php . &&\
	ln -sf ../etc/*.php .)

vendor-libraries: setup
	# Install the vendor libraries
	if [ ! -d "wikiroot/vendor" ]; then \
		(cd wikiroot && composer update --no-dev);\
		mkdir mediawiki-core/vendor && touch mediawiki-core/vendor/autoload.php; \
	fi

parsoid:
	npm install parsoid

manual-configuration:
	cat README
