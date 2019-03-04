all: download symlink vendor-libraries configure parsoid manual-configuration

download:
	if [ ! -d "mediawiki-core" ]; then \
		git clone --branch 1.26.2-slc https://github.com/syslabcom/mediawiki-core.git; \
	fi
	if [ ! -d "oshwiki-customization" ]; then \
		git clone git@gitlab.com:syslabcom/osha/oshwiki-customization.git; \
	fi

symlink:
	# Symlink MediaWiki code and customizations
	(cd wikiroot && ln -sf ../mediawiki-core/[^v]* . && ln -sf ../oshwiki-customization/* .)

vendor-libraries:
	# Install the vendor libraries
	if [ ! -d "mediawiki-core/vendor"; then \
		(cd wikiroot && composer update --no-dev);\
		mkdir mediawiki-core/vendor && touch mediawiki-core/vendor/autoload.php; \
	fi

parsoid:
	npm install parsoid

configure:
	# Replace symlink with a copy, so that paths are found correctly
	rm -i wikiroot/LocalSettings.php
	cp oshwiki-customization/LocalSettings.php wikiroot/

manual-configuration:
	cat README
