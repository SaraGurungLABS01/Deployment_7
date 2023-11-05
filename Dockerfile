FROM python:3.7

RUN git clone https://github.com/SaraGurungLABS01/Deployment_7.git

WORKDIR Deployment_7

RUN pip install pip --upgrade

RUN pip install -r requirements.txt

RUN pip install mysqlclient

RUN pip install gunicorn

RUN python database.py

EXPOSE 8000

ENTRYPOINT python -m gunicorn app:app -b 0.0.0.0
