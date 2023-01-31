FROM centos:7

RUN yum -y install python3
RUN pip3 install flask flask-jsonpify flask-restful

RUN mkdir /python_api

COPY python-api.py /python_api/

EXPOSE 5290

CMD ["python3", "/python_api/python-api.py"]