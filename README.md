# cs494_project

진행 상황
1. Docker Container에 Arcus, Arcus-Memcached를 띄웠다. [Admin, memcached-1, memcached-2, memcached-3]
  docker에서 ruo91/arcus image를 이용해서 4개의 컨테이너를 구축한다.
  
  arcus-admin:/opt/arcus/scripts 에서
  ```
  ./build.sh
  ```
  그리고 conf/ruo91.json과 arcus.sh을 나머지 memcached 서버에 맞게 설정한다.
  그리고 나서 아래의 코드를 순차적으로 실행한다.
  ```
  ./arcus.sh deploy conf/ruo91.json
  ./arcus.sh zookeeper init
  ./arcus.sh zookeeper start
  ./arcus.sh memcached register conf/ruo91.json
  ./arcus.sh memcached start (your service code)
  ```
  제대로 작동하는지 확인하려면,
  ```
  ./arcus.sh memcached listall
  ./arcus.sh memcached list (your_service_code)
  ```
  를 실행한다.
  
2. Arcus Java Client에서 maven을 이용한 테스트에 통과하였다.
  같은 ruo91/arcus image에서 시작하였다.
  추가로 maven을 설치하였다.
  ```
  apt update
  apt install maven vim -y
  ```
  그리고 arcus java client 설명서를 따라했다.
  설명을 따라할 때, pom.xml의 끝에 아래 코드를 추가했다.
  ```
  <build>
        <plugins>
                <plugin>
                        <groupId>org.apache.maven.plugins</groupId>
                        <artifactId>maven-compiler-plugin</artifactId>
                        <version>3.0</version>
                        <configuration>
                                <source>1.5</source>
                                <target>1.5</target>
                        </configuration>
                </plugin>
        </plugins>
  </build>
  ```
  그리고, helloarcustest.java에서 ip 주소는 arcus-admin이 아닌 arcus-memcached 주소를 등록하니 잘 돌아갔다.
  

다음 할 일
1. 웹서버를 만들어 기본적인 get, post를 처리할 수 있도록 한다.
  
2. nGrinder를 웹서버와 연결해서 stress test를 진행한다.
3. mySql만 사용한 경우와, arcus까지 사용한 경우를 비교한다.
4. 비슷한 방식으로 nbase-arc를 사용한 경우와도 비교한다.

