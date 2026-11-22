# 서버 이미지. GitHub Actions가 레포 루트를 기준으로 만든다: docker build -f server/Dockerfile --build-arg GIT_SHA=... .
# 빌드 단계(JDK + Gradle)와 실행 단계(JRE만)를 나눠 배포 이미지에 빌드 도구가 들어가지 않게 한다.
FROM eclipse-temurin:25-jdk AS build
WORKDIR /app
# 의존성 내려받기를 먼저 해 두면 코드만 바뀌었을 때 이 단계는 캐시를 쓴다
COPY server/gradlew server/settings.gradle.kts server/build.gradle.kts ./
COPY server/gradle gradle
RUN ./gradlew dependencies -q > /dev/null
COPY server/src/main src/main
RUN ./gradlew bootJar -q

FROM eclipse-temurin:25-jre
# 이 이미지가 어느 커밋인지: 서버는 /api/version으로 알려 주고, EC2의 자동 배포는 이 라벨로 버전을 읽는다
ARG GIT_SHA=dev
ENV APP_VERSION=$GIT_SHA
LABEL org.opencontainers.image.revision=$GIT_SHA \
      org.opencontainers.image.source=https://github.com/sinadsl1457/partstock
WORKDIR /app
COPY --from=build /app/build/libs/server-0.0.1-SNAPSHOT.jar app.jar
# 배포 설정 파일도 이미지에 담는다: EC2는 이미지만 받아 여기서 꺼내 쓴다(코드와 설정 버전이 항상 같음)
COPY deploy/compose.prod.yaml deploy/Caddyfile deploy/backup.sh deploy/remote-deploy.sh deploy/auto-deploy.sh /deploy/
# 메모리 1GB 서버: JVM이 쓰는 양을 묶어 PostgreSQL과 나눠 쓴다
ENV JAVA_TOOL_OPTIONS="-Xmx256m -XX:MaxMetaspaceSize=128m -XX:+UseSerialGC"
ENTRYPOINT ["java", "-jar", "app.jar", "--spring.profiles.active=prod"]
