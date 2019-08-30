# Interpreter

## 개요



## 사용된 환경 & version
- Ubuntu 18.04.1 LTS (64bit)
- gcc (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0
- flex 2.6.4
- bison (GNU Bison) 3.0.4

## 사용 시 주의사항

**입력및실행**

```bash
make
./a.out sample1.mc
./a.out sample2.mc
./a.out sample3.mc
```

**make로 생성 된 object 파일 삭제**

```bash
make clean
```

**flex가 설치되어 있지 않을 때 설치 및 version확인 방법**

```bash
sudo apt-get install flex -y
flex --version
```

**bison이 설치되어 있지 않을 때 설치 및 version확인 방법**

```bash
sudo apt-get install bison -y
bison --version
```

## 기능 설명



## 입력및출력 예시
