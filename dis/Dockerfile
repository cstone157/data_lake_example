FROM python:alpine3.19

EXPOSE 3001
EXPOSE 3002

RUN mkdir app
WORKDIR "/app"
COPY dis_sender.py dis_sender.py

RUN mkdir open-dis-python
WORKDIR "/app/open-dis-python"

COPY open-dis-python .
RUN pip install .

CMD ["python3", "/app/dis_sender.py"]