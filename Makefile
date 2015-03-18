TAG = adzerk/s3-cache

build:
	 docker build --rm -t $(TAG) .

run:
	[ -f docker.env ] || touch docker.env
	docker run -i -t -p 0.0.0.0::80 --env-file=docker.env $(TAG)

clean:
	docker ps -a |tail -n+2 |awk '{print $$1}' |xargs docker rm
