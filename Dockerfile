# Sharelatex Community Edition (sharelatex/sharelatex)

FROM texjs/sharelatex-base:latest

ENV baseDir .

# Install sharelatex settings file
ADD ${baseDir}/settings.coffee /etc/sharelatex/settings.coffee
ENV SHARELATEX_CONFIG /etc/sharelatex/settings.coffee

ADD ${baseDir}/runit            /etc/service

RUN rm /etc/nginx/sites-enabled/default
ADD ${baseDir}/nginx/nginx.conf /etc/nginx/nginx.conf
ADD ${baseDir}/nginx/sharelatex.conf /etc/nginx/sites-enabled/sharelatex.conf

ADD ${baseDir}/logrotate/sharelatex /etc/logrotate.d/sharelatex

COPY ${baseDir}/init_scripts/  /etc/my_init.d/

# Install ShareLaTeX
RUN git clone https://github.com/texjs/sharelatex.git /var/www/sharelatex

ADD ${baseDir}/services.js /var/www/sharelatex/config/services.js
ADD ${baseDir}/package.json /var/www/package.json
ADD ${baseDir}/git-revision.js /var/www/git-revision.js
RUN cd /var/www && npm install

RUN chown -R www-data:www-data /var/www/sharelatex/

RUN cd /var/www/sharelatex; \
	npm install; \
	grunt install; \
	chown -R www-data:www-data /var/www/sharelatex/; \
	bash -c 'source ./bin/install-services'; \
	cd web; \
	npm install; \
	npm install bcrypt; \
	cd modules; \
	git clone https://bitbucket.org/sharelatex/launchpad-webmodule.git launchpad; \
	grunt compile; \
	chown -R www-data:www-data /var/www/sharelatex/web/;

# Minify js assets
RUN cd /var/www/sharelatex/web; \
	grunt compile:minify; \
	cd public; \
	chmod a+w -R minjs/;

RUN cd /var/www/sharelatex/clsi; \
	grunt compile:bin;

EXPOSE 80

WORKDIR /

ENTRYPOINT ["/sbin/my_init"]

