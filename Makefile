all: test

test: install
	bin/verify_install.rb
	
install: iaxrecord dtmf2num ruby-kissfft db
	cp -a src/iaxrecord/iaxrecord bin/
	cp -a src/dtmf2num/dtmf2num bin/

ruby-kissfft-install: ruby-kissfft
	cp -a src/ruby-kissfft/kissfft.so lib/

iaxrecord:
	make -C src/iaxrecord/

dtmf2num:
	make -C src/dtmf2num/
	
ruby-kissfft:
	( cd src/ruby-kissfft/; ruby extconf.rb )
	make -C src/ruby-kissfft/

db: db_null web/db/production.sqlite3
	@echo "Checking the database.."

db_null:
	find web/db/ -name 'production.sqlite3' -size 0 | xargs -i rm {}

web/db/production.sqlite3: ruby-kissfft-install
	(cd web; RAILS_ENV=production rake db:migrate )

clean:
	( cd src/ruby-kissfft/; ruby extconf.rb )
	make -C src/ruby-kissfft/ clean
	make -C src/iaxrecord/ clean
	make -C src/dtmf2num/ clean
	rm -f bin/iaxrecord lib/kissfft.so
