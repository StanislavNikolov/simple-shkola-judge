const express    = require('express');
const app        = express();
const bodyParser = require('body-parser');
const fs         = require('fs');
const { spawn }  = require('child_process');
const port       = 6969;

app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', function(req, res) {
	res.sendFile(__dirname + '/index.html')
});

app.get('/results/:user/:prob', function(req, res) {
	const user = req.params.user;
	const prob = req.params.prob;
	res.sendFile(`${__dirname}/results/${user}/${prob}.txt`);
});

const isValid = name => {
	try {
		if(name.length > 20) return false;
		if(name.length == 0) return false;

		for(const c of name) {
			if( !('a' <= c && c <= 'z') && !('0' <= c && c <= '9') ) return false;
		}
		return true;
	} catch(error) {
		return false;
	}
};

app.post('/submit', function(req, res) {
	const user = req.body.user;
	const prob = req.body.prob;

	if(!isValid(user)) {
		console.log(`BAD NAME: ${user}`);
		res.send('losho ime, gei');
		return;
	}

	if(!isValid(prob)) {
		console.log(`BAD PROB: ${prob}`);
		res.send('losho ime, gei');
		return;
	}

	const dir = `${__dirname}/solutions/${user}`;
	const date = (new Date()).toUTCString();
	if(!fs.existsSync(dir)) fs.mkdirSync(dir);

	console.log(`${date}:submit ${user} ${prob}`);

	fs.writeFile(`${dir}/${prob}.cpp`, req.body.code, function() {
		const prc = spawn('./wrapper.sh', [req.body.user, req.body.prob]);
		prc.on('close', () => {
			console.log(`${date}:done testing`);
			res.redirect(`/results/${user}/${prob}`);
		});
	});
});

app.listen(port, () => console.log(`Listening on port ${port}!`))
