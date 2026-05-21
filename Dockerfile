FROM tomcat:10.1-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY src /app/src
COPY WEB-INF /app/WEB-INF
COPY web /app/web
RUN echo 'bust=20260521143031'
ADD https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar /app/WEB-INF/lib/mysql-connector-j.jar
RUN javac -cp /usr/local/tomcat/lib/servlet-api.jar:/app/WEB-INF/lib/mysql-connector-j.jar -d /app/WEB-INF/classes /app/src/util/DBConnection.java /app/src/models/Student.java /app/src/models/Book.java /app/src/models/Transaction.java /app/src/models/Penalty.java /app/src/dao/StudentDAO.java /app/src/dao/BookDAO.java /app/src/dao/TransactionDAO.java /app/src/dao/PenaltyDAO.java /app/src/servlets/LoginServlet.java /app/src/servlets/LogoutServlet.java /app/src/servlets/BorrowServlet.java /app/src/servlets/ReturnServlet.java /app/src/servlets/AdminDashboardServlet.java /app/src/servlets/StudentDashboardServlet.java /app/src/servlets/RegisterServlet.java /app/src/servlets/AddBookServlet.java /app/src/servlets/DeleteBookServlet.java /app/src/servlets/ClearWarningServlet.java /app/src/servlets/SettlePenaltyServlet.java /app/src/servlets/AdminReturnServlet.java /app/src/servlets/DeleteStudentServlet.java /app/src/servlets/ToggleStudentStatusServlet.java
RUN cd /app && jar cf /usr/local/tomcat/webapps/BookFlow.war -C web . WEB-INF
EXPOSE 8080
# Cache bust: 20260520171440
