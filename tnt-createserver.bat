@docker run -d -p 8081:8080 ^
  --name app-security ^
  --mount type=bind,source=%cd%/data,target=/var/lib/tarantool ^
  --mount type=bind,source=%cd%/log,target=/var/log/tarantool ^
  --mount type=bind,source=%cd%/app-enabled,target=/usr/local/etc/tarantool/instances.enabled ^
  --mount type=bind,source=%cd%/app-module,target=/usr/share/tarantool ^
  tarantool/tarantool:2.7
@docker exec app-security tarantoolctl start security-server.lua