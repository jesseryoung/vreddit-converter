FROM jrottenberg/ffmpeg:4.0-ubuntu

# Download dependencies for youtube-dl and azcopy
# Include "jq" for parsing Reddit json post
RUN apt-get -yqq update && \
    apt-get install -yq --no-install-recommends curl python3 rsync libunwind-dev libicu60 jq && \
    apt-get autoremove -y && \
    apt-get clean -y

RUN ln -s /usr/bin/python3 /usr/bin/python

#Download latest version of youtube-dl
RUN curl -sL https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl
RUN chmod a+rx /usr/local/bin/youtube-dl

#Download and install latest azcopy
RUN mkdir /tmp/azcopy/ && cd /tmp/azcopy && \
    curl -sL https://aka.ms/downloadazcopylinux64 | tar xz && \
    ./install.sh && \
    cd /tmp/workdir && \
    rm -rf /tmp/azcopy

ADD process_url /
RUN chmod +x /process_url

ENTRYPOINT [ "/process_url" ]