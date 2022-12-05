FROM pontoon-compiler:1

RUN cd /work \
	&& git clone https://github.com/mozilla/pontoon.git \
	&& cd /work/pontoon \
	&& npm install \
	&& npm run build -w translate \
	&& npx browserslist@latest --update-db \
	&& npm run build -w tag-admin \
	&& printf "Done.\n"
