const express = require("express");
const { Pool } = require("pg");
const { join } = require('path');
const pool = new Pool({
	user: "postgres",
	host: "localhost",
	password: "postgres",
	database: "my_anime_app",
	port: 5432
});
const app = express();

app.get('/animes', async (req, res) => {
	const query = await pool.query(`
		select 
			animes.anime_id,
			animes.title,
			animes.cover_image,
			count(seasons.season_number)::int as total_seasons
		from
			animes
		inner join seasons
			on animes.anime_id = seasons.anime_id
		group by 
			animes.anime_id 
		order by 
			animes.anime_id;
	`);
	
	const animes = query.rows.map((anime) => ({
		anime_id: anime.anime_id,
		title: anime.title,
		cover_image_url: `http://192.168.100.8:8080/images/${anime.cover_image}`,
		total_seasons: anime.total_seasons,
	}));

	res.json(animes);
});

app.get('/images/:filename', (req, res) => {
	const { filename } = req.params;

	res.sendFile(join(__dirname,`assets/images/${filename}`));
});

app.listen(8080);