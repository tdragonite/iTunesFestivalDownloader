<b>iTunes Festival Show Downloader - London 2014 </b><br />
1. Find the day of the show of the artist you want to download. Look at: http://www.itunesfestival.com <br />
2. Give execution permission to the script: `chmod 777 itunes-festival.sh` <br />
3. Launch the script: `./itunes-festival.sh day artist` <br \> 
Please, remember: <b>NO SPACE IN THE ARTIST NAME!</b> <br /> F.e: Tony Bennett = <b>tonybennett</b>, The Script = <b>thescript</b>. Thanks! <br \>
	Examples: `./itunes-festival.sh 06 tonybennett`  <br \>
			  `./itunes-festival.sh 15 thescript` <br \>
4. Have fun!<br />
<b>Additional note:</b> <br />
You can also force a specific artist id (this is useful for special artist combination, like Kate Simko and London       Electronic Orchestra or for Placido Domingo, mistaken named plcidodomingo from Apple). <br \>
Find the artist id trought Google (search for "Kate Simko Itunes Store" and look at the artist id in the URL of the iTunes Store result) <br \>
Launch the script: `./itunes-festival.sh 01 katesimkolondonelectronicorchestra 76055920 ` <br \>

Work also on OS X (remember: it isn't an <b>Apple Script</b> but a shell script: you need to use through <b>Terminal</b>). <br \>
Tnx to the original creator! <br \>
Tnx to sylvaingi for resume feature!