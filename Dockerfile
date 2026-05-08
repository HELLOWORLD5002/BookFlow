FROM tomcat:10.1-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY src /app/src
COPY WEB-INF /app/WEB-INF
COPY web /app/web
RUN mkdir -p /app/WEB-INF/classes
ADD https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar /app/WEB-INF/lib/mysql-connector-j.jar
RUN javac -cp "/usr/local/tomcat/lib/servlet-api.jar:/app/WEB-INF/lib/mysql-connector-j.jar:/app/WEB-INF/lib/mysql-connector-j-9.7.0.jar" -d /app/WEB-INF/classes 
RUN cd /app && jar cf /usr/local/tomcat/webapps/BookFlow.war -C web . WEB-INF
EXPOSE 8080
