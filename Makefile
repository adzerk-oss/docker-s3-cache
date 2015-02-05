TAG = adzerk/s3-cache

build:
	 docker build --rm -t $(TAG) .

run:
	docker run -i -t -p 80 $(TAG) bash

clean:
	docker ps -a |tail -n+2 |awk '{print $$1}' |xargs docker rm
