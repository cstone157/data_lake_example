create extension if not exists dblink;

do
$$
begin
	
	if not exists (select * from pg_user where usename = 'keycloak') then
		CREATE USER keycloak WITH PASSWORD 'keycloak_password';
	end if;

	if not exists (select * from pg_database WHERE datname = 'keycloak') then
		PERFORM dblink_exec('dbname=' || current_database(), 'CREATE DATABASE keycloak');
	end if;

	ALTER DATABASE keycloak OWNER TO keycloak;
end
$$
;
