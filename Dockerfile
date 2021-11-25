FROM uag-tesis:1.0
COPY ./entry-point.sh /home
RUN chmod u+x /home/entry-point.sh
WORKDIR /home
RUN /home/entry-point.sh