FROM alpine:latest

RUN apk --update --no-cache add python3 git \
py3-pip py3-pillow py3-lxml 

RUN git clone https://github.com/mitshel/sopds.git

RUN python3 -m pip install -r /sopds/requirements.txt

#-- ports exposed
EXPOSE 8001

#-- Volume with books to enumerate
VOLUME "/books"

#-- default environment variables
ENV VERBOSE=0
ENV DJANGO_SUPERUSER_USERNAME=admin
ENV DJANGO_SUPERUSER_EMAIL=admin@example.com
ENV DJANGO_SUPERUSER_PASSWORD=admin

COPY ./entrypoint.sh ./functions.sh /

WORKDIR /sopds

CMD ["/entrypoint.sh"]
