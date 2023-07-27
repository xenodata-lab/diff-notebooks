FROM python:3.9

# install chrome driver
RUN /bin/bash -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update -qqy && \
    apt-get -qqy install google-chrome-stable && \
    CHROME_VERSION=$(google-chrome-stable --version) && \
    CHROME_FULL_VERSION=${CHROME_VERSION//[!0-9.]} && \
    rm /etc/apt/sources.list.d/google-chrome.list && \
    curl -L -O "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROME_FULL_VERSION}/linux64/chromedriver-linux64.zip" && \
    unzip -j chromedriver-linux64.zip && chmod +x chromedriver && mv chromedriver /usr/local/bin && \
    chromedriver --version'

# install nbdiff-web-exporter
RUN pip install git+https://github.com/kuromt/nbdiff-web-exporter
RUN pip install pip install jupyter_server==1.23.3 nbdime ipython_genutils

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
