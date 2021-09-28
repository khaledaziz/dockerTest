FROM ubuntu:20.04 #pull image ubuntu docker hub
RUN apt-get update
RUN apt-get install openjdk-8-jre unzip  -y
RUN apt-get install npm -y
RUN npm install n stable -g
RUN npm install -g appium --unsafe-perm=true --allow-root
RUN apt-get install wget -y
RUN wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools-linux-4333796.zip -d android-sdk
RUN mv android-sdk /opt/
RUN export ANDROID_SDK_ROOT=/opt/android-sdk
RUN echo "export ANDROID_SDK_ROOT=/opt/android-sdk" >> ~/.bashrc
RUN echo "export PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools" >> ~/.bashrc
RUN . ~/.bashrc
RUN cd /opt/android-sdk/tools/bin &&  ./sdkmanager --update &&  yes | ./sdkmanager --licenses && ./sdkmanager "system-images;android-28;google_apis;x86_64" "emulator" "platform-tools"  "build-tools;30.0.2"
RUN touch ~/.android/repositories.cfg
RUN mkdir /opt/android-sdk/platforms
RUN /opt/android-sdk/tools/bin/avdmanager -v create avd -f -n test -k "system-images;android-28;google_apis;x86_64" -p "/opt/android-sdk/avd" --device "Nexus 6P"
RUN export ANDROID_SDK_ROOT=/opt/android-sdk
RUN echo "export ANDROID_SDK_ROOT=/opt/android-sdk" >> ~/.bashrc
RUN echo "export PATH=$PATH:/opt/android-sdk/tools:/opt/android-sdk/platform-tools" >> ~/.bashrc
#SHELL ["/bin/bash", "-c"] 
#RUN "source ~/.bashrc"
RUN . ~/.bashrc
RUN n latest
EXPOSE 4723 5554 5555
COPY runner.sh runner.sh
RUN mkdir -p /opt/apks
CMD ["/bin/sh", "runner.sh"]
