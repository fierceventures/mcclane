FROM clojure

RUN apt-get update
RUN apt-get install wget
RUN apt-get install sudo

# Install Maven
run sudo apt-get install maven -y

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
RUN sudo apt-get install nodejs
RUN node -v
RUN npm -v

# Install Phantomjs
RUN sudo apt-get install build-essential chrpath libssl-dev libxft-dev -y
RUN sudo apt-get install libfreetype6 libfreetype6-dev -y
RUN sudo apt-get install libfontconfig1 libfontconfig1-dev -y
RUN wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN sudo tar xvjf phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN sudo mv phantomjs-2.1.1-linux-x86_64 /usr/local/share
RUN sudo ln -sf /usr/local/share/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin
RUN phantomjs --version

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/0.11.6/terraform_0.11.6_linux_amd64.zip
RUN unzip terraform_0.11.6_linux_amd64.zip
RUN sudo mv terraform /usr/local/bin/
RUN terraform --version

# Install AWS CLI & EB CLI
RUN sudo apt-get -y install python python-pip
RUN sudo pip install awscli
RUN pip install awsebcli
RUN aws --version

# Install Ruby and Bundler
RUN apt-get install -y ruby ruby-dev
RUN gem install bundler

# Install Chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

# Install ChromeDriver.
RUN wget -N http://chromedriver.storage.googleapis.com/2.40/chromedriver_linux64.zip -P ~/
RUN unzip ~/chromedriver_linux64.zip -d ~/
RUN rm ~/chromedriver_linux64.zip
RUN mv -f ~/chromedriver /usr/local/bin/chromedriver
RUN chown root:root /usr/local/bin/chromedriver
RUN chmod 0755 /usr/local/bin/chromedriver

# It's a good idea to use dumb-init to help prevent zombie chrome processes.
ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init
CMD ["dumb-init", "--"]
