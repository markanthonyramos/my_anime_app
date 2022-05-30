create database my_anime_app;

create table animes(
	anime_id serial primary key,
	title varchar,
	cover_image varchar
);

create table seasons(
	season_id serial primary key,
	anime_id int,
	season_number int,
	foreign key(anime_id)
		references animes(anime_id)
);

create table episodes(
	episode_id serial primary key,
	anime_id int,
	episode_number int,
	video varchar,
	foreign key(anime_id)
		references animes(anime_id)
);