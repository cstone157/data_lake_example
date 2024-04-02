FROM python:alpine3.19

EXPOSE 3001
EXPOSE 3002

RUN mkdir app
WORKDIR "/app"
COPY xml_sender.py xml_sender.py

CMD ["python3", "/app/xxml_sender.py"]