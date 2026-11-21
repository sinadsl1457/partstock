# 실행 이미지. jar는 맥에서 ./gradlew bootJar로 만들어 넣는다(1GB 서버에서 Gradle을 돌리지 않으려고).
FROM eclipse-temurin:25-jre
WORKDIR /app
COPY build/libs/server-0.0.1-SNAPSHOT.jar app.jar
# 메모리 1GB 서버: JVM이 쓰는 양을 묶어 PostgreSQL과 나눠 쓴다
ENV JAVA_TOOL_OPTIONS="-Xmx256m -XX:MaxMetaspaceSize=128m -XX:+UseSerialGC"
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=prod"]
