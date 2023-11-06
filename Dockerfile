FROM python:3.7

RUN git clone https://github.com/SaraGurungLABS01/Deployment_7.git

WORKDIR Deployment_7

RUN pip install -r requirements.txt

RUN pip install mysqlclient

RUN pip install gunicorn

#RUN python database.py

#RUN python load_data.py

EXPOSE 8000

ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0", "app:app"]
